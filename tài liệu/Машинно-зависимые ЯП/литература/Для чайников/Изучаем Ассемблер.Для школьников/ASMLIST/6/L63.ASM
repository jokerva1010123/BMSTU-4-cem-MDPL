; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 6.3
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
LLNG     equ 128
.data
stdout   dd ? ;���ਯ�� ��࠭�
cWritten dd ? ;�᫮ ���������� ᨬ�����
CLIni    dd ? ;��砫� ��������� ��ப�
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke GetCommandLine  ;���� ���������
                       ; ��ப�
mov CLIni, eax         ;��������� ����
                       ; ��������� ��ப�
mov edi, eax    ;edi = ���. ���. ���.
cld             ;�㤥� 㢥��稢��� ����
mov ecx, LLNG   ;����. ��. ���. ��ப�
mov al, 0       ;�饬 0
repne  scasb    ;���� ���
sub edi, CLIni  ;edi = ����� ��ப�
invoke  WriteConsole,  stdout,
        CLIni, edi, ADDR cWritten, NULL
invoke  ExitProcess, 0
end start
