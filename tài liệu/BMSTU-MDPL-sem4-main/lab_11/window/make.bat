echo off
cls
set AsmDir=c:\masm32\bin

%AsmDir%\ml.exe /c /coff /Cp resdlg2.asm

%AsmDir%\rc.exe rsrc.rc

%AsmDir%\link.exe /subsystem:windows resdlg2.obj rsrc.res

:ScriptEnd
pause