//*************************************************************************************************
//	File Name			: axi_profile_reg.v
//	Date				: 2019.03.20
//	Created by			: Junhee Jung
//	Description			: AXI profiler register
//*************************************************************************************************

module	axi_profile_reg #(
		parameter		BASE_ADR = 12'h0,		// Base address (MSB)
		parameter		ADR_W	 = 32,
		parameter		DAT_W	 = 32
	)
	(
		// AXI domain
		input				ACLK,
		input				ARESETn,
		input	[31:0]		AXI_AW_CNT,
		input	[31:0]		AXI_W_CNT,
		input	[31:0]		AXI_B_CNT,
		input	[31:0]		AXI_AR_CNT,
		input	[31:0]		AXI_R_CNT,
		output				AXI_CNT_RESET,
		output				AXI_CNT_EN,

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
	
//=================================================================================================
//	Register list
//=================================================================================================
	localparam	REG_ADR0 = 18'h0,
				REG_ADR1 = 18'h1,
				REG_ADR2 = 18'h2,
				REG_ADR3 = 18'h3,
				REG_ADR4 = 18'h4,
				REG_ADR5 = 18'h5;
	localparam  REG_LAST = REG_ADR5;

	reg			CNT_RESET;		// 0x0
	reg			CNT_EN;			// 0x0

//=================================================================================================
//	AXI <=> APB CDC 
//=================================================================================================
	// Handshake synchronization (request/ack)
	reg  		rd_req_apb;
	wire		rd_req_axi;
	reg			rd_ack_axi;
	wire		rd_ack_apb;
	reg  [2:0]	rd_sel_apb;

	// APB => AXI : synchronizer
	reg	 [1:0]	cnt_reset_cdc;
	reg  [1:0]	cnt_en_cdc;
	reg  [1:0]	rd_req_cdc;
	always @(posedge ACLK or negedge ARESETn) begin
		if(!ARESETn) begin
			cnt_reset_cdc <= 2'd0;
			cnt_en_cdc <= 2'd0;
			rd_req_cdc <= 2'd0;
		end
		else begin
			cnt_reset_cdc <= {cnt_reset_cdc[0], CNT_RESET};
			cnt_en_cdc <= {cnt_en_cdc[0], CNT_EN};
			rd_req_cdc <= {rd_req_cdc[0], rd_req_apb};
		end
	end
	assign	AXI_CNT_RESET = cnt_reset_cdc[1];
	assign	AXI_CNT_EN = cnt_en_cdc[1];
	assign	rd_req_axi = rd_req_cdc[1];

	// AXI => APB : synchronizer
	reg	 [1:0]	rd_ack_cdc;
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn)	rd_ack_cdc <= 2'd0;
		else			rd_ack_cdc <= {rd_ack_cdc[0], rd_ack_axi};
	end
	assign		rd_ack_apb = rd_ack_cdc[1];

