set arg1=%1
REM powershell -noexit -executionpolicy bypass -File %arg1%
powershell -executionpolicy bypass -File %arg1%