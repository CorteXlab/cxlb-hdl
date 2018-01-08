@ECHO OFF
@REM ###########################################
@REM # Script file to run the vsim 
@REM # 
@REM ###########################################
@REM #
@REM # Command line for vsim
@REM #
set VSIM=C:\Modeltech_pe_edu_10.3b\win32pe_edu\vsim.exe
set PATH=%~dp0
echo ======================
echo PATH = %PATH%
echo ======================
cd %PATH%
mkdir vector_test
set compile_script="options_switch_tb.do"
echo ======================
echo compile_script = %compile_script%
echo ======================
echo ////////////////////////////////////////////////
echo %VSIM%
echo ////////////////////////////////////////////////

%VSIM% -do %compile_script%
