.386
.model FLAT,C

public ASM_MAIN

include MacroLib.txt

.DATA
S 	DD 00111100001111000011110000111100B,1000001B 
           ;0-38 - ������� ������
S1 	DD 11000011110000111100001111000011B,0001000B 
           ;0-38 - ������� ������

.CODE
ASM_MAIN PROC

PUSHR <ESI,EDI,EBX,EBP>

COUNT S,39,EAX
KONSTRUKTOR S,39,<0,31>
COUNT S,39,EAX
SetCler S,0,0
SetCler S,31,0
COUNT S,39,EAX
AuB S,S1,39

POPR <EBP,EBX,EDI,ESI>

RET
ASM_MAIN ENDP
END