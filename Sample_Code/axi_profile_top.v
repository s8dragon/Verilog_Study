//*************************************************************************************************
//	File Name			: axi_profile_top.v
//	Date				: 2019.03.21
//	Created by			: Junhee Jung
//	Description			: AXI profiler
//*************************************************************************************************

`include "axi.h"

module	axi_profile_top #(
		parameter		BASE_ADR = 12'h0,
		parameter		ADR_W	 = 32,
		parameter		DAT_W	 = 32
	)
	(
		// AXI domain
		input			S_ACLK,
		input			S_ARESETn,
		input			S_AWVALID,
		input			S_AWREADY,
		input			S_WVALID,
		input			S_WREADY,
		input			S_BVALID,
		input			S_BREADY,
		input			S_ARVALID,
		input			S_ARREADY,
		input			S_RVALID,
		input			S_RREADY,

		// APB domain
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

	wire		cnt_reset;
	wire		cnt_en;
	
	reg  [31:0] aw_cnt;
	reg  [31:0] w_cnt;
	reg  [31:0] b_cnt;
	reg  [31:0] ar_cnt;
	reg  [31:0] r_cnt;
	always @(posedge S_ACLK or negedge S_ARESETn) begin
		if(!S_ARESETn) begin
			aw_cnt <= 32'd0;
			w_cnt  <= 32'd0;
			b_cnt  <= 32'd0;
			ar_cnt <= 32'd0;
			r_cnt  <= 32'd0;
		end
		else if (cnt_reset) begin
			aw_cnt <= 32'd0;
			w_cnt  <= 32'd0;
			b_cnt  <= 32'd0;
			ar_cnt <= 32'd0;
			r_cnt  <= 32'd0;
		end
		else if (cnt_en) begin
			if(S_AWVALID & S_AWREADY)	aw_cnt <= aw_cnt + 1'd1;
			if(S_WVALID  & S_WREADY)	w_cnt  <= w_cnt  + 1'd1;
			if(S_BVALID  & S_BREADY)	b_cnt  <= b_cnt  + 1'd1;
			if(S_ARVALID & S_ARREADY)	ar_cnt <= ar_cnt + 1'd1;
			if(S_RVALID  & S_RREADY)	r_cnt  <= r_cnt  + 1'd1;
		end
	end

	axi_profile_reg #(
		.BASE_ADR		(BASE_ADR		),
		.ADR_W			(ADR_W			),
		.DAT_W			(DAT_W			)
	)
	AXI_PROFILE_REG
	(
		.ACLK			(S_ACLK			),
		.ARESETn		(S_ARESETn		),
		.AXI_AW_CNT		(aw_cnt			),
		.AXI_W_CNT		(w_cnt			),
		.AXI_B_CNT		(b_cnt			),
		.AXI_AR_CNT		(ar_cnt			),
		.AXI_R_CNT		(r_cnt			),
		.AXI_CNT_RESET	(cnt_reset		),
		.AXI_CNT_EN		(cnt_en			),

		.PCLK			(PCLK			),
		.PRESETn		(PRESETn		),
		.PADDR			(PADDR			),
		.PSEL			(PSEL			),
		.PENABLE		(PENABLE		),
		.PWRITE			(PWRITE			),
		.PWDATA			(PWDATA			),
		.PREADY			(PREADY			),
		.PRDATA			(PRDATA			),
		.PSLVERR		(PSLVERR		)
	);

endmodule
