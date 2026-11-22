@echo off
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File "%~dp0hello.ps1"
pause
