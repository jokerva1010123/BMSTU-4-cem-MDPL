
;            RESID15.ASM - �ணࠬ�� � ����� � 15

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE resid15.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE resid15.asm
;TLINK.EXE resid15.obj /t/x


;   === ��砫� �ணࠬ��: ===
.286
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
       jmp Init		;�� ���� ���樠����樨 


; === ��楤�� ��ࠡ�⪨ 05h ���뢠��� (����� ��࠭�) ===
Int_05h_proc proc
       cli		;����頥� ���뢠���
       pusha		;���࠭塞 � �⥪� �� ॣ�����,
       pushf		;������ ॣ���� 䫠���
       push es		;� ᥣ����� ॣ�����
       push ds

       push 0B800h    ;DS ������ ���� ࠢ�� ᥣ����� ��������� 0-�� ��࠭���
       pop ds

       push 0B900h	;ES - 1-�� ��࠭���
       pop es

       xor di,di	;���㫨�㥬 DI � SI
       xor si,si

       mov cx,25	;�� ��࠭� 25 ��ப...
Next_line:
       push cx
       mov cx,80	;...80 ᨬ����� � ������ ��ப�
Next_symbol:
       lodsw		;��६ ���� ᨬ��� � ��ਡ�� � AX (lodsW)
       stosb		;����ᨬ ᨬ��� ��� ��ਡ�� �� AL � 1-��
			;�������࠭��� (stosB)
       loop Next_symbol ;������騩 ᨬ���... 

       mov ax,0A0Dh	;������塞 � ���� ������ ��ப� ������ ���⪨ /
       stosw		;��ॢ�� ��ப� (��� 㤮��⢠ ��ᬮ�� � NC / VC / DN)
       pop cx
       loop Next_line	;�������� ��ப�... 

       push cs		;DS ������ ���� ࠢ�� ᥣ�����, � ���஬ �� ᥩ��
       pop ds		;��室����
       mov ah,3Ch	;�㭪�� ᮧ����� 䠩��
       xor cx,cx	;��ਡ��� �����
       mov dx,offset Screen_file	;DS:DX 㪠�뢠�� �� ���� � ��� 䠩��
       int 21h		;������� 䠩� � ⥪�饬 ��⠫���
       push ax		;���࠭�� ����� 䠩��

       push 0B900h	;DS ������ 㪠�뢠�� �� 1-�� �������࠭���
       pop ds
       mov bx,ax	;� BX - ����� 䠩��
       mov ah,40h	;�㭪�� ����� � 䠩�
       xor dx,dx	;DS:DX ������ 㪠�뢠�� �� ����, ��� ��室���� �����
       mov cx,2050	;���-�� �����뢠���� ���� (80*25 + 2*25 = 2050)
       int 21h		;�����뢠�� � ᮧ����� 䠩� ᮤ�ন��� ��࠭�...

       pop bx		;����⠭���� ����� 䠩��
       mov ah,3Eh	;�㭪�� ������� 䠩��
       int 21h

       pop ds		;����⠭���� ��࠭���� ॣ�����
       pop es
       popf
       popa

       sti		;����訬 ���뢠���
       iret		;��室 (������ � ��ࢠ���� ����)...

Int_05h_vect dd ?		;��६����� ��� �࠭���� ���� 05h ���뢠���
Screen_file db 'Screen.txt',0   ;��� 䠩��, �㤠 ����ᥬ ᮤ�ন��� ��࠭�
Int_05h_proc endp


; === ��楤�� ��ࠡ�⪨ 09h ���뢠��� (���������) ===
Int_09h_proc proc
       pusha
       in al,60h	;����稬 ᪠�-��� ������
       cmp al,58h	;�� F12?
       jne No_F12	;��� - ��।��� �ࠢ����� �ਣ����쭮�� ��ࠡ��稪� 

       xor cs:Num_status,1 ;�᫨ ������ F12, � ���塞 ���⠬� ��� 1 (on/off)

No_F12:
       popa
       jmp dword ptr cs:[Int_09h_vect]	;��।��� �ࠢ����� �ਣ����쭮��
					;��ࠡ��稪� 09h...

Int_09h_vect dd ?	;��६����� ��� �࠭���� ���� 09h ���뢠���
Int_09h_proc endp


; === ��楤�� ��ࠡ�⪨ 1Ch ���뢠��� ===
;�� ���뢠��� ��뢠���� ᠬ� �� ᥡ� ���� ����� 18 ࠧ � ᥪ㭤�...
;�.�. ��� ��楤�� (Int_1Ch_proc) �㤥� ��뢠���� ��⮬���᪨
;�ਬ�୮ 18 ࠧ � ᥪ㭤�.
;����� ��� �� ���뢠���, 1Ch... �������� ���!

