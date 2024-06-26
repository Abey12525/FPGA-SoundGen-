transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {H:/My Documents/Downloads/ADS/AUDIO/audioController.vhd}

vcom -93 -work work {H:/My Documents/Downloads/ADS/AUDIO/simulation/modelsim/testBench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  testBench

add wave *
view structure
view signals
run -all
