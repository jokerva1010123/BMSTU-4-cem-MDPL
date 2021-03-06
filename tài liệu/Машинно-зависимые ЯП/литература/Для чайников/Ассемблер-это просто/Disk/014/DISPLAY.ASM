
;        ===== DISPLAY.ASM - ��楤��� ࠡ��� � ��࠭�� ======

; === ���㥬 ࠬ�� ��������� ࠧ��� � 業�� ��࠭� ===
Draw_frame proc
     push es ;���࠭�� ES

     push 0B800h ;ES ������ 㪠�뢠�� �� ᥣ���� 0-�� �������࠭���
     pop es      ;�� �ࠡ�⠥� ⮫쪮 �� 286+ ������!!!

;________________________________________
;
; �ந������ ���᫥��� ��� ⮣�, �⮡�
; ࠧ������ ����� ࠬ�� � ��� ��࠭�!
;
; �㦭� ᫥���� �� ����� �����⥫쭮.
; ��� �������� �� �������...
;________________________________________

     mov ax,Height_X ;AX = ���� ��襩 ࠬ��
     shr al,1        ;����� ����� �� 2 ��⥬ ᬥ饭�� ��⮢ ��ࠢ� �� 1
     mov dh,11       ;��।���
     sub dh,al       ;DH (��ப�) ������!!!!!

     mov ax,Width_Y  ;AX = �ਭ� ��襩 ࠬ��
     shr al,1        ;����� �� �� 2
     mov dl,39       ;��।���
     sub dl,al       ;DL (�������) ������!!!!!
;������ DH ᮤ�ন� 業��஢���� �� (��ப�),
;� DL - ������� �⭮�⥫쭮 ࠧ��஢ ࠬ�� (���誠)...
;_________________________________________

     call Get_linear	;����砥� ������� ���� � ��������� �� DX,
     push di		;����� � ��࠭��...

     mov ah,Num_attr	;� AH - ��ਡ��� 梥�
     mov al,'�'		;���孨� ���� 㣮�...
     stosw		;����ᨬ ��� ���� (��ਡ�� � AH / ᨬ��� � AL)

     mov al,'�'		;�����...
     mov cx,Width_Y	;� CX - �ਭ� ࠬ��
     rep stosw		;���堫�...

     mov al,'�'		;�����蠥� ���孨� ��
     stosw

     pop di		;����⠭���� DI + 160 (᫥���騩 ��)
     add di,160

;������ � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;_ - ��� _, ⠬ � ��� DI


     mov cx,Height_X	;CX - ���-�� ����஢ (����)

Next_lined:
     push cx		;���࠭�� ���稪
     push di		;���࠭�� DI

     mov al,'�'		;�뢥�� ��� ᨬ��� (�� ����)
     stosw

     mov al,32		;32 - �஡�� (��� 20h ��� ' ')
     mov cx,Width_Y	;CX = �ਭ�
     rep stosw		;���堫�!

     mov al,'�'		;�����蠥� ��...
     stosw

     pop di
     add di,160		;��ॢ���� DI �� ᫥���騩 ��
     pop cx		;����⠭���� ���稪
     loop Next_lined	;������騩 ��...

;������ � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;�                           �
;�                           �
;�                           �
;_ - ��� DI


     mov al,'�'		;������ ���� ࠬ��...
     stosw

     mov al,'�'
     mov cx,Width_Y
     rep stosw

     mov al,'�'
     stosw

     pop es		;����⠭���� ES

;������ � ��� �ਬ�୮ ⠪�� ����� �� ��࠭�:
;���������������������������ͻ
;�                           �
;�                           �
;�                           �
;���������������������������ͼ

     ret


;��� �� � ����ᠫ� ���� �祭� ����� ��楤���, ���ன ����� ���짮������
;� �� �६� � ��⠢���� � ���� �ணࠬ��. ����, �� �� �㤥� ����� 祣�
;��������� � ���: �ᮢ��襭�⢮����, ��⮬�⨧�஢���, �᪮���� � ��.
;��� � 㦥 ����ਫ: �⮨� ���� ࠧ �������, � ��⮬...
Draw_frame endp


