; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 3.7
.386
.model  flat,stdcall
option casemap:none 
includelib \myasm\lib\kernel32.lib
ExitProcess proto :DWORD 
.code
start:
push 0
call ExitProcess
end  start
