
;            RESID27.ASM - �ணࠬ�� � ����� � 27

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE resid27.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE resid27.asm
;TLINK.EXE resid27.obj /t/x


;   === ��砫� �ணࠬ��: ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
    jmp Init ; �� ���� ���樠����樨 


; === ��ࠡ��稪 21h-��� ���뢠��� ===
Int_21h_proc proc
; ---
    cmp ax,9988h  ;�஢�ઠ �� ������� ����㧪�?
    jne No_test
    xchg ah,al    ;���� ��� "�⪫��".
    iret          ;� �����⠫쭮 ��室�� �� ���뢠���...

; ---
No_test:
    cmp ax,9999h  ;����砥� ���ଠ�� � ��襬 १�����?
    jne No_remove
    mov ax,9998h  ;���� �⪫�� �...

    push cs       ;...��।��� � ES ᥣ���� १�����...
    pop es
    mov dx,offset Int_21h_proc ;...� DX ᬥ饭��...

;...BX - ᬥ饭�� �ਣ����쭮�� ��ࠡ��稪�...
    mov bx,word ptr cs:[Int_21h_vect]
;...CX - ᥣ���� �ਣ����쭮�� ��ࠡ��稪�...
    mov cx,word ptr cs:[Int_21h_vect+2]
    iret ;...� ��室�� �� १�����.

; ---
No_remove:
;�� �� ᤥ���� ��� १�����? ��, ᮡ�⢥����, ���� �� � ⮬, �� �� �㤥�
;������, � � ⮬, �� �� ᬮ��� ��� ���㦠�� �� �����.
;���⮬� ������ ���� �㤥� �������� ᨬ���� 'A' �� 'Z', �᫨ ���
;�뢮����� �� ����� �㭪樨 02 ���뢠��� 21h. ���� �� �����:
    cmp ah,2
    jne Go_21h

    cmp dl,'A'
    jne Go_21h

    mov dl,'Z'

Go_21h:
;��।��� �ࠢ����� �।��饬� (�ਣ����쭮��) ��ࠡ��稪�
;21h-��� ���뢠��� ��� �᫮��� ⮣�, �� ��⮬ ����� ��୥��� � (jmp...).
;� ��� �᫨ �� �� �ᯮ�짮���� call..., � ... (�������� ᠬ�!).

    jmp dword ptr cs:[Int_21h_vect]

Int_21h_vect dd ?
Int_21h_proc endp




;   === ���樠������ (�����⮢�� � ����ன�� १�����) ===
Init:
       mov es,word ptr cs:[2Ch] ;����稬 ᥣ���� ���㦥��� DOS.
       mov ah,49h               ;�㭪�� �᢮�������� �����.
       int 21h                  ;�᢮������� ������...

       call Get_cmd  ;�஢�ਬ ��������� ��ப�

;�⠪,
;�᫨ ��祣� � ��������� ��ப� �� �������, ⮣�� �஡㥬 ��⠭����� १�����.
       or al,al
       jz Ok_cmd  ;

;�᫨ � ��������� ��ப� ������� '/u', � �஡㥬 㤠���� �ணࠬ�� �� �����.
       cmp al,1
       je Remove  ;

;� ��⨢��� ��砥 �뢥��� ᮮ�饭�� � ����୮� ��������� ��ப�
;� �����訬��...
Bad_cmd:
       mov dx,offset Mess_badcmd
       call Out_mess
       ret


;�� ��楤��� 㤠����� �ணࠬ�� �� �����...
Remove:
       jmp Remove_prog   ;


;��⠭�������� १�����.
Ok_cmd:
       mov ax,9988h ;�஢�ઠ �� ������� ����㧪�.
       int 21h
       cmp ax,8899h ;����稫� ��� �⪫��?
       jne Next_step2  ;���. ����� 

