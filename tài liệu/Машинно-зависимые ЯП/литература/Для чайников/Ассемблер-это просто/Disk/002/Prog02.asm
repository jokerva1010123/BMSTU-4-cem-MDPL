
;             Prog02.asm - �ணࠬ�� � ����� � 02

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog02.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog02.asm
;TLINK.EXE prog02.obj /t/x


CSEG segment
org 100h

Start:

	mov ah,9
	mov dx,offset String
	int 21h

	mov ah,10h
	int 16h

	int 20h

String db '������ ���� �������...$'

CSEG ends
end Start
