onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb_main /tb_main/RSTN
add wave -noupdate -expand -group tb_main /tb_main/CLK
add wave -noupdate -expand -group tb_main /tb_main/apb_addr
add wave -noupdate -expand -group tb_main /tb_main/apb_sel0
add wave -noupdate -expand -group tb_main /tb_main/apb_enable
add wave -noupdate -expand -group tb_main /tb_main/apb_write
add wave -noupdate -expand -group tb_main /tb_main/apb_wdata
add wave -noupdate -expand -group tb_main /tb_main/apb_ready
add wave -noupdate -expand -group tb_main /tb_main/apb_rdata
add wave -noupdate -expand -group tb_main /tb_main/apb_slverr
add wave -noupdate -expand -group tb_main /tb_main/apb_rd_data
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PCLK
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PRESETn
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PADDR
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PSEL
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PENABLE
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PWRITE
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PWDATA
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PREADY
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PRDATA
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PSLVERR
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/IRQ
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/PWM
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/timer_mode
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/timer_go_en
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/timer_tot_cnt
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/timer_duty_cnt
add wave -noupdate -group TIMER_TOP /tb_main/TIMER_TOP/timer_irq_trg
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PCLK
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PRESETn
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PADDR
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PSEL
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PENABLE
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PWRITE
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PWDATA
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PREADY
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PRDATA
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/PSLVERR
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/MODE
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/GO_EN
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/TOT_CNT
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/DUTY_CNT
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/IRQ_TRG
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/IRQ
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/cs_reg
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/tot_cnt_reg
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/duty_cnt_reg
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/rd_data
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/pword_addr
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/apb_setup
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/apb_access
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/slv_err_flg
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/slv_err
add wave -noupdate -expand -group TIMER_REG /tb_main/TIMER_TOP/TIMER_REG/wr_en
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/CLK
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/RSTN
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/MODE
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/GO_EN
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/TOT_CNT
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/DUTY_CNT
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/IRQ_TRG
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/PWM
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/go_en_d1
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/go_lock
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/cnt
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/cnt_reset
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/pwm_toggle
add wave -noupdate -expand -group TIMER /tb_main/TIMER_TOP/TIMER/pwm_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {782489 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {5589207 ps}
