@echo off

set FBXSDK_ROOT=C:\Program Files\Autodesk\FBX\FBX SDK\2020.1.1
echo %FBXSDK_ROOT%

set SIP_ROOT=%~dp0sip-4.19.3
echo %SIP_ROOT%

pushd "%~dp02020.1.1"
python PythonBindings.py Python3_x64 buildsip
popd

cmd /k
