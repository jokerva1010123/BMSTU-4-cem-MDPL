; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 4.6
.386
.model  flat, stdcall
option  casemap:none
include    \myasm\include\kernel32.inc
includelib \myasm\lib\kernel32.lib
SSIZE    equ 1000
.data?
smpl     dd SSIZE dup(?)
.code
start:
mov ebx, 3  ;��ࢮ� �஢��塞�� �᫮ = 3
mov edi, 0  ;�㫥��� ������� ���ᨢ�
mov ebp, 0  ;���稪 ������ �ᥫ = 0
nxtdig:
mov edx, 0  ;��⮢�� �᫮ edx:eax
mov eax, ebx;� �஢�થ
mov ecx, ebx;�᫮ �஢�ப �����
sub ecx, 2  ;�஢��塞��� �᫠ �� 2
mov esi, 2  ;���� ����⥫� = 2
nxtpr:
div esi     ;����� �᫮ edx:eax �� esi
cmp edx, 0  ;���⮪ = 0 ?
jz  skip    ;�� - ���� � ᫥�. �஢�થ
mov edx, 0  ;��� -
mov eax, ebx;����⠭�������� edx:eax
inc esi     ;� ����� �� ᫥���饥 �᫮
loop nxtpr  ;���� �� �� ������ - �த�����
mov smpl[edi], ebx ; ��� - �᫮ ���⮥
inc ebp     ;㢥�. ���稪 ����. �ᥫ
cmp ebp, SSIZE;�� ����� �᫠ �������?
jz  done    ;�� - �室��
add edi,4   ;��� - ᫥�. ��-� ���ᨢ�
skip:
inc  ebx    ;�஢��塞
jmp nxtdig  ;᫥�. �᫮
done:
invoke  ExitProcess, 0
end start