Int_1Ch_proc proc
       cli		;����⨬ �맮� ��� ���뢠��� (�⮡ ����॥ �뫮)
       cmp cs:Num_status,0 ;Num_status �� ࠢ�� 0?
       jnz Go_1Ch	;��, �� ࠢ�� - ⮣�� �� ���塞 ᨬ����... 

       pusha		;���࠭�� �� ॣ�����
       push es		;���࠭�� ᥣ����� ॣ�����
       push ds

       push 0B800h	;ES ������ 㪠�뢠�� �� ᥣ���� ���������
       pop es

       push es		;DS ⠪�� ������ 㪠�뢠�� �� ᥣ���� ���������
       pop ds

       xor si,si	;� ��ࢮ�� ᨬ����
       mov cx,2000	;�ᥣ� 2000 ᨬ����� �� ��࠭� (80*25)

Next_sym:
       mov di,si	;SI ������ "��� � ����" � DI
       lodsw		;����㦠�� � AX ᨬ��� � ��ਡ�� ��।���� ᨬ����
			;�� ������� ࠢ��ᨫ쭠 mov ax,ds:[si]

       cmp al,'A'	;�� ������ �㪢� "A"?
       jne Test_little	;�᫨ ���, � �஢�ਬ �������� "a" 

       mov ax,0E4Fh	;�᫨ �� "A", � �뢮��� "O" �
			;��ਡ�⮬ ᢥ⫮-����� �� �୮� 䮭�...

Store:
       stosw		;�� ������� ࠢ��ᨫ쭠 mov es:[di],ax

Next_byte:
       loop Next_sym	;����ਬ ᫥���騩 ᨬ���  (�ᥣ� 2000 ࠧ)

       pop ds		;�᫨ CX=0 (�.�. 横� �����襭), � ��।���
			;�ࠢ����� �ਣ����쭮�� ���뢠��� 1Ch,
       pop es		;�।���⥫쭮 ����⠭���� ॣ�����...
       popa
Go_1Ch:
       sti		;� �� ࠧ�訬 �� ���뢠���
       jmp dword ptr cs:[Int_1Ch_vect]

Test_little:
       cmp al,'a'	;�஢��塞 �� "a"...
       jne Next_byte	;�᫨ �� ࠢ�� "a", � �� ���� Next_byte 

       mov ax,0E6Fh	;���塞 "a" �� "o"
       jmp short Store	;� �㤠 ...
			;Short �����, �� ��⪠ ��室���� �� JMP �� �����,
			;祬 +/- 127 ����. � ��襬 ��砥 �� ⠪ � ����.
			;�� �⮬ �� �������� 1 ����...

Int_1Ch_vect dd ?	;��६����� ��� �࠭���� �ਣ����쭮�� ���� 1Ch.
Num_status db 0		;�� ��६����� ��� �����
; 0 - ������ ᨬ���� ��� 䠩���; 1 - �� ������
; �� 㬮�砭�� (����砫쭮) Num_status = 0 (�.�. ᨬ���� � 䠩�� ���塞)
Int_1Ch_proc endp


; === ��楤�� ��ࠡ�⪨ 21h ���뢠��� ===
Int_21h_proc proc
       cmp ax,9889h	;�஢�ઠ �� ������� ����㧪� � ������ (�. )
       jne Check_funcs

       xchg ah,al	;�᫨ �� ��� "���뢭��", � ���� �⢥�, ����� ���⠬�
       iret		;AH/AL � ���������� ��室�� �� 21h...

Check_funcs:
       cmp cs:Num_status,0 ;Num_status �� ࠢ�� 0?
       jnz Go_21h	;��, �� ࠢ��. ����� �� �����塞 䠩��... 

       cmp ah,4Eh	;�� �㭪�� 4Eh (���� ��ࢮ�� 䠩��)?
       je Do_not	;��. ���堫� �� ��ࠡ��� ...

       cmp ah,4Fh	;�� �㭪�� 4Fh (���� ᫥����� 䠩���)?
       je Do_not	;��. ���堫� �� ��ࠡ��� ...

