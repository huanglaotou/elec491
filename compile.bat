vlib work

@echo off
set VHDLDIR=.
vlog %VHDLDIR%\Buck_iL_Loop.v
vlog %VHDLDIR%\average_fliter.v
vlog %VHDLDIR%\clock_divider.v
vlog %VHDLDIR%\Buck_iL_Loop_top.v
rd /S /Q "../work"
move /Y work ..





pause
