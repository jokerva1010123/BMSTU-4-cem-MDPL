; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 5.1
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
.data
z         db "��⭮�",13,10
nz        db "���⭮�",13,10
stdout    dd ?
cWritten  dd ?
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax 
mov ah, 37
and ah, 00000001b   ;�뤥�塞 ����訩 ���
cmp ah, 0           ;�⭮?
jz  evn             ;�� - ���� � evn
invoke  WriteConsoleA, stdout, ADDR nz, \
        sizeof nz, ADDR cWritten, NULL
jmp  exit
evn:
invoke  WriteConsoleA, stdout, ADDR z,\
        sizeof z, ADDR cWritten, NULL
exit:
invoke  ExitProcess, 0
end start
