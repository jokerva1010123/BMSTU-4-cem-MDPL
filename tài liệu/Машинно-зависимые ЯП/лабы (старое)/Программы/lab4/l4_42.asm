;????????? ?????? ????????? ????? ????? ????????. ? ?????? lab04_41.asm
;???????? ??? ???????? ? ????? ???? ??? ?????? ???????? ?????????? ?.
;?? ?????? ?????? lab04_42.asm ????? ???????? ?????????? ? ???????? ?
;???? ??????? ?????????, ?????????? ?? ??????  ???????? call. ???
;??????? ????????? ????????? ? ??-?????????? ????????? ???? Z.BAT ???
;????????????????? ???????????????,  ?????-????? ? ?????????? ?????????
;? ??????????? ?????????? ?????
;1-??  ?  2-?? ???? ??? ????????? ???? ??????????. ????????? ??? ??????,
;????? ? ????????? ??????, ??????? ???????????? MASM ? LINK.
;????????????  ??  HELPR.EXE  ? ????????? ???????? ?????????? ????
;?????????? ? ???????? ? Z.BAT ?????? ????????? ???? ?????????? ?? 0?
;??? ????????? ???? ?????????? ?????????.


CSEG	SEGMENT
	ASSUME CS:CSEG
	EXTRN B:BYTE
	
	CALL PrintB
	
	MOV	AH,7		;???? ???????
	INT	21h
	
	MOV	AL,0		;?????
	MOV	AH,4Ch
	INT	21h
	

	PrintB PROC NEAR		
		MOV	DL,ES:B		;????? ???????
		MOV	AH,2
		INT	21h
		
		RET
	PrintB ENDP
CSEG	ENDS

	END 