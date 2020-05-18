@ECHO OFF
REM Copyright 2020 Radek Svarz.
REM Use of this source code is governed by a Zero Clause BSD license.

REM Generates the git_info.g.dart file with the information on current git commit

SETLOCAL ENABLEDELAYEDEXPANSION

FOR %%i IN ("%~dp0..") DO SET PROJECT_ROOT=%%~fi

REM Test if Git is available on the Host
where /q git || ECHO Error: Unable to find git in your PATH. && EXIT /B 1

REM ECHO %PROJECT_ROOT%

REM  Test if the project directory is git activated, otherwise git rev-parse HEAD would fail
IF NOT EXIST "%PROJECT_ROOT%\.git" (
  ECHO Error: The project directory %PROJECT_ROOT% is not git activated.
  ECHO        You need to setup git with git init or git clone;
  EXIT /B 1
)

ECHO Checking git commit in %PROJECT_ROOT%

FOR /f "tokens=*" %%i in ('git rev-parse --short HEAD') DO SET SHORTSHA=%%i

REM For whatever reason this does not work
REM FOR /f "tokens=*" %%i in ('git show -s --format=%B HEAD') DO SET MESSAGE=%%i

(
ECHO // This is a generated file. Run .\tools\git_commit_info.bat for update
ECHO // Do not commit this file, add it to .gitignore instead.
ECHO // Usage in flutter: 
ECHO // import 'git_info.g.dart' as gitInfo
ECHO // Text^(gitInfo.shortSHA^)
ECHO String shortSHA = "%SHORTSHA%";
REM ECHO String message = "%MESSAGE%"
) > %PROJECT_ROOT%\lib\git_info.g.dart
 
ENDLOCAL
