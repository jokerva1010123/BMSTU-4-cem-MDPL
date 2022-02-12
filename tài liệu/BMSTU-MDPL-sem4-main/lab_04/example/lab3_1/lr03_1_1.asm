EXTRN output_X: near					; описываем идентификатор output_Xближнего доступа (из другого подуля)

STK SEGMENT PARA STACK 'STACK'			; сегмент типа STACK размером параграф класса STACK
	db 100 dup(0)						; выделить ячейку 100 байт и заполнить ее нулями
STK ENDS								; конец сегмента

DSEG SEGMENT PARA PUBLIC 'DATA'			; сегмент типа PUBLIC размером параграф класса DATA
	X db 'R'							; ячейка 1 байт, даст ей имя Х и запишет туда R
DSEG ENDS								;

CSEG SEGMENT PARA PUBLIC 'CODE'			; сегмент типа паблик класс CODE
	assume CS:CSEG, DS:DSEG, SS:STK		; установка значений сегментов по умолчанию
main:									;
	mov ax, DSEG						; в регистр AX записываем адрес сегмента DSEG
	mov ds, ax							; в регистр данных DS записываем адрес регистра AX(так как нельзя сразу в DS записать)
										
	call output_X						; вызов процедуры output_X которую мы экспортировали

	mov ax, 4c00h						; код завершения
	int 21h								; вызов DOS
CSEG ENDS

PUBLIC X								; делаем ячейку X публичной

END main								; точка входа
