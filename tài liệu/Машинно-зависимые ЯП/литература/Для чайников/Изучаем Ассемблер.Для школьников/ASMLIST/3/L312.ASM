; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 3.12
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
StrDisp    proto :DWORD, :DWORD
.data
msg db	"�� ���� ������!",0dh,0ah
.code
start:
invoke  StrDisp, ADDR msg,sizeof msg
invoke  ExitProcess, 0
StrDisp proc StrAddr:DWORD, StrSz:DWORD
sub esp,8 ;���� �������� ��६�����
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov [ebp-4], eax
invoke  WriteConsoleA, [ebp-4], [ebp+8], \
        [ebp+12], ADDR [ebp-8], NULL
ret 8 ;�᢮������ �⥪ �� ��ࠬ��஢
StrDisp endp
end start
