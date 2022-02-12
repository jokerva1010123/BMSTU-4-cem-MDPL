PUBLIC	PR_Out2
EXTRN	PR_NewLine:NEAR






Code	SEGMENT	PUBLIC
	ASSUME CS:Code
;--------------------------------------------------------------------------------------
;�������� ����������, ���������� ����� ����, ��� �������� ����� ��� ����� (4 ��� 100, -4 ��� 1111111111111100)
;--------------------------------------------------------------------------------------
PR_Out2	PROC	NEAR
	PUSH	BP		;�������� ��������
	MOV		BP,SP
	PUSH	AX
	PUSH	DX
	PUSH	SI
	
	MOV		AX,[BP+4]	;�������� � �� �����, ������� ���� �����������
	MOV		SI,16
	
	;����������� �� ���������� �����
	LO2_Shl1:
		MOV		DH,0
		SHL		AX,1		;���������� ����� ���� �� �������� 0
		JNC		LO2_Shl1_CF
			INC		DH
			JMP		LO2_Shl2_CF
		LO2_Shl1_CF:
		DEC		SI
	JNZ		LO2_Shl1	;�������� ���� �� �������� � CF 1 ��� �� ���������� ����
	
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