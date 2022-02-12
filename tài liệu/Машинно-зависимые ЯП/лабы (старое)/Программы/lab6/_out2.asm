PUBLIC	PR_Out2
EXTRN	PR_NewLine:NEAR






Code	SEGMENT	PUBLIC
	ASSUME CS:Code
;--------------------------------------------------------------------------------------
;Печатает переменную, переданную через стек, как двоичное число без знака (4 как 100, -4 как 1111111111111100)
;--------------------------------------------------------------------------------------
PR_Out2	PROC	NEAR
	PUSH	BP		;передаем параметр
	MOV		BP,SP
	PUSH	AX
	PUSH	DX
	PUSH	SI
	
	MOV		AX,[BP+4]	;получаем в АХ число, которое надо распечатать
	MOV		SI,16
	
	;избавляемся от лидирующих нулей
	LO2_Shl1:
		MOV		DH,0
		SHL		AX,1		;сдвигаемся влево пока не кончатся 0
		JNC		LO2_Shl1_CF
			INC		DH
			JMP		LO2_Shl2_CF
		LO2_Shl1_CF:
		DEC		SI
	JNZ		LO2_Shl1	;крутимся пока не выдвинем в CF 1 или не закончатся биты
	
	LO2_Shl2:
		MOV		DH,0
		SHL		AX,1
		JNC		LO2_Shl2_CF
			INC		DH
		LO2_Shl2_CF:
		MOV		DL,'0'
		ADD		DL,DH
		PUSH	AX
		MOV		AH,2
		INT		21h
		POP		AX
		DEC		SI
	JNZ		LO2_Shl2
	
	POP		SI
	POP		DX
	POP		AX
	POP		BP
	RET
PR_Out2	ENDP
;--------------------------------------------------------------------------------------
Code	ENDS

END