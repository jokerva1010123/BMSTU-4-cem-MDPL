EXTRN print_bin: near
EXTRN print_hex: near
EXTRN read_numb: near
EXTRN newline: near

STK SEGMENT PARA STACK 'STACK'
    db 200 dup (?)
STK ENDS

SEGDATA SEGMENT PARA PUBLIC 'DATA'
    menu_prnt db "1. Enter number"
              db 10
              db 13
              db "2. Convert to unsigned binary and print it"
              db 10
              db 13
              db "3. Convert to signed hexadecimal and print it"
              db 10
              db 13
              db "4. Exit" 
              db 10
              db 13
              db "Enter action: $"

    f_ptr     dw read_numb, print_bin, print_hex, exit
SEGDATA ENDS

SEGCODE SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:SEGCODE, DS:SEGDATA, SS:STK
main:
    mov ax, SEGDATA
    mov ds, ax

    menu:
        mov ah, 9
        mov dx, 0
        int 21h

        mov ah, 1
        int 21h

        mov ah, 0
        sub al, "1"
        shl ax, 1
        mov bx, ax

        call newline
        call f_ptr[bx]
        call newline
    jmp menu

exit proc near
    mov ah, 4ch
    int 21h
exit endp

SEGCODE ENDS
END MAIN
