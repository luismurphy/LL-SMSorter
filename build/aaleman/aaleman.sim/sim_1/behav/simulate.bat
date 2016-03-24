@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xsim controller_tb_behav -key {Behavioral:sim_1:Functional:controller_tb} -tclbatch controller_tb.tcl -view C:/Users/Aleman/Documents/1UPR-Mayaguez/Merge -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
