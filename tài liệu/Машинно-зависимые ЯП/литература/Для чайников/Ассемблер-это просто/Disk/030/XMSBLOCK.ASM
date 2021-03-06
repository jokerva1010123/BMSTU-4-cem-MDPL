
;              XMSBLOCK.ASM - �ணࠬ�� � ����� � 30
;                ���� ���� ࠡ��� � XMS-�������
	
; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE xmsblock.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE xmsblock.asm
;TLINK.EXE xmsblock.obj /t/x


.386
CSEG segment use16
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
     mov ah,9
     mov dx,offset Mess_about
     int 21h

;��७�ᥬ �⥪ � PSP, �.�. �㤥� 㦨���� ᥣ����...
     mov sp,0FEh

;�஢�ਬ �� ����稥 Himem.sys � �����...
     mov ax,4300h
     int 2Fh

     cmp al,80h
     je Himem_loaded

;���� �뢮��� ᮮ�饭�� � ⮬, �� Himem � ����� �� �����㦥�...
     mov ah,9
     mov dx,offset Mess_nohimem
     int 21h
     ret


Himem_loaded:
;��⮢�� �᭮���� ������ (㦨���� � �⢮��� ��� ����� �� 64��)
     call Prepare_memory

;��⮢�� XMS-������ (�⢮��� ���� � XMS-�����)
     call Prepare_XMS

;��⠥� 䠩� � �������� ������
     call Open_file
     call Read_file
     call Close_file

;�뢮���:
;"���⠫� 䠩� � �᭮���� ������...
;�뢮��� �, �� ��室���� � �������� �����:"
     mov ah,9
     mov dx,offset Mess_first
     int 21h
     xor ah,ah
     int 16h

;�뢮��� �, �� ���⠫� � �������� ������ (� Buffer1)
     mov ax,Buffer1
     call Out_file

;�뢮���:
;"---------------------------"
     mov ah,9
     mov dx,offset Mess_second
     int 21h
     xor ah,ah
     int 16h

;��७�ᨬ ���⠭�� ����� �� �᭮���� ����� � ���७���, �
;� ��⥬ ���⭮ � �᭮����.
     call Move_toXMS

;�뢮��� �, �� ����뫠���� (�᭮���� --> XMS --> �᭮����, �� � ��㣮�
;ᥣ���� (Buffer2))
      mov ax,Buffer2
      call Out_file


;�뢮���:
;"��� ᮮ�饭�� ������ ᮢ������!!! ���� � ���� �� �����!!!"
     mov ah,9
     mov dx,offset Mess_third
     int 21h

;������ �� �ணࠬ��
     ret



;=== ��⮢�� XMS-������ ===
Prepare_XMS proc
     mov ax,4310h
     int 2Fh

     mov word ptr XMS_Addr,bx
     mov word ptr XMS_Addr+2,es  ;���࠭�� ��ࠡ��稪 XMS-�㭪権

     mov ah,88h   ;������� ���-�� �� XMS-����� (�ᥣ�)
     call dword ptr XMS_Addr
     mov dword ptr Number_dec,edx ;���࠭�� ���-�� �� XMS-�����

     mov ah,9
     mov dx,1024   ;�⢮��� 1024�� XMS-�����
     call dword ptr XMS_Addr
     or ax,ax
     jnz XMS_OK

;�ந��諠 �訡�� (����⭮, ����訢���� ���� ����� ᢮������ ����� ��
;������ �맮�� ��楤���. ����� BL = 0A0h). ����頥� ���짮��⥫� �� �訡��.
     mov ah,9
     mov dx,offset XMS_Error
     int 21h

     int 20h

XMS_OK:
     mov XMS_id,dx  ;���࠭�� ID �⢥������� �����

     ret
Prepare_XMS endp



; --- ���뢠�� 䠩� ---
Open_file proc
     mov ax,3D00h
     mov dx,offset File_name
     int 21h
     jnc Next_stp

     mov ah,9
     mov dx,offset Mess_errfile
     int 21h
     int 20h

Next_stp:
     mov Handle,ax
     mov bx,ax
     ret
Open_file endp

; --- ��⠥� 䠩� � �᭮���� ������ ---
Read_file proc
     mov ah,3Fh
     mov cx,0FFFFh
     xor dx,dx
     mov ds,Buffer1
     int 21h
     push cs
     pop ds
     mov Bytes,ax         ;���࠭�� ���-�� ���⠭��� ����
     ret
Read_file endp

; --- ����뢠�� 䠩� ---
Close_file proc
     mov bx,Handle
     mov ah,3Eh
     int 21h
     ret
Close_file endp

; --- �뢮��� ���⠭�� 䠩� ---
Out_file proc
     mov cx,Bytes   ;���-�� ���⠭��� ���� � CX
     mov ds,ax      ;�������, � ����� �⠫� ����, - � DS
     xor bx,bx
     mov ah,2

