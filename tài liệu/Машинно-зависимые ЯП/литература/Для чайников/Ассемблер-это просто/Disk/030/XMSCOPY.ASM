
;              XMSCOPY.ASM - �ணࠬ�� � ����� � 30
;               �����㥬 䠩� � �ᯮ�짮������ XMS

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE xmscopy.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE xmscopy.asm
;TLINK.EXE xmscopy.obj /t/x


.386
CSEG segment use16
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
     mov ah,9
     mov dx,offset Mess_about
     int 21h

     mov sp,0FEh

;�஢�ਬ �� ����稥 Himem.sys � �����...
     mov ax,4300h
     int 2Fh
     cmp al,80h
     je Himem_loaded

     mov ah,9
     mov dx,offset Mess_nohimem
     int 21h
     ret


Himem_loaded:
     call Prepare_memory
     call Prepare_XMS

;�����㥬 䠩�...
     call Copy_file
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

     cmp edx,0FFFFh
     jbe Ok_XMS

     mov edx,0FFFFh

Ok_XMS:
     mov ah,9
     call dword ptr XMS_Addr
     mov XMS_id,dx  ;���࠭�� ID �⢥������� �����

     ret
Prepare_XMS endp

; === ��⮢�� �᭮���� ������ ===
Prepare_memory proc
      mov bx,offset Finish
      shr bx,4
      inc bx
      mov ah,4Ah
      int 21h    ;������� ࠧ��� �⢥������ ����� �� ��⪨ Finish

; -- �⢮��� ������
      mov ah,48h
      mov bx,4096 ; 4096 * 16 = 65536 ����
      int 21h
      jc Error_main
      mov Buffer,ax  ;���࠭�� ᥣ���� ��ࢮ�� �⢥������� �����

  ret

Error_main:
;�訡��?
      mov ah,9
      mov dx,offset Error_alloc
      int 21h
      int 20h

Prepare_memory endp

; === ����஢���� 䠩�� ===
Copy_file proc
     call Check_file

;�뢮��� ᮮ�饭�� "���� 䠩�..."
     mov ah,9
     mov dx,offset Info1
     int 21h

;--- ��⠥� 䠩� � ������
Next_portion:
     xor eax,eax
     mov ah,3Fh
     mov cx,0FFFFh
     xor dx,dx
     mov bx,Handle
     mov ds,Buffer
     int 21h
     push cs
     pop ds
     jc Error_copy

     mov Bytes,eax
     add Total_bytes,eax
     call Move_to_XMS

     cmp Bytes,0FFFFh
     je Next_portion

     mov ah,3Eh
     mov bx,Handle
     int 21h

;--- ��襬 䠩�
;�뢮��� ᮮ�饭�� "���� 䠩�... "
     mov ah,9
     mov dx,offset Info2
     int 21h

     mov dword ptr XMS_offsrc,0

     mov ah,3Ch
     xor cx,cx
     mov dx,offset File_new
     int 21h
     mov Handle,ax

int 3
Next_portion2:
     call Move_from_XMS

     mov ecx,Total_bytes
     cmp ecx,0FFFFh
     jbe Save_bytes

     sub Total_bytes,0FFFFh
     mov ecx,0FFFFh
     jmp short Step2

Save_bytes:
     mov Total_bytes,0

Step2:
     mov ah,40h
     xor dx,dx
     mov bx,Handle
     mov ds,Buffer
     int 21h
     push cs
     pop ds
     jc Error_copy

     cmp Total_bytes,0
     jnz Next_portion2

  ret

Error_copy:
     mov ah,9
     mov dx,offset Mess_errcopy
     int 21h
     int 20h

Copy_file endp

; === ����뫠�� ���⠭�� ����� � XMS ������ ===
Move_to_XMS proc
      mov eax,Bytes
      mov XMS_str,eax   ;���-�� ����뫠���� ����

      mov XMS_src,0

      mov word ptr XMS_offsrc,0 ;���饭�� � �᭮���� �����
      mov ax,Buffer
      mov word ptr XMS_offsrc+2,ax  ;������� � �᭮���� �����

      mov ax,XMS_id             ;�����䨪��� �ਥ����� (�.�. XMS-�����)
      mov XMS_rec,ax

      mov ah,0Bh
      mov si,offset XMS_str
      call dword ptr XMS_Addr

      mov eax,Total_bytes
      mov XMS_offrec,eax

 ret
