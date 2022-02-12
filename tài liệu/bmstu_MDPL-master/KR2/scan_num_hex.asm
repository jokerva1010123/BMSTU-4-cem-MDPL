PUBLIC SCAN

DSEG	SEGMENT PARA PUBLIC 'DATA'
		ENT		DB	'>> $'
		NLINE	DB	10, 13, '$'
DSEG	ENDS

CSEG	SEGMENT PARA PUBLIC 'CODE'
		ASSUME CS:CSEG
		
SCAN PROC NEAR
	MOV  AH, 9
	MOV  DX, OFFSET ENT
	INT  21H
	
	XOR  BX, BX
	XOR  CX, CX
	
	INPUT_CYCLE:
		MOV  AH, 8
		INT  21H
		
		CMP  AL, 13
		JE   INPUT_END
		
		CMP  AL, '-'
		JE   NEG_NUMBER
		
		CMP  AL, '0'
		JB   NOT_NUM
		CMP  AL, '9'
		JA   NOT_NUM
		
		MOV  AH, 2
		MOV  DL, AL
		INT  21H
		
		SUB  AL, '0'
		
		JMP  CYCLE_END

	NOT_NUM:
		CMP AL, 'A'
		JB INPUT_CYCLE
		CMP AL, 'F'
		JA INPUT_CYCLE
		
		MOV AH, 2
		MOV DL, AL
		INT 21H

		ADD AL, 10
		SUB AL, 'A'
		
	CYCLE_END:
		MOV CL, AL
		MOV AX, BX

		SHL AX, 1
		SHL AX, 1
		SHL AX, 1
		SHL AX, 1
				
		MOV  BL, CL
		XOR  BH, BH
		ADD  BX, AX

		JMP  INPUT_CYCLE	
		
	NEG_NUMBER:
		MOV  AH, 2
		MOV  DL, AL
		INT  21H
		
		MOV  CH, 1
		
		JMP  INPUT_CYCLE
		
	INPUT_END:
		MOV  AH, 9
		MOV  DX, OFFSET NLINE
		INT  21H
		
		CMP  CH, 1
		JNE  FINAL

		NEG  BX
		
	FINAL:
		XOR  DH, DH
		MOV  DL, CH
		MOV  AX, BX
		
		RET
		
SCAN ENDP

CSEG	ENDS
END