; === �८�ࠧ������ DH:DL � ������� ���ᨢ ===
Get_linear proc
    push ax	;���࠭�� �� �ᯮ��㥬� ॣ�����
    push bx
    push dx

    shl dl,1	;��⥬�⨪�: 㬭����� DL �� 2 (DL=DL*2)...

    mov al,dh	;� AL - ��,
    mov bl,160	;����� �㦭� 㬭����� �� 160
    mul bl	;��������: AL(��)*160; १���� --- � AX

;��祬� �� 160?
;���� � ⮬, �� ��������� ���஥� ��� ������� (��אַ�) ���ᨢ.
;���� ᨬ��� �������� 2 ����: ��ਡ��/��� ᨬ���.
;�.�. � ०��� 3 � ����� ��� 80 ᨬ�����, � ��� �㦭� 㬭����� �� 160!

    mov di,ax	;������� 㬭������ � DI
    xor dh,dh	;���㫨�㥬 DH
    add di,dx	;������ � DI ������� ���� � ���������...

    pop dx	;����⠭�������� ॣ�����...
    pop bx
    pop ax
    ret
;� ���� �窨 �७�� - �� �����쭮-⠪� ��⨬���� ������...
Get_linear endp


; === �஢��塞 �����०�� ������ � ⥪���� �������࠭��� ===
Check_video proc
     mov ah,0Fh
     int 10h
     cmp al,3	;����⮢� ०��?
     je Ok_video

     mov ax,3	;�᫨ ��� - ������ ⥪�⮢�
     int 10h

Ok_video:
     or bh,bh	;�㫥��� ��࠭��?
     jz Ok_page

     mov ax,0500h ;�᫨ ��� - ������ �㫥��� ⥪�饩
     int 10h

Ok_page:
     ret
Check_video endp

; === ���࠭�� ��࠭ ===
Save_mainscr proc
    pusha	;���࠭�� ��� ॣ����� (�஬� ᥣ������) � �⥪�
    push es	;�������� �ਤ���� ��࠭��� ᠬ���...
    push ds

    push 0B800h	;� �㫥��� ��࠭���
    pop ds
    xor si,si	;��ࢮ�� ᨬ����

    push 0B900h	;� ����� ��࠭���...
    pop es
    xor di,di	;���� ᨬ���...

    mov cx,2000	;4000 ����
    rep movsw	;������ �����...

    pop ds
    pop es
    popa	;����⠭���� ॣ����� (POP All - ��⮫����� ��)
    ret
Save_mainscr endp

; === ����⠭���� ��࠭ ===
Restore_mainscr proc
    pusha
    push es
    push ds

    push 0B900h	;� ��ࢮ� �������࠭���
    pop ds
    xor si,si

    push 0B800h	;� �㫥���...
    pop es
    xor di,di

    mov cx,2000
    rep movsw

    pop ds
    pop es
    popa
    ret
Restore_mainscr endp


; === ���祬 �����, ��࠭�� �।���⥫쭮 ��� ⥪���� ������ ===
Hide_cursor proc
    mov ah,3		;����砥� ⥪���� ������ �����
    mov bh,Video_page
    int 10h
    mov Pos_cursor,dx	;������ ��� � DX (����� � ���!)

    mov ah,2
    mov bh,Video_page	;���祬 ����� (��⠭���� ��� �� 25 ��ப� (19h))
    mov dx,1900h
    int 10h
    ret
Hide_cursor endp

; === ����⠭���� ����� ===
Restore_cursor proc
    mov ah,2
    mov bh,Video_page	;�������࠭��
    mov dx,Pos_cursor	;���࠭����� ������ �����
    int 10h		;��⠭���� (����樮���㥬) �����
    ret
Restore_cursor endp