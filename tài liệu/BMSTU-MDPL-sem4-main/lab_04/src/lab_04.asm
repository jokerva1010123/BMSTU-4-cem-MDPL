EXTRN OUTPUT: near					; экспорт метки OUTPUT 	

STKS SEGMENT PARA STACK 'STACK'		; сегмент стека
    DB 100 DUP (0)					;  
STKS ENDS							; 

DATAS SEGMENT PARA COMMON 'DATA'	; сегмент данных
    LETTER DB 3						; объявляю переменную LETTER и кладу туда 3 (т.к. команда 10 смотрит на то, что 
									; записано перед тем, как она будет записывать из stdin и то, что записано  
									; - максимальное кол-во смволов , которые можно дальше записать, поэтому 3, 
									; так как там идет сначала длина, потом сам символ и потом еще 0D - новая строка)
DATAS ENDS							; 

CODES SEGMENT PARA PUBLIC 'CODE'	; сегмент кода, который соедениться с сегментом , у которого то же название
    ASSUME CS:CODES, DS:DATAS		;  сегменты по умолчанию
    
MAIN:								; 
    MOV AX, DATAS					; просто записываю адрес сегмента
    MOV DS, AX						; в DS  через AX
    MOV DX, OFFSET LETTER			; ставлю DX на тот адрес, где начало LETTER
    MOV AH, 10						; ввести строку
    INT 21H							; вызов дос
	
	call OUTPUT						; вызов метки
    
    MOV AH,4Ch						; конец работы
    INT 21H							; вызов дос
CODES ENDS							; 
END MAIN							; 
