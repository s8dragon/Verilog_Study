`timescale	1ns / 1ps


module tb_main;

//=================================================================================================
// System
//=================================================================================================  
// Reset
	reg     		RSTN;
	initial begin
		RSTN = 1'd0;
		#(50.0);
		RSTN = 1'd1;
	end

// Clock
`define		CLK_PERIOD		10.0
	
	reg				CLK = 1'd0;
	always begin
		#(`CLK_PERIOD/2.0)	CLK = ~CLK;
	end
	
//=================================================================================================
// DUT
//=================================================================================================  
	wire	[31:0]	apb_addr;
	wire			apb_sel0;
	wire			apb_enable;
	wire			apb_write;
	wire	[31:0]	apb_wdata;
	wire			apb_ready;
	wire	[31:0]	apb_rdata;
	wire			apb_slverr;
	
	wire			timer_irq;

	apb_bfm_master APB_BFM_MASTER(
		.PCLK		(CLK			),
		.PRESETn	(RSTN			),

		.PADDR		(apb_addr		),
		.PSEL0		(apb_sel0		),
		.PENABLE	(apb_enable		),
		.PWRITE		(apb_write		),
		.PWDATA		(apb_wdata		),
		.PREADY		(apb_ready		),
		.PRDATA		(apb_rdata		),
		.PSLVERR	(apb_slverr		)
	);

	timer_top  #(
		.BASE_ADR	(12'h44a		),
		.ADR_W		(32				),
		.DAT_W		(32				)
	)
	TIMER_TOP (
		.PCLK		(CLK			),
		.PRESETn	(RSTN			),
		.PADDR		(apb_addr		),
		.PSEL		(apb_sel0		),
		.PENABLE	(apb_enable		),
		.PWRITE		(apb_write		),
		.PWDATA		(apb_wdata		),
		.PREADY		(apb_ready		),
		.PRDATA		(apb_rdata		),
		.PSLVERR	(apb_slverr		),
		
		.IRQ		(timer_irq		),
		.PWM		(				)
	);

//=================================================================================================
// Stimulus
//=================================================================================================  
	reg		[31:0] apb_rd_data;

	// Master
	initial begin
		wait(RSTN);
	
		// Counter mode test
		#(`CLK_PERIOD*10);
		APB_BFM_MASTER.apb_wr(32'h44a00000, 32'h0);			// MODE: 0, GO_EN: 0
		APB_BFM_MASTER.apb_wr(32'h44a00004, 32'd128);		// TOT_CNT
		APB_BFM_MASTER.apb_wr(32'h44a00000, 32'h2);			// MODE: 0, GO_EN: 1
		
		#(`CLK_PERIOD*10);
		APB_BFM_MASTER.apb_wr(32'h44a0000c, 32'hffffffff);	// address error check
		APB_BFM_MASTER.apb_wr(32'h44a00010, 32'hffffffff);	// address error check

		#(`CLK_PERIOD*10);
		APB_BFM_MASTER.apb_rd(32'h44a00000, apb_rd_data);	// write verify
		APB_BFM_MASTER.apb_rd(32'h44a00004, apb_rd_data);
		APB_BFM_MASTER.apb_rd(32'h44a00008, apb_rd_data);

		// Counter IRQ clear		
		wait(timer_irq);
		APB_BFM_MASTER.apb_wr(32'h44a00000, 32'h0);			// MODE: 0, GO_EN: 0
		
		// PWM mode test
		#(`CLK_PERIOD*50);
		APB_BFM_MASTER.apb_wr(32'h44a00000, 32'h1);			// MODE: 1, GO_EN: 0
		APB_BFM_MASTER.apb_wr(32'h44a00004, 32'd64);		// TOT_CNT
		APB_BFM_MASTER.apb_wr(32'h44a00008, 32'd25);		// DUTY_CNT
		APB_BFM_MASTER.apb_wr(32'h44a00000, 32'h3);			// MODE: 1, GO_EN: 1
		
		#(`CLK_PERIOD*600);
		APB_BFM_MASTER.apb_wr(32'h44a00000, 32'h1);			// MODE: 1, GO_EN: 0
		
	end
	

endmodule
