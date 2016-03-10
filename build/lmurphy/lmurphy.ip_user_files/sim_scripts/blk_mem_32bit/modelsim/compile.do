vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vcom -work xil_defaultlib -64 -93 \
"./../../../../lmurphy.srcs/sources_1/ip/blk_mem_32bit/blk_mem_32bit_sim_netlist.vhdl" \


quit -f

