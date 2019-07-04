//*************************************************************************************************
//	File Name			: apb_bfm_slave.v
//	Date				: 2019.03.20
//	Created by			: Junhee Jung
//	Description			: APB Bus Functional Model
//*************************************************************************************************

module	apb_bfm_slave #(
		parameter		BASE_ADR = 12'h0,		// Base address (MSB)
		parameter		ADR_W	 = 32,
		parameter		DAT_W	 = 32
	)
	(
		input				PCLK,
		input				PRESETn,

		input	[ADR_W-1:0]	PADDR,
		input				PSEL,
		input				PENABLE,
		input				PWRITE,
		input	[DAT_W-1:0]	PWDATA,
		output				PREADY,
		output	[DAT_W-1:0]	PRDATA,
		output				PSLVERR
	);
	
//=================================================================================================
//	Register list
//=================================================================================================
	localparam	REG_ADR0 = 18'h0,
				REG_ADR1 = 18'h1,
				REG_ADR2 = 18'h2,
				REG_ADR3 = 18'h3,
				REG_ADR4 = 18'h4,
				REG_ADR5 = 18'h5,
				REG_ADR6 = 18'h6,
				REG_ADR7 = 18'h7;
	localparam  REG_LAST = REG_ADR7;

	reg			CNT_RESET;		// 0x0
	reg			CNT_EN;			// 0x0
	reg  [31:0]	AW_CNT;			// 0x4
	reg  [31:0]	AR_CNT;			// 0x8
	reg  [31:0] W_CNT;			// 0xC
	reg  [31:0]	R_CNT;			// 0x10
	reg  [31:0] B_CNT;			// 0x14
	reg  [31:0] AW_BYTE_ACC;	// 0x18
	reg  [31:0] AR_BYTE_ACC;	// 0x1C
	
	
//=================================================================================================
//	Register control
//=================================================================================================
	wire [17:0]	pword_addr = PADDR[19:2];
	wire		apb_setup  = PSEL & (!PENABLE);
	wire		apb_access = PSEL & PENABLE;
	
	// address check
	wire		slv_err_flg = (PADDR[ADR_W-1:20]!=BASE_ADR)|(pword_addr>REG_LAST);
	reg			slv_err;
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn)		slv_err <= 1'd0;
		else if(apb_setup)	slv_err <= slv_err_flg;
	end

	// Write
	wire wr_en = apb_access & PWRITE & (!slv_err);			// Write @ apb_access
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
			CNT_RESET   <= 1'd0;
			CNT_EN      <= 1'd0;
			AW_CNT 		<= 32'd0;
			AR_CNT 		<= 32'd0;
			W_CNT		<= 32'd0;
			R_CNT		<= 32'd0;
			B_CNT		<= 32'd0;
			AW_BYTE_ACC	<= 32'd0;
			AR_BYTE_ACC	<= 32'd0;
		end
		else if(wr_en) begin
			case(pword_addr)
			REG_ADR0:	begin
				CNT_RESET <= PWDATA[0];
				CNT_EN    <= PWDATA[1];
			end
			REG_ADR1:	AW_CNT 		<= PWDATA[31:0];
			REG_ADR2:	AR_CNT 		<= PWDATA[31:0];
			REG_ADR3:	W_CNT		<= PWDATA[31:0];
			REG_ADR4:	R_CNT		<= PWDATA[31:0];
			REG_ADR5:	B_CNT		<= PWDATA[31:0];
			REG_ADR6:	AW_BYTE_ACC	<= PWDATA[31:0];
			REG_ADR7:	AR_BYTE_ACC	<= PWDATA[31:0];
			endcase
		end
	end
	
	// Read
	wire rd_en = apb_setup & !PWRITE & (!slv_err_flg);		// Read @ apb_setup
	reg	 [DAT_W-1:0] rd_data;
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) rd_data <= {DAT_W{1'd0}};
		else if(rd_en) begin
			case(pword_addr)
			REG_ADR0: rd_data <= {30'd0, CNT_EN, CNT_RESET};
			REG_ADR1: rd_data <= AW_CNT;
			REG_ADR2: rd_data <= AR_CNT;
			REG_ADR3: rd_data <= W_CNT;
			REG_ADR4: rd_data <= R_CNT;
			REG_ADR5: rd_data <= B_CNT;
			REG_ADR6: rd_data <= AW_BYTE_ACC;
			REG_ADR7: rd_data <= AR_BYTE_ACC;
			endcase
		end
	end

	// output
	assign	PREADY = 1'd1;
	assign	PRDATA = rd_data;
	assign	PSLVERR = slv_err;

endmodule
