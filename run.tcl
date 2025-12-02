vlog -sv -cover bces dual_port_memory_top_module2.sv

vsim -gui -coverage -assertdebug -voptargs=+acc top_testbench

run -all

coverage save -assert -directive -cvg -codeAll cov.ucdb

vcover report -html -output covhtmlreport \
    -details -assert -directive -cvg \
    -code bces \
    -threshL 50 -threshH 90 \
    cov.ucdb

firefox covhtmlreport/index.html &

