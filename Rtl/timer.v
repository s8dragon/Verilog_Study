//*************************************************************************************************
//	File Name			: timer.v
//	Date				: 2019.07.04
//	Created by			: Junhee Jung
//	Description			: Verilog Study - Timer module
//*************************************************************************************************

module	timer (
		input			CLK,
		input			RSTN,
		
		input			MODE,
		input			GO_EN,
		input	[31:0]	TOT_CNT,
		input	[31:0]	DUTY_CNT,
		output			IRQ_TRG,
		output			PWM
	);
	
	// TO BE CONTINUED...
	assign				IRQ_TRG = 1'd0;
	assign				PWM = 1'd0;


endmodule
