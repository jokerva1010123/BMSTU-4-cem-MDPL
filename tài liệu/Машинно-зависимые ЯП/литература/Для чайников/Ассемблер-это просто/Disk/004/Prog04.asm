
;            Prog04.asm - �ணࠬ�� � ����� � 04

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog04.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog04.asm
;TLINK.EXE prog04.obj /t/x


CSEG segment
org 100h

Begin:
	mov ax,0B800h
	mov es,ax
	mov di,0
	mov al,1
	mov ah,31
	mov cx,2000

Next_face:
	mov es:[di],ax
	add di,2
	loop Next_face

	mov ah,10h
	int 16h
	int 20h

CSEG ends
end Begin
