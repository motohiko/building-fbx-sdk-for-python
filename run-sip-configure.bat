@echo off

pushd %~dp0sip-4.19.3
python configure.py
popd

cmd /k
