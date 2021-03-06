
;            RESID19.ASM - �ணࠬ�� � ����� � 19

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE resid19.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE resid19.asm
;TLINK.EXE resid19.obj /t/x


;   === ��砫� �ணࠬ��: ===
.286
CSEG segment
assume cs:CSEG, ds:CSEG, ss:CSEG, es:CSEG
org 100h

Begin:
       jmp Init		;�� ���� ���樠����樨 

; === ��ࠡ��稪 21h-��� ���뢠��� ===
Int_21h_proc proc
     cmp ax,9889h
     jne Next_step

     xchg ah,al
     iret

Next_step:
     pusha		;���࠭�� ॣ�����...
     push ds
     push es

     mov bx,ds		;BX=DS

     push cs		;����ந� ᥣ����� ॣ�����
     push cs
     pop es
     pop ds

     cmp ax,4B00h	;�� ����� 䠩�� �� �믮������?
     je Start_f

     cmp ah,39h		;�� ᮧ����� ��⠫���?
     je Create_dir

     cmp ah,3Ah		;�� 㤠����� ��⠫���?
     je Delete_dir

     cmp ah,3Bh		;�� ᬥ�� ��⠫���?
     je Change_dir

     cmp ah,3Ch		;�� ᮧ����� 䠩��?
     je Create_file

     cmp ax,3D02h	;�� ����⨥ 䠩�� ��� �⥭��/�����?
     je Open_fl

     cmp ah,41h		;�� 㤠����� 䠩��?
     je Delete_file

     jmp short Go_21h	;�᫨ ��㣮�, � ��।���� �ࠢ����� 21h-���... 

Start_f:
     mov si,offset Start_filemess ;��ப� ��� ����� � ��� log-䠩�.
     call Move_string	;��⮢�� ��ப� � �����뢠�� �� � 䠩�...
     jmp short Go_21h	;��।���� �ࠢ����� 21h-��� ���뢠���...

Create_dir:
     mov si,offset Create_dirmess
     call Move_string
     jmp short Go_21h

Delete_dir:
     mov si,offset Delete_dirmess
     call Move_string
     jmp short Go_21h

Change_dir:
     mov si,offset Change_dirmess
     call Move_string
     jmp short Go_21h

Create_file:
     mov si,offset Create_filemess
     call Move_string
     jmp short Go_21h

Open_fl:
     mov si,offset Open_filemess
     call Move_string
     jmp short Go_21h

Delete_file:
     mov si,offset Delete_filemess
     call Move_string


Go_21h:
     pop es		;����⠭���� ॣ�����...
     pop ds
     popa

  jmp dword ptr cs:[0FCh] ;��।��� �ࠢ����� �०���� 21h-���
Int_21h_proc endp

;=== ��७�ᨬ ��ப� � ��襬 ���ଠ�� � 䠩� ===
Move_string proc
    mov di,2	;DS:SI 㪠�뢠�� �� ��ப�
		;ES:DI - �� ���� � �����, ��� �㤥� �ନ஢����� ��ப�...
    lodsw	;����稬 ����� ��ப� (���� ���� ��ப�)
    mov cx,ax	;����� ��ப� � CX
    rep movsb	;��६��⨫� ��ப� �� ����� ES:DI (����騩 ᥣ����:0002h)

    push ds
    mov ds,bx	;DS 㪠�뢠�� �� ᥣ����, ��� ��室���� ��� 䠩��
    mov si,dx	;SI - �� ᬥ饭��

Next_char:
    lodsb	;����砥� ��।��� ᨬ���
    or al,al	;�� ����� ��ப� � ������ 䠩��? �஢�ઠ �� 0...
    jz Zero_found
    stosb	;�᫨ �� �� ����� - ����ᨬ ��� � ���� �ନ�������� ��ப�
    jmp short Next_char ;������騩 ᨬ���...

Zero_found:
    pop ds	;��� 䠩�� ��७�᫨! ����⠭���� DS.

    mov ax,0A0Dh ;������� ������ ���⪨/��ॢ�� ��ப�.
    stosw

    dec di
    dec di
    mov word ptr cs:[0],di ;����ᥬ �� 0-��� ᬥ饭�� ����� ��⮢�� ��ப�

    call Save_file	;����襬 ��⮢�� ��ப� � ��� log-䠩�...

    ret
Move_string endp


;=== ��襬 � 䠩� ===
Save_file proc
     call Check_file	;�஢�ਬ, ������� �� ��� log-䠩� ��� ���...

     mov al,02h		;���뢠�� 䠩� ��� �⥭��/�����
     call Open_file

     mov ax,4202h	;��⠭�������� 㪠��⥫� �� ����� 䠩��
     xor cx,cx
     xor dx,dx
     int 3

     mov ah,40h		;�㭪�� ����� � 䠩�
     mov cx,cs:[0]	;������⢮ �����뢠���� ����
     mov dx,2		;��㤠 �㤥� ����� (DS:DX)
     int 3

     call Close_file	;����뢠�� 䠩�...

     ret
