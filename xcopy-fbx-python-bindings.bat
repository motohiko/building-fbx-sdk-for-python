@echo off

xcopy "C:\Program Files\Autodesk\FBX\FBX Python Bindings\2020.1.1" "%~dp02020.1.1" /e /i /y
xcopy "%~dp0patch\FBX Python Bindings\2020.1.1" "%~dp02020.1.1" /e /i /y

cmd /k
