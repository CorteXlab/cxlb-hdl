######################################################################
# create library options_switch_lib
vlib options_switch_lib

# map library options_switch_lib to work
vmap work options_switch_lib

######################################################################
# compiling vhd files
vcom -93 -work options_switch_lib "../hdl/vhdl/options_switch.vhd"
vcom -93 -work options_switch_lib "../testbench/options_switch_tb.vhd"
######################################################################

# loading options_switch_tb for simulation
vsim -t 1ns options_switch_lib.options_switch_tb

# open wave and signals signal windows
view signals
view wave
# add signals to wave 
add wave *

radix hex
# launch simulation
run 100 ms
# quit -sim
