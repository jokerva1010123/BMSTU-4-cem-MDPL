; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 5.3
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\user32.lib
includelib \myasm\lib\kernel32.lib
BSIZE     equ 20
.data
digit     db BSIZE dup (?)
cWritten  dd ?
stdout    dd ?
.code
start:  
mov  esi, BSIZE
mov  eax, 123456789
mov  ebx, 1315678
mul  ebx
mov  ebx, edx
mov  ecx,10     ;����� �� 10
nxt: 
dec  esi        ;������ ᫥�. ᨬ����
xchg eax, ebx   ;�����
sub  edx, edx   ; ������
div  ecx        ; ��������
xchg eax, ebx   ;��࠭塞 ��⭮� � �����
div  ecx        ;���⮪ + ������� ��������
add  dl, 48     ;�ॢ�頥� � ᨬ��� 
mov  digit[esi], dl   ;��࠭塞 ᨬ���
mov  edx, ebx
or   edx, eax   ;��� ����� = 0?
jnz  nxt        ;��� - �த�����
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov  stdout, eax
mov  eax, offset digit;��砫� ���ᨢ�
add  eax, esi         ;���� ��ࢮ��
 		      ; ᨬ����
mov  edx, BSIZE
sub  edx, esi         ;�᫮ ᨬ�����
invoke  WriteConsoleA, stdout, eax, edx, \
        ADDR cWritten, NULL
invoke  ExitProcess, 0
end start
