Extern String : byte,
       New_line : byte

StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS

DataS SEGMENT PARA PUBLIC 'DATA'

DataS ENDS

Code SEGMENT PARA 'CODE'
    ASSUME CS: Code, SS:StkSeg
Main:
    mov AX, DataS
    mov DS, AX

    mov AH, 0Ah
    mov DX, OFFSET String
    int 21h

    mov DX, OFFSET New_line
    mov AH, 09h
    int 21h

    mov SI, OFFSET String + 2
    mov AL, String[SI]
    sub AL, 30h
    mov CX, 0
    mov CL, AL
inc_SI:
    inc SI
    loop inc_SI
    mov DL, String[SI]
    mov AH, 02h
    int 21h
    
    mov AH, 4Ch
    int 21h
Code ENDS
END Main