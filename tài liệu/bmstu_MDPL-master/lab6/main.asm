EXTRN	INPUT : NEAR
EXTRN	UBin : NEAR	
EXTRN	SBin : NEAR	
EXTRN	UDec : NEAR	
EXTRN	SDec : NEAR	
EXTRN	UHex : NEAR	
EXTRN	SHex : NEAR	

SSTACK	SEGMENT PARA STACK 'STACK'
	DB	64 DUP('STACK___')
SSTACK	ENDS

DSEG	SEGMENT PARA PUBLIC 'DATA'
	F	DW	UBin, SBin, UDec, SDec, UHex, SHex
	X	DW	1
	
	MENU	DB	'MENU:', 10, 13
		DB	'   0. Menu', 10, 13
		DB	'   1. Input number', 10, 13
		DB	'   2. Bin unsigned', 10, 13
		DB	'   3. Bin signed', 10, 13
		DB	'   4. Dec unsigned', 10, 13
		DB	'   5. Dec signed', 10, 13
		DB	'   6. Hex unsigned', 10, 13
		DB	'   7. Hex signed', 10, 13
		DB	'   8. Exit', 10, 13, '$'
		
	ENT	DB	'> $'
	NLINE	DB	10, 13, '$'
DSEG	ENDS

CSEG	SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSTACK
BEGIN:
	MOV  AX, DSEG
	MOV  DS, AX
PMENU:
	MOV  AH, 9
	MOV  DX, OFFSET MENU
	INT  21H
		
PRINT_ENT:
	MOV  AH, 9
	MOV  DX, OFFSET ENT
	INT  21H
SCAN_CHOICE:
	MOV  AH, 8
	INT  21H
		
	CMP  AL, '0'
	JB   SCAN_CHOICE
	CMP  AL, '8'
	JA   SCAN_CHOICE
		
	MOV  BL, AL
	XOR  BH, BH
		
	MOV  AH, 2 ; ????? ???
	MOV  DL, AL
	INT  21H
		
	MOV  AH, 9
	MOV  DX, OFFSET NLINE
	INT  21H
		
PROCESS:
	SUB  BX, '0'
		
	CMP  BX, 8
	JAE  EXIT
		
	CMP  BX, 0
	JE   PMENU
		
	CMP  BX, 1
	JE   INPUT_NUMBER
		
	SUB  BX, 2
	SHL  BX, 1
		
	PUSH X
	PUSH SI
	CALL F[BX]
		
	JMP  PRINT_ENT
		
INPUT_NUMBER:
	CALL INPUT
		
	MOV  X, AX
	MOV  SI, DX
		
	JMP  PRINT_ENT
		
EXIT:
	MOV  AH, 4CH
	XOR  AL, AL
	INT  21H
		
CSEG	ENDS
END BEGIN