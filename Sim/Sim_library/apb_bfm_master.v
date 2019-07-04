//*************************************************************************************************
//	File Name			: apb_bfm_master.v
//	Date				: 2019.03.20
//	Created by			: Junhee Jung
//	Description			: APB Bus Functional Model
//*************************************************************************************************

module	apb_bfm_master #(
		parameter		ADR_W	= 32,
		parameter		DAT_W	= 32
	)
	(
		input				PCLK,
		input				PRESETn,

		output	[ADR_W-1:0]	PADDR,
		output				PSEL0,
		output				PENABLE,
		output				PWRITE,
		output	[DAT_W-1:0]	PWDATA,
		input				PREADY,
		input	[DAT_W-1:0]	PRDATA,
		input				PSLVERR
	);
	
//=================================================================================================
// Signal declaration
//=================================================================================================
	localparam	APB_IDLE = 2'd0,
				APB_SETUP = 2'd1,
				APB_ACCESS = 2'd2;

	reg  [ADR_W-1:0] apb_addr  = {ADR_W{1'd0}};
	reg  			 apb_write = 1'd0;
	reg  [DAT_W-1:0] apb_wdata = {DAT_W{1'd0}};

	reg			transfer = 1'd0;

	reg  [1:0]	curr_state;
	reg  [1:0]	next_state;

//=================================================================================================
// FSM
//=================================================================================================
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn)	curr_state <= APB_IDLE;
		else			curr_state <= next_state;
	end

	always @(*) begin
		case(curr_state)
		APB_IDLE: begin
			if(transfer) next_state = APB_SETUP;
			else		 next_state = curr_state;
		end
		
		APB_SETUP: begin
			next_state = APB_ACCESS;
		end

		APB_ACCESS: begin
			if(PREADY&transfer)			next_state = APB_SETUP;
			else if(PREADY&!transfer)	next_state = APB_IDLE;
			else						next_state = curr_state;
		end
		endcase
	end

	assign	PSEL0 = (curr_state!=APB_IDLE);
	assign	PENABLE = (curr_state==APB_ACCESS);
	assign	PADDR = apb_addr;
	assign	PWRITE = apb_write;
	assign	PWDATA = apb_wdata;


//=================================================================================================
// Task
//=================================================================================================
	task apb_wr(
		input  [ADR_W-1:0] paddr,
		input  [DAT_W-1:0] pwdata
	);
	begin
		transfer = 1'd1;
		wait(curr_state!=APB_ACCESS);		// wait unfinished transaction

		apb_addr  = paddr;	
		apb_write = 1'd1;
		apb_wdata = pwdata;

		wait(PENABLE&PREADY);				// wait to finish transaction
		transfer = 1'd0;
	end
	endtask

	task apb_rd(
		input  [ADR_W-1:0] paddr,
		output [DAT_W-1:0] prdata
	);
	begin
		transfer = 1'd1;
		wait(curr_state!=APB_ACCESS);		// wait unfinished transaction

		apb_addr  = paddr;	
		apb_write = 1'd0;

		wait(PENABLE&PREADY);				// wait to finish transaction
		prdata = PRDATA;
		transfer = 1'd0;
	end
	endtask

endmodule
