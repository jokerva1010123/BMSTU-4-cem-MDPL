.XLIST



DSEGA	SEGMENT
	A	DB 'A'
DSEGA	ENDS

CSEG	SEGMENT
	ASSUME CS:CSEG
START:
	.LIST
		TITLE	l4_3.exe
		SUBTTL	DataSeg
	MOV AX,DSEGA
	MOV DS,AX
	MOV AX,DSEGB
	MOV ES,AX
	.XLIST
	
	MOV	DL,DS:A		;גûגמה סטלגמכא
	MOV	AH,2
	INT	21h
	
	MOV	AH,7		;גגמה סטלגמכא
	INT	21h
	
	MOV	DL,ES:B		;גûגמה סטלגמכא
	MOV	AH,2
	INT	21h
	
	MOV	AH,7		;גגמה סטלגמכא
	INT	21h
	.LIST
		SUBTTL	Exit
	MOV	AL,0		;גûץמה
	MOV	AH,4Ch
	INT	21h
	.XLIST
CSEG	ENDS

DSEGB	SEGMENT
	B	DB 'B'
DSEGB	ENDS

	END START