.386

;сдкалл нужен для работы с WinAPIшными функциями вывода
.model flat,stdcall


;подключаем необходимые библиотеки
includelib kernel32.lib
includelib user32.lib


;прототипируем функции из WinAPI
AllocConsole PROTO											;подключение консоли, для печати
GetStdHandle PROTO :DWORD									;кладёт в EAX хэндл, необходимый для корректного ввода/печати
WriteConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD	;вывод символа на экран
STD_OUTPUT_HANDLE equ -11;	константа для получения хэндла


;использование врайтконсоля:
;	WriteConsoleA (DWORD hConsoleOutput, DWORD lpBuffer, DWORD nNumberOfCharsToWrite, DWORD lpNumberOfCharsWritten, DWORD lpReserved)
;hConsoleInput - хэндл консоли
;lpBuffer - адрес памяти, с которого начинается буфер вывода
;nNumberOfCharsToWrite - устанавливаемое число выводимых символов
;lpNumberOfCharsWritten - адрес ячейки памяти, куда функция запишет число фактически выведенных) символов
;lpReserved - адрес ячейки памяти для зарезервированного параметра.  


.data
	X DB 11011001b, 10011100b, 01000011b, 11000000b		;битовые строки
	Y DB 00001100b, 10001000b, 11011111b, 10000000b
	Result	DD	?		;количество напечатанных врайтконсолем символов
	Buf		DB	?,0		;символ для печати врайтконсолем
	BufS	DW	?		;адрес строки для печати
	
	sX		DB	'bitstr X:		',0
	sY		DB	'bitstr Y:		',0
	sAdd	DB	'X u Y:			',0
	sDel	DB	'(XuY) \ Y:		',0
	sSet9	DB	'Setted 9:		',0
	sCons	DB	'Constructed 0, 2, 7:	',0



.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;печатает символ из регистра DL

PR_PrintSym	PROC	NEAR
	;гетхендл и врайтконсоль при вызове переписывают EAX,ECX,EDX,EDI: поэтому мы их схороняем
	PUSH EAX
	PUSH ECX
	PUSH EDX
	PUSH EDI
	
	MOV Buf,DL	;сохраняем печатаемый символ в память

	invoke GetStdHandle, STD_OUTPUT_HANDLE					;получаем в EAX хендл используемой консоли
	MOV EDI, EAX
	invoke WriteConsoleA, EDI, ADDR Buf, 1, ADDR Result, 0	;печатаем символ Buf в консоль с хендлом EDI
	
	POP EDI
	POP EDX
	POP ECX
	POP EAX
	RET
PR_PrintSym ENDP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;переводит строку

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
;печатает число из AX

PR_PrintNum	PROC NEAR	
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	
	MOV		ECX,0
	MOV		EDX,0
	MOV		EBX,10	;делить будем на 10

	;получаем в ECX количество цифр для печати и в стеке сами цифры
	;если печатали 123, то в стек положится 3, потом 2, потом 1
	Lpn_GetNum:
		DIV		EBX		;делим на 10, в EDX останется остаток, в EAX частное
		INC		ECX
		PUSH	EDX		;сохраняем остаток
		MOV		EDX,0
		CMP		EAX,0
	JNE		Lpn_GetNum
	
	;печатаем символы (вначале снимется 1, потом 2, потом 3)
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
;печатает текст STR
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
;печатает битовую строку STR длиной LSTR

PUTSTR	MACRO	STR, LSTR
	LOCAL	Lps_Loop1, Lps_Loop2, Lps_End
	
	PUSH	ECX	;счетчик
	PUSH	EDX	;печать
	PUSH	EAX	;печать
	PUSH	EBX	;буфер/счетчик
	PUSH	EDI	;индекс
	
	MOV		EDI,0
	MOV		BH,0	;в BH будем хранить количество распечатанных символов
	;через СТР передаем МАССИВ БАЙТОВ
	Lps_Loop1:
		MOV		BL,STR[EDI]	;получаем DIй элемент этого массива
		MOV		ECX,8
		Lps_Loop2:			;печатаем 8 бит этого элемента
			MOV		DH,0
			MOV		DL,BL	;загружаем в DX элемент
			DEC		ECX
			SHR		EDX,CL	;получаем его CLй бит
			INC		ECX
			AND		DL,0001b;чистим из DL лишние три бита
			ADD		DL,'0'	;печатаем CLй бит
			CALL	PR_PrintSym
			
			INC	BH
			CMP	BH,LSTR		;если превысили количество печати - абандон тред
			JE	Lps_End
		LOOP	Lps_Loop2
		MOV		DL,'|'
		CALL	PR_PrintSym
		INC		EDI			;переходим к следующему элементу массива
		CMP		EDI,4		;абандон тред если массив кончился
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
;устанавливает POS бит строки STR в 1

