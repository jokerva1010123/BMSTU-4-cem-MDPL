; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 3.10
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
.data
stdout  	dd	?
msg		db	"�� ���� ������!",0dh,0ah
cWritten	dd	? 
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke  WriteConsoleA, stdout, ADDR msg, \
        sizeof msg, ADDR    cWritten, NULL
invoke  ExitProcess, 0
end start
