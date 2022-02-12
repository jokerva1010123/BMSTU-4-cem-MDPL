
;             Prog09.asm - �ணࠬ�� � ����� � 09

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog09.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog09.asm
;TLINK.EXE prog09.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
	mov dx,offset File_name
	call Open_file          ;���뢠�� 䠩�
	jc Error_file           ;�訡��? 
; ------------- ���뫨 䠩� ----------------

	mov bx,ax
	mov ah,3Fh              ;�㭪�� �⥭�� 䠩��
	mov cx,offset Finish-100h
	mov dx,offset Begin     ;! ����, �㤠 ���� ������ �����
	int 21h
; ------------- ���⠫� 䠩� ----------------

	call Close_file

; ------------ �뢮��� ᮮ�饭�� --------------
	mov ah,9
	mov dx,offset Mess_ok
	int 21h
	ret

; ---------- �� ᬮ��� ���� / ������ 䠩� -----------------
Error_file:
	mov ah,2
	mov dl,7
	int 21h
	ret



; === ��楤��� (����ணࠬ��) ===

; --- ����⨥ 䠩�� ---
Open_file proc
	cmp Handle,0FFFFh
	jne Quit_open
	mov ax,3D00h
	int 21h
	mov Handle,ax
	ret
Quit_open:
	stc
	ret
Handle dw 0FFFFh
Open_file endp

; --- �����⨥ 䠩�� ---
Close_file proc
	mov ah,3Eh
	mov bx,Handle
	int 21h
	ret
Close_file endp



; === ����� ===

File_name db 'prog09.com',0
Mess_ok db '�� ��ଠ�쭮!', 0Ah, 0Dh, '$'

Finish equ $       ;��⪠ ���� �ணࠬ��

CSEG ends
end Begin