Save_file endp

;=== �஢��塞: ������� �� �㦭� 䠩� ===
Check_file proc
     xor al,al		;�஡㥬 ������ ��� log-䠩�
     call Open_file
     jnc File_exists	;�᫨ 䠩� �������, � �� ���� File_exists

; === ��ਡ��� 䠩�� ===
;00001 - ⮫쪮 �⥭��
;00010 - ���⠭��
;00100 - ��⥬��
;01000 - ��⪠ ⮬�
;010000 - �����⠫��
;100000 - ��娢��
     mov ah,3Ch		;�᫨ 䠩� �� �������, � ᮧ����� ���.
     mov cx,100010b	;��ਡ��: ��娢��, ���⠭��
     mov dx,offset File_name ;DS:DX 㪠�뢠�� �� ��� 䠩��
     int 3
     jc Error_create	;�訡��?.. 
     mov Handle,ax	;�᫨ �ᯥ譮 ᮧ����, � �������� ����� 䠩��

File_exists:
     call Close_file	;����뢠�� 䠩�...

Error_create:
     ret

File_name db 'C:\report.txt',0	;��� log-䠩�
Check_file endp

;=== ����⨥ 䠩�� ===
Open_file proc
     mov dx,offset File_name
     mov ah,3Dh
     int 3
     jc Error_open

     mov bx,ax
     mov Handle,ax

Error_open:
     ret
Handle dw 0FFFFh
Open_file endp

;=== �����⨥ 䠩�� ===
Close_file proc
     pusha
     pushf
     cmp Handle,0FFFFh	;��祣� ����뢠��?.. 
     je No_close

     mov ah,3Eh
     mov bx,Handle
     int 3
     mov Handle,0FFFFh	;����뢠�� � �⬥砥�, �� ��� ������� 䠩���...

No_close:
     popa
     popf
     ret
Close_file endp

;--- ����饭�� १����� ---
Start_filemess dw Start_filemessl
               db '����� 䠩��      ---> '
Start_filemessl equ $-Start_filemess-2

Create_dirmess dw Create_dirmessl
               db '�������� ��⠫��� ---> '
Create_dirmessl equ $-Create_dirmess-2

Delete_dirmess dw Delete_dirmessl
               db '�������� ��⠫��� ---> '
Delete_dirmessl equ $-Delete_dirmess-2

Change_dirmess dw Change_dirmessl
               db '����� ��⠫��� �� ---> '
Change_dirmessl equ $-Change_dirmess-2

Create_filemess dw Create_filemessl
                db '�������� 䠩��    ---> '
Create_filemessl equ $-Create_filemess-2

Open_filemess dw Open_filemessl
              db '����⨥ 䠩�� ��� �⥭��/����� ---> '
Open_filemessl equ $-Open_filemess-2

Delete_filemess dw Delete_filemessl
                db '�������� 䠩��    ---> '
Delete_filemessl equ $-Delete_filemess-2




;   === ���樠������ (�����⮢�� � ����ன�� १�����) ===
Init:
       mov ax,9889h	;�஢�ਬ, � ����� �� �� 㦥 ��� �� ���
       int 21h
       cmp ax,8998h
       jne Set_resident

       mov ah,9		;�᫨ � �����, � �뢥��� ᮮ⢥�����饥 ᮮ�饭��
       mov dx,offset In_memory
       int 21h

       ret		;...� ��୥��� � DOS

Set_resident:		;�᫨ ��� � ����� ���, � ��⠭���� १�����
; 21h-��...
       mov ax,3521h
       int 21h		;����稬 � ��࠭�� ���� (�����) 21h ���뢠���
       mov word ptr cs:[0FCh],bx
       mov word ptr cs:[0FEh],es

       mov ax,es	;��⠭���� ���� ����� 21h-���뢠��� �� 3...
       push 0		;(���㡨� �⫠�稪)
       pop es
       mov es:[3*4],bx
       mov es:[3*4+2],ax

       mov ax,2521h
       mov dx,offset Int_21h_proc
       int 3		;"����ᨬ" ���� ��楤��� �� 21h ���뢠���

       call Check_file	;� ���� �� ��� log-䠩�?

       mov ah,9
       mov dx,offset Mess_hello
       int 21h

       mov dx,offset Init
       int 27h		;��⠢�� �ணࠬ�� १����⭮� � �����.

In_memory db '�ணࠬ�� 㦥 ����㦥�� � ������!!!',0Ah,0Dh,0Ah

Mess_hello db '�������� � ����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 19.',0Ah,0Dh,0Ah
           db '����: ����譨��� ���� ����ᠭ�஢�� (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, �����, ��᪢�, 2000 ���.',0Ah,0Dh,'$'

CSEG ends
end Begin