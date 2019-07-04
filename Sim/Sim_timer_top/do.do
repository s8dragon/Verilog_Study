#Script for Questa

vlib work
alias d "vdel -all"
alias c "vlog -f run.f -logfile ./log/vlog_eyenix.log +incdir+../../Rtl/bus/_inc +incdir+../Sim_library"
alias x "vopt +acc=rn tb_main -o tb_main_opt -logfile ./log/vopt_eyenix.log"
alias xx "vopt +noacc tb_main -o tb_main_opt -logfile ./log/vopt_eyenix.log"
alias l "vsim tb_main_opt -do run_questa.scr -wlf ./wave/wave.wlf -logfile ./log/vsim_eyenix.log"
alias r "restart -f -do run_questa.scr -wlf ./wave/wave.wlf"
alias rr "run 15 ms"
alias a "do wave.do"
alias v "write format wave wave.do"

alias h "
echo ---------------------------------------------------------------------
echo
echo d  : vdel
echo c  : vlog
echo x  : vopt +acc
echo xx : vopt +noacc=rn
echo l  : vsim
echo r  : restart
echo rr : run 15 ms
echo a  : view wave
echo v	: write wave
echo h  : help
echo
echo ---------------------------------------------------------------------
"
h
