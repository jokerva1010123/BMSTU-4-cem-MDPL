
;              Prog07.asm - �ணࠬ�� � ����� � 07

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE prog07.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE prog07.asm
;TLINK.EXE prog07.obj /t/x


CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
	call Wait_key  ;��뢠�� ��楤��� �������� ������ ������

	cmp al,27      ;���짮��⥫� ����� ESC?
	je Quit_prog   ;�᫨ ⠪, � �� ���� Quit_prog 

	cmp al,0       ;�� ���७�� ��� ������?
	je Begin       ;�᫨ ⠪, � ���� ������ ᫥���饩 ������ 

	call Out_char  ;���� �뢮��� ᨬ��� �� �࠭
	jmp Begin      ;� �������� ������ ᫥���饩 ������ 


;���짮��⥫� ����� ESC
Quit_prog:
	mov al,32      ;������㥬 ����⨥ �� "�஡��"
	call Out_char

	int 20h        ;��室�� �� �ணࠬ��



; === ����ணࠬ�� ===

; --- Wait_key ---
Wait_key proc
	mov ah,10h ;�㭪�� 10h ���뢠��� 16h - �������� ������ ������
	int 16h
	ret
Wait_key endp


; --- Out_char ---
Out_char proc
;�뢮��� ᨬ��� �� �࠭ ��⥬ ��אַ�� �⮡ࠦ���� � ���������

	push cx        ;���࠭�� � �⥪� �����塞� ������ ��楤�ன ॣ�����
	push ax
	push es

	push ax
	mov ax,0B800h  ;��⮢�� ॣ����� � �뢮�� ᨬ���� �� �࠭
	mov es,ax
	mov di,0
	mov cx,2000    ;�㤥� �뢮���� 2000 ࠧ (80 * 25 = 2000 - ���� �࠭)
	pop ax
	mov ah,31      ;��ਡ��� �뢮������ ᨬ����

Next_sym:
	mov es:[di],ax
	inc di         ;�����稢��� 㪠��⥫� �뢮�� ᨬ���� �� 2
	inc di
	loop Next_sym  ;������騩 ᨬ��� 

	pop es         ;����⠭���� ��࠭���� � �⥪� ॣ�����
	pop ax
	pop cx
	ret
Out_char endp


CSEG ends
end Begin
