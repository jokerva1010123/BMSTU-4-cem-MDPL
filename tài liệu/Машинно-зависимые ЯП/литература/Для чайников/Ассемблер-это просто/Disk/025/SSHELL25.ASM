
;              Sshell25.ASM - �ணࠬ�� � ����� � 25

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE sshell25.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE sshell25.asm
;TLINK.EXE sshell25.obj /t/x


.386 ;�㤥� �ᯮ�짮���� ॣ����� � ������� 80386 ������,
.287 ;� ⠪�� ������� 80287 ᮯ�����
CSEG segment use16
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
        jmp Begin

; ======= ��楤��� =========
; ��������
include main.asm

; ����� � ��ᯫ���
include display.asm

; ����� � 䠩����
include files.asm

; ����� � ��������ன
include keyboard.asm

; ����饭��
include messages.asm

; ��६����
include data.asm

; ��砫� �ணࠬ��
Begin:
        call Check_video ;�஢�ਬ �����०�� � ⥪���� ��࠭���

        mov ah,9
        mov dx,offset Mess_about
        int 21h ;�뢮��� ᮮ�饭�� � �ਢ���⢨��

        call Main_proc ;�������� ��楤��

; ��室�� � DOS
        int 20h

Finish equ $    ;�� 䨭��!

CSEG ends
end Start