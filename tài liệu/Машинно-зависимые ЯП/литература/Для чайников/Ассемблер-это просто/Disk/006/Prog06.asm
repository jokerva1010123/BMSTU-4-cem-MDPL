
;             Prog06.asm - �ணࠬ�� � ����� � 06

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog06.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog06.asm
;TLINK.EXE prog06.obj /t/x


CSEG segment
assume cs:CSEG, es:CSEG, ds:CSEG, ss:CSEG
org 100h

Begin:
	mov sp,offset Lab_1
	mov ax,9090h
	push ax
	int 20h

Lab_1:
	mov ah,9
	mov dx,offset Mess
	int 21h

	int 20h

Mess db '� ��-⠪� ��� �뢮�����!$'

CSEG ends
end Begin
