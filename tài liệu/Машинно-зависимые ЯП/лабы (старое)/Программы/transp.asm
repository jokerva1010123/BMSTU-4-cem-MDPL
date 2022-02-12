Data	SEGMENT
	N	EQU 4
	M	DB N DUP (N DUP (?)) ; ������� 4x4
Data	ENDS

Code	SEGMENT
	ASSUME CS:Code, DS:Data
BEGIN:
	MOV		AX,Data
	MOV		DS,AX
	
	;��������� �������: | a b c d | e f g h | � ��� �����
	MOV 	AL,'a'
	MOV		DI,OFFSET M ;���������� � �� ����� ������� &M
	MOV		CX,N
	F_1:			;for i=0, i<N
		PUSH	CX
		MOV		CX,N
		F_2:		;for j=0, j<N
			MOV		[DI],AL	;� M+i*N+j ���������� �����
			INC		DI
			INC		AL
		LOOP	F_2
		POP		CX
	LOOP	F_1
	
	;�������� �������
	MOV		AH,2		;����� �������� �������'
	MOV		DI,OFFSET M
	MOV		CX,N
	P_11:
		PUSH	CX
		MOV		CX,N
		P_12:
			MOV		DL,[DI]	;�������������� ��� ������ M+i*N+j
			INT		21h		;��������
			MOV		DL,' '
			INT		21h
			INC		DI
		LOOP	P_12
		POP		CX
		MOV		DL,10	;��������� ������
		INT		21h
		MOV		DL,13
		INT		21h
	LOOP	P_11
	
	;������������� �������: � i ������ ��� j ������� ������ swap(x+i*N+j,x+i+j*N)
	MOV		SI,1	;i, =1 ��� ��� x[0][0] �� ���������������
	T_1:
		MOV		DI,0	;j
		T_2:
			MOV		AX,SI	;i
			MOV		DX,N
			MUL		DX		;i*n
			ADD		AX,DI	;i*n+j
			MOV		BL,AL
			
			MOV		AX,DI	;j
			MOV		DX,N
			MUL		DX		;j*n
			ADD		AX,SI	;i+j*n
			MOV		BH,AL
			
			PUSH SI		;��� ��� ����������� ��� ���������� ������
			PUSH DI
			MOV		DH,0	;�������!
			MOV		DL,BL	;SI\DI �� ����� �������� � �������
			MOV		SI,DX	;������� ���������� � ������� DX
			MOV		DL,BH	;���������� BL\BH � �����
			MOV		DI,DX
			MOV		AH,M[DI]	;swap(x+ i*N +j , x+ i+ j*N)
			XCHG	M[SI],AH
			MOV		M[DI],AH
			POP DI
			POP SI
			INC		DI	;j++		
			
			CMP		DI,SI
		JB		T_2
		INC		SI	;i++
		CMP		SI,N
	JB		T_1
	
	;�������� ���������
	MOV		AH,2
	MOV		DL,10
	INT		21h
	MOV		DI,OFFSET M
	MOV		CX,N
	P_21:
		PUSH	CX
		MOV		CX,N
		P_22:
			MOV		DL,[DI]	;�������������� ��� ������ M+i*N+j
			INT		21h		;��������
			MOV		DL,' '
			INT		21h
			INC		DI
		LOOP	P_22
		POP		CX
		MOV		DL,10	;��������� ������
		INT		21h
		MOV		DL,13
		INT		21h
	LOOP	P_21
			
	;�����
	MOV		AH,4Ch
	MOV		AL,0
	INT		21h
Code	ENDS


Stack	SEGMENT STACK
	DB 128h DUP (?)
Stack	ENDS

	END BEGIN