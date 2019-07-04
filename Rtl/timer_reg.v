//*************************************************************************************************
//	File Name			: timer.v
//	Date				: 2019.07.04
//	Created by			: Junhee Jung
//	Description			: Verilog Study - Timer Register Setting module
//*************************************************************************************************

module	timer_reg  #(
		parameter		BASE_ADR = 12'h0,		// Base address (MSB)
		parameter		ADR_W	 = 32,
		parameter		DAT_W	 = 32
	)
	(
		// APB domain
		input					PCLK,
		input					PRESETn,
		input	[ADR_W-1:0]		PADDR,
		input					PSEL,
		input					PENABLE,
		input					PWRITE,
		input	[DAT_W-1:0]		PWDATA,
		output					PREADY,
		output	[DAT_W-1:0]		PRDATA,
		output					PSLVERR,
		
		output					MODE,
		output					GO_EN,
		output	[31:0]			TOT_CNT,
		output	[31:0]			DUTY_CNT,
		input					IRQ_TRG,
		output					IRQ
	);
	
//=================================================================================================
//	Register list
//=================================================================================================
	reg  [2:0]			cs_reg;			// CSR : {IRQ,GO_EN,MODE}
	reg  [31:0]			tot_cnt_reg;
	reg  [31:0]			duty_cnt_reg;
	reg  [DAT_W-1:0] 	rd_data;
	
//=================================================================================================
//	Register control (APB domain)
//=================================================================================================
	wire [17:0]	pword_addr = PADDR[19:2];
	wire		apb_setup  = PSEL & (!PENABLE);
	wire		apb_access = PSEL & PENABLE & PREADY;

	// address check
	wire		slv_err_flg = (PADDR[ADR_W-1:20]!=BASE_ADR) | (pword_addr>18'd3);
	reg			slv_err;
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn)		slv_err <= 1'd0;
		else if(apb_setup)	slv_err <= slv_err_flg;
	end

	// Write
	wire wr_en  = apb_access & PWRITE & (!slv_err);			// Write @ apb_access
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
			cs_reg       <= 32'd0;
			tot_cnt_reg  <= 32'd0;
			duty_cnt_reg <= 32'd0;
		end
		else if(wr_en) begin
			case(pword_addr[1:0])
			2'd0  : cs_reg       <= PWDATA[2:0];
			2'd1  : tot_cnt_reg  <= PWDATA;
			2'd2  : duty_cnt_reg <= PWDATA;
			endcase
		end
		else if(!MODE & IRQ_TRG) begin
			cs_reg <= {1'd1,1'd0,1'd0};						// IRQ=1, GO_EN=0, MODE=0
		end
	end

	// Read	
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
			rd_data <= 32'd0;
		end
		else if(apb_setup) begin
			if(slv_err_flg) begin
				rd_data <= 32'd0;
			end
			else begin
				case(pword_addr[1:0])
				2'd0  : rd_data <= cs_reg;
				2'd1  : rd_data <= tot_cnt_reg;
				2'd2  : rd_data <= duty_cnt_reg;
				2'd3  : rd_data <= 32'd0;
				endcase
			end
		end
	end

	// APB output
	assign	PREADY = 1'd1;
	assign	PRDATA = rd_data;
	assign	PSLVERR = slv_err;
	
	// Register setting output
	assign	MODE = cs_reg[0];
	assign	GO_EN = cs_reg[1];
	assign 	IRQ = cs_reg[2];
	assign	TOT_CNT = tot_cnt_reg;
	assign	DUTY_CNT = duty_cnt_reg;

endmodule