//=================================================================================================
//	Register read (AXI domain)
//=================================================================================================
    localparam	AXI_RD_IDLE    = 1'd0,
				AXI_RD_REQ_FIN = 1'd1;
	reg  	    rd_state_axi;
	reg	 [31:0] rd_data_axi;
	always @(posedge ACLK or negedge ARESETn) begin
		if(!ARESETn) begin
			rd_state_axi <= AXI_RD_IDLE;
			rd_data_axi  <= 32'd0;
			rd_ack_axi   <= 1'd0;
		end
		else begin
			case (rd_state_axi)
			AXI_RD_IDLE: begin					// rd_ack_axi==1'd0
				if(rd_req_axi) begin
					rd_state_axi <= AXI_RD_REQ_FIN; 
					case(rd_sel_apb)			// CDC occur @ stable point
					REG_ADR0[2:0]: rd_data_axi <= {30'd0, CNT_EN, CNT_RESET};		// APB domain registers
					REG_ADR1[2:0]: rd_data_axi <= AXI_AW_CNT;						// AXI domain registers
					REG_ADR2[2:0]: rd_data_axi <= AXI_W_CNT;
					REG_ADR3[2:0]: rd_data_axi <= AXI_B_CNT;
					REG_ADR4[2:0]: rd_data_axi <= AXI_AR_CNT;
					REG_ADR5[2:0]: rd_data_axi <= AXI_R_CNT;
					endcase
					rd_ack_axi <= 1'd1;
				end
				else begin
					rd_ack_axi <= 1'd0;
				end
			end

			AXI_RD_REQ_FIN: begin				// rd_ack_axi==1'd1
				if(!rd_req_axi) begin
					rd_state_axi <= AXI_RD_IDLE;
					rd_ack_axi   <= 1'd0;
				end
			end

			endcase
		end
	end

//=================================================================================================
//	Register control (APB domain)
//=================================================================================================
	wire [17:0]	pword_addr = PADDR[19:2];
	wire		apb_setup  = PSEL & (!PENABLE);
	wire		apb_access = PSEL & PENABLE & PREADY;

	// address check
	wire		slv_err_flg = (PADDR[ADR_W-1:20]!=BASE_ADR)|(pword_addr>REG_LAST);
	reg			slv_err;
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn)		slv_err <= 1'd0;
		else if(apb_setup)	slv_err <= slv_err_flg;
	end

	// Write
	reg  wr_rdy;
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn)				wr_rdy <= 1'd0;
		else if(apb_setup&PWRITE)	wr_rdy <= 1'd1;
		else if(apb_access)			wr_rdy <= 1'd0;
	end

	wire wr_en  = apb_access & PWRITE & (!slv_err);			// Write @ apb_access
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
			CNT_RESET   <= 1'd0;
			CNT_EN      <= 1'd0;
		end
		else if(wr_en) begin
			if (pword_addr==REG_ADR0) begin
				CNT_RESET <= PWDATA[0];
				CNT_EN    <= PWDATA[1];
			end
		end
	end
	
	// Read
	// Handshake synchronization (request/ack)
    localparam	RD_IDLE       = 2'd0,
				RD_REQUESTING = 2'd1,
				RD_ACK_FIN    = 2'd2;
	reg  [1:0]	rd_state;
	reg	 [31:0] rd_data;
	always @(posedge PCLK or negedge PRESETn) begin
		if(!PRESETn) begin
			rd_state   <= RD_IDLE;
			rd_sel_apb <= 3'd0;
			rd_req_apb <= 1'd0;
			rd_data    <= 32'd0;
		end
		else begin
			case (rd_state)
			RD_IDLE: begin							// rd_req_apb==1'd0
				if(apb_setup&(!PWRITE)) begin
					if (!slv_err_flg) begin
						rd_state   <= RD_REQUESTING;
						rd_sel_apb <= pword_addr[2:0];
						rd_req_apb <= 1'd1;
					end
					else begin
						rd_state   <= RD_ACK_FIN;
						rd_data    <= 32'd0;		// return 0 if address error
						rd_req_apb <= 1'd0;
					end
				end
				else begin
					rd_req_apb <= 1'd0;
				end
			end

			RD_REQUESTING: begin					// rd_req_apb==1'd1
				if(rd_ack_apb) begin
					rd_state   <= RD_ACK_FIN;
					rd_data    <= rd_data_axi;		// CDC occur @ stable point
					rd_req_apb <= 1'd0;
				end
			end

			RD_ACK_FIN: begin						// rd_req_apb==1'd0
				if(!rd_ack_apb) begin
					rd_state <= RD_IDLE;
				end
			end

			endcase
		end
	end

	wire	rd_rdy = (rd_state==RD_ACK_FIN) & (!rd_ack_apb);

	// output
	assign	PREADY = wr_rdy|rd_rdy;
	assign	PRDATA = rd_data;
	assign	PSLVERR = slv_err;

endmodule