Next_byte:
     mov dl,[bx]
     int 21h
     inc bx
     loop Next_byte

     push cs
     pop ds

     ret
Out_file endp

; === ��⮢�� �᭮���� ������ ===
Prepare_memory proc
      mov bx,offset Finish
      shr bx,4
      inc bx
      mov ah,4Ah
      int 21h     ;������� ࠧ��� �⢥������ ����� �� ��⪨ Finish

; -- �⢮��� �᭮���� ������ --
      mov ah,48h
      mov bx,4096     ;4096 * 16 = 65536 ����
      int 21h
      jc Error_main
      mov Buffer1,ax  ;���࠭�� ᥣ���� ��ࢮ�� �⢥������� �����

      mov ah,48h
      mov bx,4096     ;4096 * 16 = 65536 ����
      int 21h
      jc Error_main
      mov Buffer2,ax  ;���࠭�� ᥣ���� ��ண� �⢥������� �����

  ret

Error_main:
;�訡��?
      mov ah,9
      mov dx,offset Error_alloc
      int 21h

      int 20h

Buffer1 dw ?
Buffer2 dw ?
Prepare_memory endp

; === ����뫠�� ���⠭�� ����� � XMS ������ � ���⭮ � �᭮���� ===
Move_toXMS proc

;<<< ���ࢠ �� �᭮���� � ����������� >>>

      mov ax,Bytes
      mov word ptr XMS_str,ax   ;���-�� ����뫠���� ����

      mov word ptr XMS_offsrc,0 ;���饭�� � �᭮���� �����
      mov ax,Buffer1
      mov word ptr XMS_offsrc+2,ax  ;������� � �᭮���� �����

      mov ax,XMS_id             ;�����䨪��� �ਥ����� (�.�. XMS-�����)
      mov XMS_rec,ax

      mov ah,0Bh
      mov si,offset XMS_str
      call dword ptr XMS_Addr


;<<< ������ �� ���७��� � �������� >>>

      mov ax,Bytes
      mov word ptr XMS_str,ax   ;���-�� ����뫠���� ����

      mov ax,XMS_id
      mov XMS_src,ax

      mov dword ptr XMS_offsrc,0

      mov XMS_rec,0

      mov ax,Buffer2
      mov word ptr XMS_offrec,0
      mov word ptr XMS_offrec+2,ax

      mov ah,0Bh
      mov si,offset XMS_str
      call dword ptr XMS_Addr

 ret

XMS_str    dd 0 ;���-�� ���� ��� ����뫪�
XMS_src    dw 0 ;���筨�
XMS_offsrc dd 0 ;���饭�� � �����-���筨�� ��� ���� � �᭮���� �����
XMS_rec    dw 0 ;�����䨪��� �ਥ�����
XMS_offrec dd 0 ;���饭�� � �����-�ਥ����� ��� ���� � �᭮���� �����

Move_toXMS endp

Mess_about db 0Ah, 0Dh, 'XMSBLOCK - �⠥� 䠩� � XMS-������.',0Ah, 0Dh
           db '����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 30',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ��⥫� �����.',0Ah, 0Dh, 0Ah
           db 9,9,'=== �����, ��᪢�, 2001 ��� ===',0Ah,0Dh,'$'

Mess_errfile db '�訡��: 㪠����� � ��६����� File_name 䠩� �� 㤠���� ������!',0Ah,0Ah,0Dh,'$'

Mess_nohimem db '�ࠩ��� Himem.sys �� ����㦥�! ���������� �ᯮ�짮���� XMS-������!!!'
Mess_cursor db 0Ah, 0Dh,'$'

XMS_error db '�訡�� ��।������ XMS-�����!',0Ah, 0Dh,'$'

Error_alloc db '�訡�� ��।������ �᭮���� �����!',0Ah, 0Dh,'$'
XMS_Addr dd ?
XMS_id dw ?

Mess_first db 0Ah,0Ah,0Dh,'���⠫� 䠩� � �᭮���� ������...',0Ah,0Dh,'�뢮��� �, �� ��室���� � �������� �����:',0Ah,0Ah,0Dh,'$'

Mess_second db 0Ah,0Ah,0Dh,'-------------------------------------------',0Ah,0Ah,0Dh,'������ �뢮��� �, �� ���᫠�� �� �������� � ����������� (XMS),',0Ah,0Dh,'� ��⥬ ���⭮ � �������� ������:',0Ah,0Ah,0Dh,'$'

Mess_third db 0Ah,0Ah,0Dh,'��� ᮮ�饭�� ������ ᮢ������!!! ���� � ���� �� �����!!!',0Ah,0Dh,0Dh,'$'

Handle dw ?
File_name db 'c:\autoexec.bat',0
Bytes dw 0
Number_dec dw 0

Finish equ $

CSEG ends
end Start