
;             Prog03.asm - �ணࠬ�� � ����� � 03

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog03.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog03.asm
;TLINK.EXE prog03.obj /t/x


CSEG segment
org 100h

_beg:
	mov ax,0B800h
	mov es,ax
	mov di,0

	mov ah,31
	mov al,1
	mov es:[di],ax

	mov ah,10h
	int 16h

	int 20h

CSEG ends
end _beg
