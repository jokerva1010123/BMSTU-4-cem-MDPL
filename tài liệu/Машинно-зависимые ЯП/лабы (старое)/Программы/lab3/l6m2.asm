;��� �3 ������� 6 ������ M2 (��. ������ M1)
DSEG	SEGMENT PUBLIC
;	EXTRN D1:BYTE  ;����� ����� 'D'
	D2	DB 'd'
DSEG	ENDS

	EXTRN D1:BYTE  ;����� ����� 'e'
ESEG	SEGMENT 
	E2	DB 'e'
ESEG ENDS

	PUBLIC PP2
CSEG	SEGMENT 
		ASSUME CS:CSEG, ES:DSEG, DS:ESEG
	PP2	PROC
		MOV		AX,DSEG
		MOV		ES,AX
		MOV		AX,ESEG
		MOV		DS,AX

		MOV		AH,2
		MOV		DL,D1
		INT		21H
		RET
	PP2	ENDP
CSEG ENDS
	END 
