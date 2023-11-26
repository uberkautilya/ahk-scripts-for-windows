@echo off
setlocal enabledelayedexpansion

REM Get today's date and time in the format yyyyMMdd_HHmm
for /f "tokens=1-4 delims=- " %%i in ('date /t') do (
    set year=%%i
    set month=%%j
    set day=%%k
)
for /f "tokens=1-3 delims=: " %%i in ('time /t') do (
    set hour=%%i
    set minute=%%j
    set second=%%k
)
set timestamp=%year%_%month%_%day%_%hour%_%minute%_%second%
echo %timestamp%
set /p continue=Do you want to continue? (y/n)
if /i not %continue% == "y" (
	exit /b
)

REM Create the new directory
mkdir %timestamp%

REM Move all files in the current directory to the new directory, excluding files in the Archived directory
REM /b is to list out only the file names, and not other attributes of the files
REM /a to list all files. /a-d could be used to exclude directories being listed. The below works
for /f "delims=" %%a in ('dir /b /a ^| findstr /v /i /c:"Archived" ^| findstr /v /i /c:"move"') do (
	echo %%a
    move "%%a" %timestamp%
)
move %timestamp% Archived\
set timestamp=%year%_%month%_%day%_%hour%_%minute%
mkdir %timestamp%


REM for /r %%a in (*) do (
REM     if not "%%~dpa"=="%cd%\Archived\" (
REM         if not "%%~nxa"=="move.bat" (
REM             move "%%a" %timestamp%
REM         )
REM     )
REM )
echo All files have been moved to Archived folder.
pause