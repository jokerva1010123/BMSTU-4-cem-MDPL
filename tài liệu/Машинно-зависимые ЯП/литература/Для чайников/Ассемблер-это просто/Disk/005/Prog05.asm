
;             Prog05.asm - �ணࠬ�� � ����� � 05

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog05.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog05.asm
;TLINK.EXE prog05.obj /t/x


CSEG segment
assume CS:CSEG, DS:CSEG, ES:CSEG, SS:CSEG
org 100h

Start:
	mov ax,0B800h
	mov es,ax
	mov al,1
	mov ah,31
	mov cx,254

Next_screen:
	mov di,0
	call Out_chars
	inc al
	loop Next_screen

	mov ah,10h
	int 16h

	int 20h


; === ����ணࠬ�� ===

Out_chars proc
	mov dx,cx
	mov cx,2000

Next_face:
	mov es:[di],ax
	add di,2
	loop Next_face

	mov cx,dx
	ret
Out_chars endp

CSEG ends
end Start
