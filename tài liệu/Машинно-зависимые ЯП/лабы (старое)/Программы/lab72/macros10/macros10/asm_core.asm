.386

;������ ����� ��� ������ � WinAPI����� ��������� ������
.model flat,stdcall


;���������� ����������� ����������
includelib kernel32.lib
includelib user32.lib


;������������� ������� �� WinAPI
AllocConsole PROTO											;����������� �������, ��� ������
GetStdHandle PROTO :DWORD									;����� � EAX �����, ����������� ��� ����������� �����/������
WriteConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD	;����� ������� �� �����
STD_OUTPUT_HANDLE equ -11;	��������� ��� ��������� ������


;������������� ������������:
;	WriteConsoleA (DWORD hConsoleOutput, DWORD lpBuffer, DWORD nNumberOfCharsToWrite, DWORD lpNumberOfCharsWritten, DWORD lpReserved)
;hConsoleInput - ����� �������
;lpBuffer - ����� ������, � �������� ���������� ����� ������
;nNumberOfCharsToWrite - ��������������� ����� ��������� ��������
;lpNumberOfCharsWritten - ����� ������ ������, ���� ������� ������� ����� ���������� ����������) ��������
;lpReserved - ����� ������ ������ ��� ������������������ ���������.  


.data
	X DB 11011001b, 10011100b, 01000011b, 11000000b		;������� ������
	Y DB 00001100b, 10001000b, 11011111b, 10000000b
	Result	DD	?		;���������� ������������ ������������� ��������
	Buf		DB	?,0		;������ ��� ������ �������������
	BufS	DW	?		;����� ������ ��� ������
	
	sX		DB	'bitstr X:		',0
	sY		DB	'bitstr Y:		',0
	sAdd	DB	'X u Y:			',0
	sDel	DB	'(XuY) \ Y:		',0
	sSet9	DB	'Setted 9:		',0
	sCons	DB	'Constructed 0, 2, 7:	',0



.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;�������� ������ �� �������� DL

PR_PrintSym	PROC	NEAR
	;�������� � ������������ ��� ������ ������������ EAX,ECX,EDX,EDI: ������� �� �� ���������
	PUSH EAX
	PUSH ECX
	PUSH EDX
	PUSH EDI
	
	MOV Buf,DL	;��������� ���������� ������ � ������

	invoke GetStdHandle, STD_OUTPUT_HANDLE					;�������� � EAX ����� ������������ �������
	MOV EDI, EAX
	invoke WriteConsoleA, EDI, ADDR Buf, 1, ADDR Result, 0	;�������� ������ Buf � ������� � ������� EDI
	
	POP EDI
	POP EDX
	POP ECX
	POP EAX
	RET
PR_PrintSym ENDP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;��������� ������

PR_NewLine	PROC	NEAR
	PUSH	EAX
	PUSH	EDX
	
	MOV		DL,10
	CALL	PR_PrintSym
	MOV		DL,13
	CALL	PR_PrintSym
	
	POP		EDX
	POP		EAX
	RET
PR_NewLine	ENDP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;�������� ����� �� AX

PR_PrintNum	PROC NEAR	
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	
	MOV		ECX,0
	MOV		EDX,0
	MOV		EBX,10	;������ ����� �� 10

	;�������� � ECX ���������� ���� ��� ������ � � ����� ���� �����
	;���� �������� 123, �� � ���� ��������� 3, ����� 2, ����� 1
	Lpn_GetNum:
		DIV		EBX		;����� �� 10, � EDX ��������� �������, � EAX �������
		INC		ECX
		PUSH	EDX		;��������� �������
		MOV		EDX,0
		CMP		EAX,0
	JNE		Lpn_GetNum
	
	;�������� ������� (������� �������� 1, ����� 2, ����� 3)
	Lpn_PrintN:
		POP		EDX
		ADD		DL,'0'
		CALL	PR_PrintSym
	LOOP	Lpn_PrintN

	POP		EDX
	POP		ECX
	POP		EBX
	RET
