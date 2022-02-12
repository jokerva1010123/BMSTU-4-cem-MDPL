SD1 SEGMENT para public 'DATA'		; сегмент типа паблик размер параграф класс DATA
	S1 db 'Y'						; определяем ячейку в именем S1 и записываем туда Y
	db 65535 - 2 dup (0)			; выделяем 65533 байта....... зачем?
SD1 ENDS							;

SD2 SEGMENT para public 'DATA'		; то же, что и выше, только буква другая
	S2 db 'E'						;
	db 65535 - 2 dup (0)			;
SD2 ENDS							;

SD3 SEGMENT para public 'DATA'		; аналогично
	S3 db 'S'						;
	db 65535 - 2 dup (0)			;
SD3 ENDS							;

CSEG SEGMENT para public 'CODE'		; сегмент размером параграф типа паблик класс CODE 
	assume CS:CSEG, DS:SD1			; устанавливаем регистры по умлочанию
output:
	mov ah, 2						; команда вывода одного символа
	int 21h							; вызов ДОС
	mov dl, 13						; перевод строки на новую
	int 21h							;
	mov dl, 10						; в начало каретку перенести
	int 21h							;
	ret								; возврат к вызывающей стороне
main:
	mov ax, SD1						; кладем сегмент в AX
	mov ds, ax						; далее в DS
	mov dl, S1						; Далее в регистр ввода\вывода кладем букву Y
	call output						; вызываем печать
assume DS:SD2						; регистр по умлочанию
	mov ax, SD2						;
	mov ds, ax						; так же с буквой E
	mov dl, S2						;
	call output						;
assume DS:SD3						; регистр по умолчанию 
	mov ax, SD3						; вывод буквы S
	mov ds, ax						;
	mov dl, S3						;
	call output						;
	
	mov ax, 4c00h					; завершение работы
	int 21h							; 
CSEG ENDS							;
END main							;