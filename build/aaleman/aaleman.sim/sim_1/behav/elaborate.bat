@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto f57c254d562946659885a41585853087 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot controller_tb_behav xil_defaultlib.controller_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
