; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 5.2
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\windows.inc
include    \myasm\include\user32.inc
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
includelib \myasm\lib\user32.lib
DateDisp proto :WORD
BSIZE equ 15
.data
ifmt      db "%d",0
buf       db BSIZE dup(0)
stdout    dd ?
cWritten  dd ?
month	  db "ﭢ 䥢 ��� ��� ��� �� "
          db "�� ��� ᥭ ��� ��� ���"
.code
start:
invoke  GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax 
mov  ax, 0f383h     ;30 ��� 2003 ����
invoke DateDisp, ax ;�������� ����
invoke  ExitProcess, 0
DateDisp proc Date:WORD
xor edi,edi         ;��頥� ॣ����
mov di, Date
rol di, 5           ;�᫮ - � ���� ������
                    ; ���
and di, 1fh         ;��ᨬ ��譨� ����
invoke  wsprintf, ADDR buf, ADDR ifmt, edi
invoke  WriteConsole, stdout, ADDR buf, 3,\
        ADDR cWritten, NULL
mov di, Date         ;����⠭�������� ����
shr di, 7            ;����� - � ᥬ�
                     ; ������ ���
and di, 0fh          ;�뤥�塞 �����
dec di               ;�㬥��� � ���
shl di, 2            ;㬭���� �� 4
mov esi, offset month;��. ���� ��������
add esi, edi         ;���� ��������
invoke  WriteConsole, stdout, esi, 4, \
        ADDR cWritten, NULL
mov  di, Date        ;����⠭�������� ����
and  di, 7fh         ;�뤥�塞 ���
invoke  wsprintf, ADDR buf, ADDR ifmt, edi
invoke  WriteConsole, stdout, ADDR buf, 3,\
        ADDR cWritten, NULL
ret
DateDisp endp
end start
