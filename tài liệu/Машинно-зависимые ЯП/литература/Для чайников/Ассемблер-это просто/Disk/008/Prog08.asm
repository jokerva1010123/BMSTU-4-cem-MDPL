
;             Prog08.asm - �ணࠬ�� � ����� � 08

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog08.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog08.asm
;TLINK.EXE prog08.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

; === ��砫� �ணࠬ�� ===
Begin: 	mov ax,3D00h             ;���뢠�� 䠩� ��� �⥭��
	mov dx,offset File_name  ;��� ���뢠����� 䠩�� � DX
	int 21h
	jc Error_file            ;�訡�� ������ 䠩��? 

	mov Handle,ax            ;���࠭�� ����� ����⮣� 䠩��
	mov bx,ax
	mov ah,3Fh               ;�㭪�� �⥭�� 䠩��
	mov cx,0FDE8h            ;�㤥� ���� � ������ 0FDE8h = 65000 ����
	mov dx,offset Buffer     ;DX 㪠�뢠�� �� ���� ��� ���뢠���
	int 21h

	mov ah,3Eh               ;����뢠�� 䠩�
	mov bx,Handle
	int 21h

	mov dx,offset Mess_ok
Out_prog:
	mov ah,9
	int 21h

	int 20h

Error_file:
	mov dx,offset Mess_error
	jmp Out_prog

Handle dw 0
Mess_ok db '���� ����㦥� � ������! ������ � �⫠�稪�!$'
Mess_error db '�� 㤠���� ������ (����) 䠩� '
File_name db 'c:\msdos.sys',0,'!$'
Buffer equ $

; === ����� �ணࠬ�� ===

CSEG ends
end Begin
