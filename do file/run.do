vlib work
vlog -f "do file/list.list" -mfcu +cover -covercells
vsim -voptargs=+acc work.tb_top -cover -classdebug -uvmcontrol=all
add wave /tb_top/DUT/*
coverage save top.ucdb -onexit -du work.counter
run -all
coverage report -detail -cvg -directive -comments -output reports/counter_cover_report.txt /counter_coverage_pkg/counter_coverage/counter_crg
#quit -sim
vcover report top.ucdb -details -annotate -all -output reports/counter_report.txt
