
;              VIRUS13.ASM - �ணࠬ�� � ����� � 13

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE virus13.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE virus13.asm
;TLINK.EXE virus13.obj /t/x


.286	;�㤥� �ᯮ�짮���� ������樨 80286 ������ (��諮 �६�!)

cseg SEGMENT
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       jmp Init		;��室�� �� ��楤��� ���樠����樨 


; --- ��騥 ����� ---
Off_move dw offset Lab_jmp	;���饭�� �
Seg_move dw 0BF00h		;ᥣ���� ����, �㤠 �㤥� ��룠��
				;0BF00h - ���� (ᥣ����) 7 ��࠭��� ��ᯫ��
				;����襥 ᫮�� � ��砫�, � ���襥 - � ����

Off_return dw offset Lab_return ;���饭�� �
Seg_return dw ?                 ;ᥣ���� ���� ��� ������


;       === ��楤��� ࠡ��� � 䠩���� ===

; --- ����⨥ 䠩�� ��� ����� ---
; �室:  DX - ���� 䠩�� ASCIIZ
; ��室: Handle, BX - ����� 䠩��
Open_file proc
     mov ax,3D02h	;���뢠�� 䠩� ��� �⥭��/�����
     int 21h
     mov Handle,ax	;���࠭塞 ����� 䠩��
     mov bx,ax
     ret

Handle dw 0FFFFh ;��६����� ��� �࠭���� ����� 䠩�� (�� 㬮�砭�� 0FFFFh)
Open_file endp

; --- �����⨥ 䠩�� ---
; �室:  Handle - ����� ����⮣� 䠩��
; ��室: ��祣�
Close_file proc
     cmp Handle,0FFFFh	;��� ������� 䠩���?
     je No_close	;����� ��室�� (����뢠�� ��祣�!) 

     mov bx,Handle	;����뢠�� 䠩�...
     mov ah,3Eh
     int 21h

No_close:
   ret
Close_file endp

; --- ���� ��ࢮ�� 䠩�� ---
Find_first proc
      mov ah,4Eh	;�饬 ���� 䠩� �� ��᪥ (Mask_file)
      xor cx,cx		;��ਡ��� ����� (CX=0)
      mov dx,offset Mask_file ;���� ��᪨ � DS:DX
      int 21h		;������ (�᫨ ��諨 䠩� *.com � ⥪�饬 ��⠫���)
			;��� 䠩�� ��室���� �� ����� 0BF00:001Eh,
			;�.�. �� ᬥ饭�� 30...
   ret
Mask_file db '*.com',0	;��᪠ ��� ���᪠ (⮫쪮 COM-䠩��)
Find_first endp

; --- ���� ᫥����� 䠩��� ---
Find_next proc
      xor dx,dx		;DS:DX 㪠�뢠�� �� DTA
      xor cx,cx
      mov ah,4Fh
      int 21h
   ret
Find_next endp

; --- ��ࠦ���� 䠩�� ---
Infect_file proc
      clc		;���� ���� ��ᨬ 䫠� ��७��.
			;����, ��ࠧ��� 䠩� �ᯥ譮!
			;��⮬ ������� ��, �� �㦭�...
   ret
Infect_file endp


; ��楤�� ���樠����樨 �����
Init:
       mov es,Seg_move	;ES - ᥣ����, �㤠 �㤥� ��६���� ��� �����,
       mov di,100h	;DI - ᬥ饭��
       mov cx,offset Finish-100h	;CX - ������⢮ ��६�頥��� ����
					;CX = ����� ��襣� ����� - 100h (PSP)
					;�.�. CX = ����� ��襣� ����� � �����
       mov si,100h			;DS:SI ��㤠 ��६���� �㤥�
       rep movsb			;��ॡ��뢠�� ���� �ணࠬ�� � �������
					;7 �������࠭���

;	___________________________________________________

;	!!! ������ ����������� ᫥��� �� CS � �⫠�稪� !!!
;	___________________________________________________

       jmp dword ptr cs:[Off_move] ;��룠�� �㤠 ��६��⨫� (䠪��᪨ ��
				   ;᫥������ ��ப�, ⮫쪮 㦥 � ᥣ����
				   ;0BF00h!)

; �� ������� �⫠�稪? ���㬠��, �� �ந��諮...

; ������ �� 㦥 � ������ ��࠭�
Lab_jmp:
	;��� �-� �� � ��룭㫨 � �।��饩 ��ப�! ����� CS ⥯���
	;ࠢ�� 0BF00h. �����⥫쭮 ��᫥��� � �⫠�稪� �� �⨬...

       nop	;�� ��� ��� �⫠�稪� (�� ��直� ��砩!)
       nop

       push cs	;����ந� ᥣ����� ॣ�����
       pop ds

       mov Seg_return,ss	;�������� ᥣ���� ��� ������.
				;SS-� ��⠥��� �०���!

       mov ah,1Ah	;��⠭���� DTA ��� ���᪠ 䠩���
       xor dx,dx	;�� ��⠭���������� �� �� ����, ����� ᮤ�ন���
       int 21h		;� ॣ����� DS:DX. � �⫠�稪� ��ᬮ���,
			;�� ��室���� � ����� �� ������ 㪠�뢠�� �����
			;ॣ�����, �.�. DS:DX...
			;��᫥ �믮������ ᫥���饩 ��楤��� ⠬ �㤥�
			;��室����� ��-� ����� ����᭮�...

       call Find_first	;�饬 ���� 䠩�
       jc Nomore_files	;��� COM-䠩��� - �� ��室 

Inf_file:
       call Infect_file	;��諨 - �஡㥬 ��ࠧ���
       jnc Nomore_files	;������� ��ࠧ��� - ��室�� 

       call Find_next	;�� 㤠���� ��ࠧ��� - �饬 ᫥���騩
       jnc Inf_file	;��諨 �� ���� COM-䠩�; �஡㥬 ��ࠧ���... 

Nomore_files:
       jmp dword ptr cs:[Off_return]	;�����頥��� � ᥣ���� �ணࠬ��...
		;����᭮, � �� �⫠�稪 ������ �� ������ �⮣� jmp'�?
		;��������, ᥣ����� ॣ����� �������?


;������ �� 㦥 � ᥣ���� ��ࠦ����� �ணࠬ��...
;���쪮 �� �ந��諮 ᠬ�� ������!
Lab_return:
       push cs		;����⠭���� ᥣ����� ॣ�����...
       push cs
       pop ds
       pop es

       mov ah,1Ah	;����⠭���� DTA
       mov dx,80h
       int 21h

       ret		;��室�� � DOS...

Finish equ $		;��⪠ ���� �ணࠬ��-�����

CSEG ends
end Begin