
;              XMSMEM.ASM - �ணࠬ�� � ����� � 30
;                 ��।��塞 ��ꥬ ����� XMS

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE xmsmem.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE xmsmem.asm
;TLINK.EXE xmsmem.obj /t/x


.386   ;������� 80386 ������ �㦭� ��� ࠡ��� � 32-� ࠧ�來묨 ॣ���ࠬ�
.8087  ;8087 �������� �㦥� ��� ��楤��� �뢮�� �������� �ᥫ
CSEG segment use16
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
     mov ah,9
     mov dx,offset Mess_about
     int 21h

;�஢�ਬ �� ����稥 Himem.sys � �����...
     mov ax,4300h
     int 2Fh

     cmp al,80h
     je Himem_loaded  ;�᫨ AL = 80h, � Himem.sys ����㦥�. 

;���� �뢮��� ᮮ�饭�� � ⮬, �� Himem � ����� �� �����㦥�...
     mov ah,9
     mov dx,offset Mess_nohimem
     int 21h
     ret


Himem_loaded:
;��⮢�� XMS-������ (�⢮��� ���� � XMS-�����)
     call Prepare_XMS

     ret



;=== ��⮢�� XMS-������ ===
Prepare_XMS proc
     mov ax,4310h
     int 2Fh

     mov word ptr XMS_Addr,bx
     mov word ptr XMS_Addr+2,es   ;���࠭�� ��ࠡ��稪 XMS-�㭪権

;����砥� ������⢮ �������� XMS-����� (�ᥣ�)
     mov ah,88h
     call dword ptr XMS_Addr
     mov dword ptr Number_dec,edx ;���࠭�� ����祭��� �᫮

     mov dx,offset Mess_TotalMemory
     mov ah,9
     int 21h

     mov ah,3
     xor bh,bh ;�������࠭��
     int 10h   ;��⠥� ⥪���� ������ �����

     add dx,8
     mov ah,2
     int 10h ;��⠭���� ����� �� 8 ����権 �ࠢ��, ��᫥ �뢥������� ᮮ�饭��

     call Out_dec ;�뢮��� ���-�� �������� XMS � ⥪���� ������ �����

     mov dx,offset Mess_cursor
     mov ah,9
     int 21h
     ret
Prepare_XMS endp


;=== �뢮� �����筮�� �᫠ �� ��࠭ � �ᯮ�짮������ ᮯ����� ===
;����� ��� �������ਥ�... ��. �।��騥 ���᪨...
Out_dec proc
    finit

    fstcw Dat
    or Dat,0C00h
    fldcw Dat
    fldz
    fild Divider
    fild Number_dec
    fst st(7)

Next_sym:
    fprem
    fistp Dat
    call Out_sym
    fld st(6)
    fdiv st,st(1)
    frndint
    fst st(7)
    fcom st(2)
    fstsw ax
    and ax,4500h
    cmp ax,4000h
    jnz Next_sym
Finish_dec:
    ret

Number_dec dq 0

Divider dw 10
Dat dw ?
Out_dec endp

;=== �뢮� ������ ᨬ���� �� ��࠭ � ⥪���� ������ ����� ===
Out_sym proc
    push dx

    mov ah,2
    mov dl,byte ptr Dat
    add dl,'0'
    int 21h
    pop dx

    dec dx
    mov ah,2
    xor bh,bh
    int 10h

    ret
Out_sym endp


Mess_about db 0Ah, 0Dh, 'XMSMEM - ��।��塞 ��ꥬ XMS-�����.',0Ah, 0Dh
           db '����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 30',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru. E-mail: Assembler@Kalashnikoff.ru',0Ah,0Dh,0Ah
           db '(C) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ��⥫� �����.',0Ah, 0Dh, 0Ah
           db 9,9,'=== �����, ��᪢�, 2001 ��� ===',0Ah,0Dh,'$'

Mess_nohimem db '�ࠩ��� Himem.sys �� ����㦥�! ���������� �ᯮ�짮���� XMS-������!!!'
Mess_cursor db 0Ah, 0Dh,'$'

Mess_TotalMemory db 0Ah,0Ah,0Dh,'�ᥣ� XMS-����� (��������):$'

XMS_Addr dw ?
CSEG ends
end Start