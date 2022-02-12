DSeg	SEGMENT 'DATA'
	F	DW ?
	Nb	DW 4
DSeg	ENDS

SSeg	SEGMENT STACK 'STACK'
		DW	128h DUP (?)
SSeg	ENDS	
	
CSeg	SEGMENT 'CODE'
	ASSUME CS:CSeg, DS:DSeg, SS:SSeg
	Fact PROC NEAR
		PUSH	BP
		MOV		BP,SP
		N	EQU	[BP+4]
		MOV		CX, N
		DEC		CX
		JNE		M1
		MOV		AX,1
		POP 	BP
		RET
M1:
		PUSH 	CX
		CALL	Fact
		ADD		SP,2
		MOV		CX,N
		MUL		CX
		POP		BP
		RET
	Fact ENDP


MainProc:
	MOV		AX,DSeg
	MOV		DS,AX
	PUSH 	Nb
	CALL	Fact
	MOV		AH,4Ch
	INT		21h
CSeg	ENDS
		END MainProc