PR_PrintNum ENDP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;--------------------------------------------------------------------------------------------
;�������� ����� STR
PRINTTEXT	MACRO	STR
	PUSH EAX
	PUSH ECX
	PUSH EDX
	PUSH EDI
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	MOV EDI, EAX
	invoke WriteConsoleA, EDI, ADDR STR, SIZEOF STR, ADDR Result, 0
	POP EDI
	POP EDX
	POP ECX
	POP EAX
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;�������� ������� ������ STR ������ LSTR

PUTSTR	MACRO	STR, LSTR
	LOCAL	Lps_Loop1, Lps_Loop2, Lps_End
	
	PUSH	ECX	;�������
	PUSH	EDX	;������
	PUSH	EAX	;������
	PUSH	EBX	;�����/�������
	PUSH	EDI	;������
	
	MOV		EDI,0
	MOV		BH,0	;� BH ����� ������� ���������� ������������� ��������
	;����� ��� �������� ������ ������
	Lps_Loop1:
		MOV		BL,STR[EDI]	;�������� DI� ������� ����� �������
		MOV		ECX,8
		Lps_Loop2:			;�������� 8 ��� ����� ��������
			MOV		DH,0
			MOV		DL,BL	;��������� � DX �������
			DEC		ECX
			SHR		EDX,CL	;�������� ��� CL� ���
			INC		ECX
			AND		DL,0001b;������ �� DL ������ ��� ����
			ADD		DL,'0'	;�������� CL� ���
			CALL	PR_PrintSym
			
			INC	BH
			CMP	BH,LSTR		;���� ��������� ���������� ������ - ������� ����
			JE	Lps_End
		LOOP	Lps_Loop2
		MOV		DL,'|'
		CALL	PR_PrintSym
		INC		EDI			;��������� � ���������� �������� �������
		CMP		EDI,4		;������� ���� ���� ������ ��������
	JB		Lps_Loop1
		
	Lps_End:
	CALL	PR_NewLine
	POP		EDI
	POP		EBX
	POP		EAX
	POP		EDX
	POP		ECX
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;������������� POS ��� ������ STR � 1

SET1 MACRO STR, POS
	PUSH	EDI	;������
	PUSH	ECX	;�����
	PUSH	EAX	;�����
	
	;����� ��� �������� ������ ������
	MOV		EDI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		ECX,8	;� AL ��������� ������ �������� (� �����), � ������� ����� ������,
	DIV		CL		;� AH - ������ ������������ ����� ��������
	MOV		CL,AH	;�������� ����� ������
	MOV		AH,0
	SUB		EDI,EAX	;� ������
	
	MOV		AH,0
	MOV		AL,STR[EDI]	;�������� ������ �������
	MOV		CH,1b
	SHL		CH,CL		;���������� �����
	OR		AL,CH		;��������� ������ ���
	MOV		STR[EDI],AL	;�������� ���������� �������� ������� � ������
	
	POP		EAX
	POP		ECX
	POP		EDI	
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;��������� � 1 �������� �� LIST

KONSTRUKTOR MACRO STR, LIST
	IRP BIT, <LIST>
		SET1 STR, BIT
	ENDM
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;��������� � 0 ������� POS

SET0	MACRO	STR, POS
	PUSH	EDI	;������
	PUSH	ECX	;�����
	PUSH	EAX	;�����
	
	;����� ��� �������� ������ ������
	MOV		EDI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		ECX,8	;� AL ��������� ������ �������� (� �����), � ������� ����� ������,
	DIV		CL		;� AH - ������ ������������ ����� ��������
	MOV		CL,AH	;�������� ����� ������
	MOV		AH,0
	SUB		EDI,EAX	;� ������
	
	MOV		AH,0
	MOV		AL,STR[EDI]	;�������� ������ �������
	MOV		CH,11111110b
	ROL		CH,CL		;���������� �����
	AND		AL,CH		;��������� ������ ���
	MOV		STR[EDI],AL	;�������� ���������� �������� ������� � ������
	
	POP		EAX
	POP		ECX
	POP		EDI	
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;������� ���������� ������ � LSTR ��������

