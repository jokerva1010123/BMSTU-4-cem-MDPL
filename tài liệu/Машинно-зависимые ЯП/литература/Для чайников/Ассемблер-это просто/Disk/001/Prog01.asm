
;          ��᫥ �窨 � ����⭮� � ��ᥬ���� ���� �������਩,
;               ����� ���������� �ணࠬ���-��ᥬ���஬.


;             Prog01.asm - �ணࠬ�� � ����� � 01

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog01.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog01.asm
;TLINK.EXE prog01.obj /t/x


CSEG segment
org 100h

Begin:

	mov ah,9
	mov dx,offset Message
	int 21h

	int 20h

Message db 'Hello, world!$'

CSEG ends
end Begin