;�� 㦥 � �����! �뢥��� ᮮ⢥�������� ��ப�.
       mov dx,offset Mess_memory
       call Out_mess   ;������ᠫ쭠� ��楤�� �뢮�� ��ப�.
       ret   ;�멤�� � DOS...

Next_step2:
; === 21h ===
;�� ��⮢� ��� ���墠� ���뢠��� � ��⠭���� १�����.
       mov ax,3521h
       int 21h ;����稬 � ��࠭�� ���� (�����) 21h ���뢠���
       mov word ptr cs:[Int_21h_vect],bx ;���饭��...
       mov word ptr cs:[Int_21h_vect+2],es ;�������...

       mov ax,2521h
       mov dx,offset Int_21h_proc
       int 21h  ;"����ᨬ" ���� ��楤��� �� 21h ���뢠���

;�뢥��� ᮮ�饭��, ��, ���, �� � ���浪�!!! �ணࠬ�� ����㦥�� � ������!
       mov dx,offset Mess_hello
       call Out_mess

;��⠢�塞 १������� ���� � ����� � ��室�� � DOS.
       mov dx,offset Init
       int 27h


; ======= ��諨 ����ணࠬ�� =======

; --- ����稬 ��ࠬ���� � ��������� ��ப� ---
Get_cmd proc
       mov si,80h   ;SI=ᬥ饭�� ��������� ��ப�.
       lodsb        ;����稬 ���-�� ᨬ�����.
       or al,al     ;�᫨ 0 ᨬ����� �������,
       jz Got_cmd   ;� �� � ���浪�. 
       cmp al,3     ;���� ����� �� 3 ᨬ����? (�஡�� + /u)
       jne No_string ;�� - �� ���� No_string 

       inc si       ;������ SI 㪠�뢠�� �� ���� ᨬ��� ��ப�.

Next_char:
       lodsw       ;����砥� ��� ᨬ����
       cmp ax,'u/' ;�� /u? ������, �� ����� ���� �������!!!
       jne No_string ;�� - �� ��室... 

       mov al,1    ;������ ⮣�, �� ��� 㤠���� �ணࠬ�� �� �����
       ret

Got_cmd:
       xor al,al ;������ ⮣�, �� ��祣� �� ����� � ��������� ��ப�
       ret  ;��室�� �� ��楤���

No_string:
       mov al,3 ;������ ����୮�� ����� ��������� ��ப�
       ret  ;��室�� �� ��楤���
Get_cmd endp


; === ����塞 �ணࠬ�� �� ����� ===
Remove_prog:
;�०�� ���뫠�� ᨣ��� 21h-��� ���뢠���, �.�. 9999h.
       mov ax,9999h
       int 21h

;�᫨ � �⢥� ����砥� 9998h, � ��� १����� "ᨤ��" � �����.
       cmp ax,9998h
       je In_mem     ;��३��� �� ᮮ⢥�������� ����.

;�᫨ �� �� ����稫� �⪫�� (9998h), � ��� १����� �� ����㦥�.
;����騬 �� �⮬ ���짮��⥫� � �멤�� � DOS.
       mov dx,offset Mess_badmem
       call Out_mess
       ret


;�⠪, ��� १����� ᨤ�� � �����.

;������ �⪫��� �� ��襣� १����� �� ⠪�� ����砥� (�. ��楤���
;��ࠡ��� ���뢠��� 21h ���):
;* ES = ᥣ����, � ����� ����㧨��� १�����;
;* DX = ᬥ饭�� १����� � ������ ᥣ����;
;* CX = ᥣ���� �ਭ����쭮�� (�०����) ��ࠡ��稪� ���뢠��� 21h;
;* BX = ᬥ饭�� �ਭ����쭮�� (�०����) ��ࠡ��稪� ���뢠��� 21h.

In_mem:
       push es    ;���࠭�� ������� ॣ����� � �⥪�,..
       push bx

       mov Seg_21h,es ;...� ⠪�� � ��६�����.
       mov Off_21h,dx

       push bx
       push cx

       mov ax,3521h
       int 21h     ;����稬 ���� ��ࠡ��稪� 21h-���뢠���.