COUNT MACRO   STR, LSTR
	LOCAL	Lc_Loop1, Lc_Loop2, Lc_End, Lc_Skip
	
	PUSH	ECX	;�������
	PUSH	EBX	;�����/�������
	PUSH	EDI	;������
	PUSH	EAX
	
	MOV		EAX,0
	MOV		EDI,0
	MOV		BH,0	;� BH ����� ������� ���������� ���������� ��������
	;����� ��� �������� ������ ������
	Lc_Loop1:
		MOV		BL,STR[EDI]	;�������� DI� ������� ����� �������
		MOV		ECX,8
		Lc_Loop2:			;����������� 8 ��� ����� ��������
			PUSH	ECX
			MOV		ECX,1
			SHL		BL,CL	;��������� ������� ����� ���
			POP		ECX
			JNC		Lc_Skip	;���� ��������� 1 - �� �������� ���
				INC		EAX
			Lc_Skip:
			INC	BH
			CMP	BH,LSTR		;���� ��������� ���������� ������ - ������� ����
			JE	Lc_End
		LOOP	Lc_Loop2
		
		INC		EDI			;��������� � ���������� �������� �������
		CMP		EDI,4		;������� ���� ���� ������ ��������
	JB		Lc_Loop1
		
	Lc_End:
	CALL	PR_PrintNum
	CALL	PR_NewLine
	
	POP		EAX
	POP		EDI
	POP		EBX
	POP		ECX
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;���������� ������

XaddY MACRO   X, Y
	LOCAL	Lxay_Loop
	PUSH	EDI	;������
	PUSH	EAX	;�����
	
	MOV		EDI,0
	;����� � � � �������� ������� ������
	Lxay_Loop:
		MOV		AH,X[EDI]	;�������� DI� ������� ������� �
		MOV		AL,Y[EDI]	;�������� DI� ������� ������� �
		OR		AH,AL
		MOV		X[EDI],AH
		INC		EDI			;��������� � ���������� �������� �������
		CMP		EDI,4		;������� ���� ���� ������ ��������
	JB		Lxay_Loop		
	
	POP		EAX
	POP		EDI
ENDM
;--------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------
;�������� ������

XdelY MACRO   X, Y
	LOCAL	Lxdy_Loop
	PUSH	EDI	;������
	PUSH	EAX	;�����
	PUSH	EBX	;�����
	
	MOV		EDI,0
	;����� � � � �������� ������� ������
	Lxdy_Loop:
		MOV		AH,X[EDI]	;�������� DI� ������� ������� �
		MOV		BH,AH
		MOV		AL,Y[EDI]	;�������� DI� ������� ������� �
		XOR		AH,AL
		AND		AH,BH
		MOV		X[EDI],AH
		INC		EDI			;��������� � ���������� �������� �������
		CMP		EDI,4		;������� ���� ���� ������ ��������
	JB		Lxdy_Loop		
	
	POP		EBX
	POP		EAX
	POP		EDI
ENDM
;--------------------------------------------------------------------------------------------



main_asm	PROC	NEAR
	;��� ������, ������������ ����� ����� �������, � ����� �������� ����� - ����� ���������� ������� �������
	invoke AllocConsole



	PRINTTEXT	sX
	PUTSTR	X,32
	
	PRINTTEXT	sY
	PUTSTR	Y,32
	CALL	PR_NewLine

	PRINTTEXT	sAdd
	XaddY	X,Y
	PUTSTR	X,32	
	
	PRINTTEXT	sDel
	XdelY	X,Y
	PUTSTR	X,32

	PRINTTEXT	sSet9
	SET1	X,9
	PUTSTR	X,32

	PRINTTEXT	sSet9
	SET0	X,9
	PUTSTR	X,32
	
	PRINTTEXT	sCons
	KONSTRUKTOR	X,<0,2,7>
	PUTSTR	X,32
	
	COUNT	X,16

	RET
main_asm	ENDP

END