//*************************************************************************************************
//	File Name			: timer.v
//	Date				: 2019.07.04
//	Created by			: Junhee Jung
//	Description			: Verilog Study - Timer Top module
//*************************************************************************************************

module	timer_top  #(
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
		
		output					IRQ,
		output					PWM
	);
	
	wire			timer_mode;
	wire			timer_go_en;
	wire	[31:0]	timer_tot_cnt;
	wire	[31:0]	timer_duty_cnt;
	wire			timer_irq_trg;

	timer_reg  #(
		.BASE_ADR	(BASE_ADR		),
		.ADR_W		(ADR_W			),
		.DAT_W		(DAT_W			)
	)
	TIMER_REG(
		.PCLK		(PCLK			),
		.PRESETn	(PRESETn		),
		.PADDR		(PADDR			),
		.PSEL		(PSEL			),
		.PENABLE	(PENABLE		),
		.PWRITE		(PWRITE			),
		.PWDATA		(PWDATA			),
		.PREADY		(PREADY			),
		.PRDATA		(PRDATA			),
		.PSLVERR	(PSLVERR		),
		
		.MODE		(timer_mode		),
		.GO_EN		(timer_go_en	),
		.TOT_CNT	(timer_tot_cnt	),
		.DUTY_CNT	(timer_duty_cnt	),
		.IRQ_TRG	(timer_irq_trg	),
		.IRQ		(IRQ			)
	);
	
	timer TIMER(
		.CLK		(PCLK			),
		.RSTN		(PRESETn		),

		.MODE		(timer_mode		),
		.GO_EN		(timer_go_en	),
		.TOT_CNT	(timer_tot_cnt	),
		.DUTY_CNT	(timer_duty_cnt	),
		.IRQ_TRG	(timer_irq_trg	),
		.PWM		(PWM			)
	);


endmodule