Go_21h:
       jmp dword ptr cs:[Int_21h_vect]	;���� - ��।��� �ࠢ�����
					;�ਣ����쭮�� ��ࠡ��稪� 21h
					;����� � ���� ��楤��� �� �� ��୥���
					;(� �⫨稥 �� CALL'� )!


;��ࠡ��뢠�� �㭪樨 4Eh � 4Fh
Do_not:
       pushf		;���࠭�� 䫠�� � �⥪� (⠪ ����!)
       call dword ptr cs:[Int_21h_vect] ;�맮��� �ਣ������ ��ࠡ��稪 21h
			;21h ��ࠡ�⠫�. ���㫨�� � (� �⫨稥 �� JMP'� ).
			;������ 䫠��� � �⥪� ���!!! 

       pusha		;���࠭�� �ᯮ��㥬� ॣ����� � �⥪�...
       pushf
       push es

       mov ah,2Fh	;����稬 ⥪�騩 ���� DTA
       int 21h		;������ �� � ES:BX...

       mov ah,2Ch	;����稬 ⥪�饥 �६�.
       int 21h
			;������ CH ᮤ�ন� ��� (�� 0 �� 24)
			;CL - ������ (�� 0 �� 59)
			;DH - ᥪ㭤� (�� 0 �� 59)
			;DL - ��� ���� ᥪ㭤� (�� 0 �� 99)

       xor dh,dh	;DH ���㫨�㥬
;���塞 ��ਡ�� 䠩�� � DTA (ES:BX 㦥 㪠�뢠�� �� DTA )
       and byte ptr es:[bx+15h],11111000b

       mov es:[bx+1Ah],dx
	;���塞 ࠧ��� 䠩�� (����襥 ᫮��):
	;���� ����ᥬ ⥪�饥 ��������� ���� ����� ᥪ㭤
	;��-� ⨯� ��砩���� �᫠ �� 0 �� 99...

       mov word ptr es:[bx+1Ch],0
	;���㫨�㥬 ���襥 ᫮��.
	;�.�. � ��� ࠧ��� 䠩�� �� �㤥� �ॢ���� 99 ����.

       mov word ptr es:[bx+16h],1111011110000000b
	;�������㥬 �६�...

       mov word ptr es:[bx+18h],1111111111111b
	;�������㥬 ����...

       pop es	;����⠭���� ॣ�����
       popf
       popa

       retf 2	;�멤�� �� ���뢠���, �� ���᪨��� �� �⥪� 䫠�� (⠪ ����!)

Int_21h_vect dd ?	;��६����� ��� �࠭���� ���� 21h
Int_21h_proc endp


; ===============================================================
; ���樠������ (�����⮢�� � ����ன�� १�����)
Init:
       mov ax,9889h	;�஢�ਬ, � ����� �� �� 㦥 ��� �� ���
       int 21h		;9889h - ��� ���뢭��
       cmp ax,8998h	;�⮧����� ��ࠡ��稪 (AH/AL ������ ���������� ���⠬�)?
       jne Set_resident

       mov ah,9		;�᫨ � �����, � �뢥��� ᮮ⢥�����饥 ᮮ�饭��
       mov dx,offset In_memory
       int 21h

       ret		;...� ��୥��� � DOS

Set_resident: ;�᫨ ��� � ����� ���, � ��⠭���� १�����
; ���砫� 1�h...
       mov ax,351Ch
       int 21h		;����稬 � ��࠭�� ���� (�����) 1Ch ���뢠���
       mov word ptr Int_1Ch_vect,bx	;���砫� ����襥 ᫮�� (ᬥ饭��)...
       mov word ptr Int_1Ch_vect+2,es	;��⥬ ���襥 (ᥣ����)

       mov ax,251Ch
       mov dx,offset Int_1Ch_proc
       int 21h		;"����ᨬ" ���� ��楤��� �� 1Ch ���뢠���

; ������ 21h-��...
       mov ax,3521h
       int 21h		;����稬 � ��࠭�� ���� (�����) 21h ���뢠���
       mov word ptr Int_21h_vect,bx	;���砫� ����襥 ᫮�� (ᬥ饭��)...
       mov word ptr Int_21h_vect+2,es	;��⥬ ���襥 (ᥣ����)

       mov ax,2521h
       mov dx,offset Int_21h_proc
       int 21h		;"����ᨬ" ���� ��楤��� �� 21h ���뢠���

; ������ 09h...
       mov ax,3509h
       int 21h		;����稬 � ��࠭�� ���� (�����) 09h ���뢠���
       mov word ptr Int_09h_vect,bx	;���砫� ����襥 ᫮�� (ᬥ饭��)...
       mov word ptr Int_09h_vect+2,es	;��⥬ ���襥 (ᥣ����)

       mov ax,2509h
       mov dx,offset Int_09h_proc
       int 21h		;"����ᨬ" ���� ��楤��� �� 09h ���뢠���

; �, �������, 05h...
       mov ax,3505h
       int 21h		;����稬 � ��࠭�� ���� (�����) 05h ���뢠���
       mov word ptr Int_05h_vect,bx	;���砫� ����襥 ᫮�� (ᬥ饭��)...
       mov word ptr Int_05h_vect+2,es	;��⥬ ���襥 (ᥣ����)

       mov ax,2505h
       mov dx,offset Int_05h_proc
       int 21h		;"����ᨬ" ���� ��楤��� �� 05h ���뢠���

       mov ah,9
       mov dx,offset Mess_hello
       int 21h

       mov dx,offset Init
       int 27h		;��⠢�� �ணࠬ�� १����⭮� � �����.

In_memory db '�ணࠬ�� 㦥 ����㦥�� � ������!!!!',0Ah,0Dh,0Ah

Mess_hello db '�������� � ����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 15.',0Ah,0Dh,0Ah
           db '"����稥" ������: F12 - ���./�몫. ������ �㪢 � ������ DT�,',0Ah,0Dh
           db '                   Shift+PrintScreen - ������ ᮤ�ন���� ��࠭� � 䠩�.',0Ah,0Dh,0Ah
           db '����: ����譨��� ���� ����ᠭ�஢�� (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, �����, ��᪢�, 2000 ���.',0Ah,0Dh,'$'

cseg ends
end Begin
