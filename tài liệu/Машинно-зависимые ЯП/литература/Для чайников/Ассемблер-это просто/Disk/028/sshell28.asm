
;              Sshell28.ASM - �ணࠬ�� � ����� � 28

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE sshell28.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE sshell28.asm
;TLINK.EXE sshell28.obj /t/x


.386
.287
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

        call Main_proc ; === �������� ��楤�� ===

; ��室�� � DOS
        int 20h

Current_dir equ $              ;������� �࠭���� ⥪�饣� ��⠫���

Temp_files equ Current_dir+300 ;�६����� �࠭���� ���������� 䠩��

Finish equ Temp_files+320      ;�� 䨭��!

CSEG ends
end Start