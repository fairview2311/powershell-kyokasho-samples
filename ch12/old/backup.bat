@echo off
rem 共有フォルダーを、日付つきのフォルダーにバックアップする（前任者 作）
set SRC=%~dp0..\practice\share
set DST=%~dp0..\backup
set TODAY=%date:~0,4%%date:~5,2%%date:~8,2%

if not exist "%DST%" mkdir "%DST%"
xcopy "%SRC%" "%DST%\share-%TODAY%\" /E /I /Y > nul
echo %date% %time% バックアップしました: share-%TODAY% >> "%DST%\backup.log"

rem 30日より古いバックアップを消す
forfiles /p "%DST%" /m "share-*" /d -30 /c "cmd /c if @isdir==TRUE rd /s /q @path" 2> nul
