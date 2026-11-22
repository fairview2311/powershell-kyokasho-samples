@echo off
rem パソコンの情報をファイルに書き出す（前任者 作）
set OUT=%~dp0pcinfo.txt
wmic computersystem get name,model /format:list > "%OUT%"
wmic os get caption,version /format:list >> "%OUT%"
wmic logicaldisk where drivetype=3 get deviceid,freespace,size >> "%OUT%"
type "%OUT%"
