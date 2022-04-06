;записать элементы чётных столбцов в обратном порядке
;прямоугольная цифровая

Stk SEGMENT PARA STACK 'Stack'
    DB 100 dup (0)
Stk ENDS

DataS SEGMENT PARA PUBLIC 'Data'
    n DB 1
    m DB 1
    matrix DB 81 dup ('0')
    temp DB 0
    input_nm DB "Input n and m(1 space between digits): $"
    in_matrix DB 13, 10, "Input matrix(1 space between digits, enter to endline): ", 13, 10, '$'
    result DB 13, 10, "Result: $"
DataS ENDS

CodeS SEGMENT PARA PUBLIC 'Code'
    assume CS: CodeS, DS: DataS, SS: Stk

input_digit:
    mov AH, 01h
    int 21h
    RET

input_matrix:
    xor AX, AX
    mov AL, n
    MUL m
    mov CX, AX
    mov BX, 00h
input_next:
    call input_digit
    mov matrix[BX], AL
    int 21h
    INC BX
    loop input_next
    RET

change_matrix:
    xor ax, ax
    mov al, m
    mov CX, AX
    mul n
    sub Al, m
    mov temp, al
change:
    mov BX, CX
    dec BX
    test BX, 1
    JZ run_loop
    mov al, temp
    add AX, BX
swap:
    mov DL, matrix[BX]
    xchg AX, BX
    xchg DL, matrix[BX]
    xchg AX, BX
    xchg DL, matrix[BX]
    add BL, m
    CMP BX, AX
    JAE run_loop
    sub AL, m
run_loop:
    loop change
    RET

print_matrix:
    xor AX, AX
    mov AL, n
    MUL m
    mov CX, AX
    mov BX, 00h
print_next:                             ; Когда m кратно текущему индексу, то нужно вывести \n.
	MOV AX, BX
	DIV m 
	CMP AH, 0
	JNE print_digit                     ; Для \n (когда это нужно).
	MOV AH, 02h
	MOV DL, 10                          ; Возврат картеки.
	INT 21h
	MOV DL, 13                          ; \n
	INT 21h
print_digit: 
	MOV AH, 02h
	MOV DL, matrix[BX]
	INT 21h	
	MOV DL, ' '                         ; Для красивого вывода (пробелы между цифрами).
	INT 21h	
	INC BX
	LOOP print_next
	RET

main:
    mov AX, DataS
    mov DS, AX

    mov DX, offset input_nm
    mov ah, 09h
    int 21h

    call input_digit
    sub al, '0'
    mov n, al
    int 21h

    call input_digit
    sub al, '0'
    mov m, al
    int 21h

    mov DX, offset in_matrix
    mov ah, 09h
    int 21h

    call input_matrix

    call change_matrix
    
    mov DX, offset result
    mov ah, 09h
    int 21h

    call print_matrix

    mov AH, 4Ch
    int 21h

CodeS ENDS
END main