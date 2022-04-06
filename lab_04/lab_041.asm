Extern String : byte

StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS

Code SEGMENT PARA 'CODE'
    ASSUME CS: Code, SS:StkSeg
Main:
    mov DX, OFFSET String
    mov AH, 0Ah
    int 21h

    mov AH, 02h
    mov DL, 13
    int 21h
    mov DL, 10
    int 21h

    mov SI, OFFSET String + 2
    mov AL, String[SI]
    sub AL, 30h
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