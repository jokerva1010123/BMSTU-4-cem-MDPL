;        ===== DISPLAY.ASM - ��楤��� ࠡ��� � ��࠭�� ======

; === ���㥬 ࠬ�� ��������� ࠧ��� � 業�� ��࠭� ===
Draw_frame proc
     mov bp,sp
     add bp,2

     push es

     push 0B800h
     pop es

     mov ax,Height_X
     shr al,1
     mov dh,11
     sub dh,al

     mov ax,Width_Y
     shr al,1
     mov dl,39
     sub dl,al
     mov Num_DX,dx

     mov ax,Other
     test al,1
     jz No_copyscr

     mov ax,Height_X
     add ax,2
     call Copy_scr

No_copyscr:
     call Get_linear
     push di

     mov ax,Attr
     mov al,'�'
     stosw

     mov al,'�'
     mov cx,Width_Y
     rep stosw

     mov al,'�'
     stosw

     pop di
     add di,160
     inc dh

     mov cx,Height_X

Next_lined:
     push cx
     push di

     mov al,'�'
     stosw

     mov al,32
     mov cx,Width_Y
     rep stosw

     mov al,'�'
     stosw

     pop di
     add di,160
     inc dh
     pop cx
     loop Next_lined


     mov al,'�'
     stosw

     mov al,'�'
     mov cx,Width_Y
     rep stosw

     mov al,'�'
     stosw


     mov si,Mess_dn
     call Draw_messfr


     mov dx,Num_DX
     push dx

     mov si,Mess_up
     call Draw_messfr

     pop dx
     add dx,0101h
     mov si,Mess_ins
     or si,si
     jz No_draw
     mov ah,[si]
     inc si
     call Print_string


No_draw:
     mov ax,Other
     test ax,10b
     jz No_upline

     mov dx,Num_dx
     add dh,2
     call Get_linear

     mov ax,Attr
     mov al,'�'
     mov cx,1
     stosw

     mov cx,Width_Y
     mov al,'�'
     rep stosw

     mov al,'�'
     stosw


No_upline:
     pop es

     ret 14

Draw_frame endp


; --- �뢮� ᮮ�饭��� ������ � ����� ࠬ�� ---
;�ᯮ����⥫쭠 ��楤��.
Draw_messfr proc
     or si,si
     jz No_drawup

     mov ah,[si]
     inc si
     call Count_strmid

     call Print_string ;�뢮��� ��ப� �� ��࠭

No_drawup:
     ret
Draw_messfr endp

; === ����塞 �।��� ��ப� ===
Count_strmid proc
     push es
     push di
     push ax

     push cs
     pop es
     mov di,si
     xor al,al
     mov cx,0FFFFh
     repne scasb

     sub di,si
     dec di

     shr di,1
     mov ax,40
     sub ax,di
     mov dl,al

     pop ax
     pop di
     pop es
     ret
Count_strmid endp

; === �뢮� �⮪� �� ��࠭ ===
Print_string proc
     call Get_linear

Next_symstr:
     lodsb
     or al,al
     jz Stop_outstr
     stosw
     jmp short Next_Symstr

Stop_outstr:
     ret
Print_string endp

; === �८�ࠧ������ DH:DL � ������� ���ᨢ ===
Get_linear proc
    push ax
    push bx
    push dx

    shl dl,1

    mov al,dh
    mov bl,160
    mul bl

    mov di,ax
    xor dh,dh
    add di,dx

    pop dx
    pop bx
    pop ax
    ret

Get_linear endp


; === �����㥬 ���� ��࠭� ===
Copy_scr proc
    pusha
    push es
    push ds

    xor dl,dl
    call Get_linear

    mov bl,160
    mul bl
    mov cx,ax

    mov si,di
    xor di,di
    mov Num_copySI,si
    mov Num_copyDI,di
    mov Num_copyCX,cx
    push 0B800h
    pop ds
    push 0BA00h
    pop es
    rep movsb

    pop ds
    pop es
    popa
    ret

Num_copySI dw ?
Num_copyDI dw ?
Num_copyCX dw ?
Copy_scr endp

; === ����⠭�������� ���� ��࠭� ===
Restore_scr proc
    pusha
    push es
    push ds

    mov di,Num_copySI
    mov si,Num_copyDI
    mov cx,Num_copyCX
    push 0BA00h
    pop ds
    push 0B800h
    pop es
    rep movsb

    pop ds
    pop es
    popa
    ret
Restore_scr endp

; === ���祬 �����, ��࠭�� �।���⥫쭮 ��� ⥪���� ������ ===
Hide_cursor proc
    mov ah,3
    mov bh,Video_page
    int 10h
    mov Pos_cursor,dx

    mov ah,2
    mov bh,1
    int 10h

    mov bh,Video_page
    mov dx,1900h
    int 10h

    ret
Hide_cursor endp

; === ����⠭���� ����� ===
Restore_cursor proc
    mov ah,2
    mov bh,Video_page
    mov dx,Pos_cursor
    int 10h
    ret
Restore_cursor endp