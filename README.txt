Directory structure
	/build - Xilinx/Vivado projects go here
	/doc - design documentation is kept here
	/sim - simulation scripts, projects, and testbench files go here
	/src - source VHDL/Verilog files go here

1) Create new Vivado project
	Project location: Path/To/Repo/build
2) Choose RTL project, choose to include sources
3) Include /sim, /src, and merge_sorter_pkg.vhd as VHDL files
	Judiciously choose to if local copies will be made (I choose not, to use Vivado as an IDE)
4) Use ZC702 Zynq board