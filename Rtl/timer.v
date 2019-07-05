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

	// Lock signal
	reg				go_en_d1;
	always @(posedge CLK or negedge RSTN) begin
		if(!RSTN)	go_en_d1 <= 1'd0;
		else		go_en_d1 <= GO_EN;
	end
	wire			go_lock = !go_en_d1 & GO_EN;

	// Counter
	reg		[31:0]	cnt;
	wire			cnt_reset = (cnt==TOT_CNT);	
	always @(posedge CLK or negedge RSTN) begin
		if(!RSTN)				cnt <= 32'd0;
		else if(go_lock)		cnt <= 32'd0;
		else if(MODE&cnt_reset)	cnt <= 32'd0;
		else if(GO_EN)			cnt <= cnt + 1'd1;
	end

	// Counter IRQ
	assign		IRQ_TRG = ~MODE & GO_EN & cnt_reset;
	
	// PWM
	wire			pwm_toggle = (cnt==DUTY_CNT);
	reg				pwm_reg;
	always @(posedge CLK or negedge RSTN) begin
		if(!RSTN)				pwm_reg <= 1'd0;
		else if(MODE&GO_EN) begin
			if(go_lock)			pwm_reg <= 1'd0;
			else if(cnt_reset)	pwm_reg <= 1'd0;
			else if(pwm_toggle)	pwm_reg <= 1'd1;
		end
		else begin
								pwm_reg <= 1'd0;
		end
	end
	
	assign			PWM = pwm_reg;

endmodule