;XMS_str    dd 0 ;���-�� ���� ��� ����뫪�
;XMS_src    dw 0 ;���筨�
;XMS_offsrc dd 0 ;���饭�� � �����-���筨�� ��� ���� � �᭮���� �����
;XMS_rec    dw 0 ;�����䨪��� �ਥ�����
;XMS_offrec dd 0 ;���饭�� � �����-�ਥ����� ��� ���� � �᭮���� �����
Move_to_XMS endp

; === ����뫠�� ���⠭�� ����� �� XMS ����� ===
Move_from_XMS proc
      mov dword ptr XMS_str,0FFFFh

      mov ax,XMS_id
      mov XMS_src,ax

      mov XMS_rec,0

      mov ax,Buffer
      mov word ptr XMS_offrec,0     ;���饭�� � �᭮���� �����
      mov word ptr XMS_offrec+2,ax  ;������� � �᭮���� �����

      mov ah,0Bh
      mov si,offset XMS_str
      call dword ptr XMS_Addr

      add XMS_offsrc,0FFFFh
      ret

;XMS_str    dd 0 ;���-�� ���� ��� ����뫪�
;XMS_src    dw 0 ;���筨�
;XMS_offsrc dd 0 ;���饭�� � �����-���筨�� ��� ���� � �᭮���� �����
;XMS_rec    dw 0 ;�����䨪��� �ਥ�����
;XMS_offrec dd 0 ;���饭�� � �����-�ਥ����� ��� ���� � �᭮���� �����
Move_from_XMS endp




; --- �஢�ਬ, ������� �� ��室�� 䠩� � ���� 䠩� ---
Check_file proc
     mov ax,3D00h
     mov dx,offset File_new
     int 21h
     jc Step1

     mov ah,9
     mov dx,offset Mess_exist
     int 21h

     xor ah,ah
     int 16h
     push ax

     mov ah,2
     mov dl,al
     int 21h

     mov ah,9
     mov dx,offset Mess_cursor
     int 21h

     pop ax
     cmp al,'y'
     je Step1
     cmp al,'Y'
     je Step1

     int 20h

Step1:
     mov ax,3D00h
     mov dx,offset File_name
     int 21h
     jnc Step2

     mov ah,9
     mov dx,offset Mess_noexist
     int 21h

     int 20h

Step2:
     mov Handle,ax
     mov bx,ax
  ret
Check_file endp


Mess_about db 0Ah, 0Dh, 'XMSCOPY - �����㥬 䠩� � �ᯮ�짮������ XMS.',0Ah, 0Dh
           db '����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 30',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ��⥫� �����.',0Ah, 0Dh, 0Ah
           db 9,9,'=== �����, ��᪢�, 2001 ��� ===',0Ah,0Dh,'$'

Mess_nohimem db '�ࠩ��� Himem.sys �� ����㦥�! ���������� �ᯮ�짮���� XMS-������!!!'
Mess_cursor db 0Ah, 0Dh,'$'

Error_alloc db '�訡�� ��।������ �᭮���� �����!',0Ah, 0Dh,'$'

Mess_errcopy db 0Ah,0Dh,'�訡�� �� ����஢����!',0Ah,0Dh,'$'
Info1 db 0Ah,0Ah,0Dh,'���� 䠩�...$'
Info2 db 0Dh,'���� 䠩�... $'

Mess_noexist db '�� ���� ������ 䠩� '
File_name    db 'c:\file.txt',0
             db '!',0Ah, 0Dh,'$'

Mess_exist db '���� '
File_new   db 'c:\filenew.txt',0
           db '㦥 �������! �������� ��� (Y/N)?$'

XMS_Addr dd ?
Number_dec dd ?
Buffer dw ?
Bytes dd 0
Total_bytes dd 0

XMS_str    dd 0 ;���-�� ���� ��� ����뫪�
XMS_src    dw 0 ;���筨�
XMS_offsrc dd 0 ;���饭�� � �����-���筨�� ��� ���� � �᭮���� �����
XMS_rec    dw 0 ;�����䨪��� �ਥ�����
XMS_offrec dd 0 ;���饭�� � �����-�ਥ����� ��� ���� � �᭮���� �����

XMS_id dw ?

Handle dw ?

Finish equ $

CSEG ends
end Start