SET1 MACRO STR, POS
	PUSH	EDI	;индекс
	PUSH	ECX	;буфер
	PUSH	EAX	;буфер
	
	;через СТР передаем МАССИВ БАЙТОВ
	MOV		EDI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		ECX,8	;в AL останется индекс элемента (с конца), в котором лежит разряд,
	DIV		CL		;в AH - разряд относительно этого элемента
	MOV		CL,AH	;сохраним новый разряд
	MOV		AH,0
	SUB		EDI,EAX	;и индекс
	
	MOV		AH,0
	MOV		AL,STR[EDI]	;получаем нужный элемент
	MOV		CH,1b
	SHL		CH,CL		;сформируем маску
	OR		AL,CH		;установим нужный бит
	MOV		STR[EDI],AL	;сохраним полученное значение обратно в память
	
	POP		EAX
	POP		ECX
	POP		EDI	
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;установка в 1 разрядов из LIST

KONSTRUKTOR MACRO STR, LIST
	IRP BIT, <LIST>
		SET1 STR, BIT
	ENDM
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;установка в 0 разряда POS

SET0	MACRO	STR, POS
	PUSH	EDI	;индекс
	PUSH	ECX	;буфер
	PUSH	EAX	;буфер
	
	;через СТР передаем МАССИВ БАЙТОВ
	MOV		EDI,3
	MOV		AH,0
	MOV		AL,POS
	
	MOV		ECX,8	;в AL останется индекс элемента (с конца), в котором лежит разряд,
	DIV		CL		;в AH - разряд относительно этого элемента
	MOV		CL,AH	;сохраним новый разряд
	MOV		AH,0
	SUB		EDI,EAX	;и индекс
	
	MOV		AH,0
	MOV		AL,STR[EDI]	;получаем нужный элемент
	MOV		CH,11111110b
	ROL		CH,CL		;сформируем маску
	AND		AL,CH		;установим нужный бит
	MOV		STR[EDI],AL	;сохраним полученное значение обратно в память
	
	POP		EAX
	POP		ECX
	POP		EDI	
ENDM
;--------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------
;считает количество единиц в LSTR символах

COUNT MACRO   STR, LSTR
	LOCAL	Lc_Loop1, Lc_Loop2, Lc_End, Lc_Skip
	
	PUSH	ECX	;счетчик
	PUSH	EBX	;буфер/счетчик
	PUSH	EDI	;индекс
	PUSH	EAX
	
	MOV		EAX,0
	MOV		EDI,0
	MOV		BH,0	;в BH будем хранить количество пройденных символов
	;через СТР передаем МАССИВ БАЙТОВ
	Lc_Loop1:
		MOV		BL,STR[EDI]	;получаем DIй элемент этого массива
		MOV		ECX,8
		Lc_Loop2:			;анализируем 8 бит этого элемента
			PUSH	ECX
			MOV		ECX,1
			SHL		BL,CL	;выдвигаем крайний слева бит
			POP		ECX
			JNC		Lc_Skip	;если выдвинули 1 - то запомним это
				INC		EAX
			Lc_Skip:
			INC	BH
			CMP	BH,LSTR		;если превысили количество поиска - абандон тред
			JE	Lc_End
		LOOP	Lc_Loop2
		
		INC		EDI			;переходим к следующему элементу массива
		CMP		EDI,4		;абандон тред если массив кончился
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
;объединяет строки

XaddY MACRO   X, Y
	LOCAL	Lxay_Loop
	PUSH	EDI	;индекс
	PUSH	EAX	;буфер
	
	MOV		EDI,0
	;через Х и У передаем МАССИВЫ БАЙТОВ
	Lxay_Loop:
		MOV		AH,X[EDI]	;получаем DIй элемент массива Х
		MOV		AL,Y[EDI]	;получаем DIй элемент массива У
		OR		AH,AL
		MOV		X[EDI],AH
		INC		EDI			;переходим к следующему элементу массива
		CMP		EDI,4		;абандон тред если массив кончился
	JB		Lxay_Loop		
	
	POP		EAX
	POP		EDI
ENDM
;--------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------
;вычитает строки

XdelY MACRO   X, Y
	LOCAL	Lxdy_Loop
	PUSH	EDI	;индекс
	PUSH	EAX	;буфер
	PUSH	EBX	;буфер
	
	MOV		EDI,0
	;через Х и У передаем МАССИВЫ БАЙТОВ
	Lxdy_Loop:
		MOV		AH,X[EDI]	;получаем DIй элемент массива Х
		MOV		BH,AH
		MOV		AL,Y[EDI]	;получаем DIй элемент массива У
		XOR		AH,AL
		AND		AH,BH
		MOV		X[EDI],AH
		INC		EDI			;переходим к следующему элементу массива
		CMP		EDI,4		;абандон тред если массив кончился
	JB		Lxdy_Loop		
	
	POP		EBX
	POP		EAX
	POP		EDI
ENDM
;--------------------------------------------------------------------------------------------



main_asm	PROC	NEAR
	;для работы, врайтконсолю нужен хэндл консоли, а чтобы получить хэндл - нужно собственно создать консоль
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