;����� �� �� ⮬�, �㤠 ����㦥� ��� ��ࠡ��稪?
;�᫨ ⠪, � ���� �� "�����" ��� ����. �.�. ����� ᬥ�� 㤠���� ����
;�ணࠬ�� �� �����.
       mov ax,es
       cmp ax,Seg_21h
       jne Cannot_remove

       cmp bx,Off_21h
       jne Cannot_remove

;��� � 㤠�塞. �����⥫쭮 ��᫥���, �� �� ����㦠�� � ॣ�����!
       cli
       mov ax,2521h
       pop ds
       pop dx
       int 21h

       push cs
       pop ds

       mov ah,49h
       int 21h
       sti

;�ணࠬ�� 㤠����! �뢥��� ᮮ�饭�� �� �ᯥ譮� 㤠����� � ��୥��� � DOS.
       mov dx,offset Remove_okmess

Exit_prog:
       call Out_mess
       int 20h


;���������� 㤠���� �ணࠬ��, �.�. ��-� "�����" ��� ����.
Cannot_remove:
;����騬 � ��稢襩�� ���� ���짮��⥫� � �멤�� � DOS...
       mov dx,offset Mess_cantremove
       jmp short Exit_prog

Seg_21h dw ?
Off_21h dw ?


; === �뢮� ��ப� �� ��࠭ ===
Out_mess proc
       mov ah,9 ;�뢮��� ��ப�. DX 㦥 ������ ᮤ�ঠ�� �� ����!
       int 21h

       mov ah,9 ;�뢮��� ᮮ�饭�� ⨯� "������ ���� �������".
       mov dx,offset Any_key
       int 21h

       xor ah,ah ;���� ������ �� �������...
       int 16h

       ret
Out_mess endp


;  === ����饭�� ===
Mess_hello db 0Ah,0Dh,'�������� � ����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 27.',0Ah,0Dh,0Ah
           db '����: ����譨��� ���� ����ᠭ�஢�� (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, �����, ��᪢�, 2001 ���.',0Ah,0Dh,0Ah
           db '!!! ��� �஢�ન ࠡ��� �ணࠬ�� �⠩� ����� 27 !!!',0Ah,0Dh,'$'

Mess_memory db 0Ah,0Dh,'!!! �ணࠬ�� 㦥 ����㦥�� � ������ !!!',0Ah,0Dh
            db '��� �� 㤠����� �� ����� 㪠��� /u � ��������� ��ப�!',0Ah,0Dh,'$'

Mess_badcmd db 0Ah,0Dh,'����୮ 㪠��� ��ࠬ��� � ��������� ��ப�!!!',0Ah,0Dh
            db '������ /u, �᫨ ��� 㤠���� �ணࠬ�� �� �����!',0Ah,0Dh,'$'

Mess_badmem db 0Ah,0Dh,'��... �ணࠬ�� ���� ��� � �����!!! ��� � ���� �� 㤠����???',0Ah,0Dh,'$'

Remove_okmess db 0Ah,0Dh,'�ணࠬ�� �ᯥ譮 㤠���� �� �����!!! ��!!!',0Ah,0Dh,'$'

Mess_cantremove db 0Ah,0Dh,'�� ���� 㤠���� १����� �� �����!!!',0Ah,0Dh,0Ah
                db '���� � ⮬, �� �����-� �ணࠬ�� ���墠⨫� 21h-�� ���뢠��� ��᫥ ⮣�,',0Ah,0Dh
                db '��� ����㦥� �� RESID27.COM. �०�� ����室��� 㤠���� �� �� �����,',0Ah,0Dh
                db '� ��⮬ 㦥 㤠���� RESID27.COM!',0Ah,0Dh,'$'

Any_key db 0Ah,'��� �த������� ������ ���� �������...$'

cseg ends
end Begin
