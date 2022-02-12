EXTRN X: byte						; экспортируем Х (тип байт)
PUBLIC exit							; метку exit делаем публичной

SD2 SEGMENT para 'DATA'				; сегмент SD2 размером параграф и классов DATA
	Y db 'Y'						; выделяем байт под ячейку памяти, называем ее Y и кладем туда Y
SD2 ENDS							;

SC2 SEGMENT para public 'CODE'		; сегмент SC2 размером параграф тип паблик и класс CODE
	assume CS:SC2, DS:SD2			; устанавливаем регистры по умолчанию
exit:
	mov ax, seg X					; в AX кладем сегментную часть адреса X (Оператор SEG Возвращает сегментную часть адреса операнда.)
	mov es, ax						; в доп сегмент кладем AX 
	mov bh, es:X					; в BH (базовый регистр, часто указывается на начальный адрес базы структуры памяти)

	mov ax, SD2						; в AX положили SD2
	mov ds, ax						; потом положили это в DS
	
	xchg ah, Y						; меняю значение AH и Y (то есть в AH лежит код буквы Y, а в Y лежит, что лежало в AH)
	xchg ah, ES:X					; в ES:X лежит X, а в AH лежит Y, мы меняем их местами
	xchg ah, Y						; в AH было X, а в Y лежало то, что до начало всего этого лежало в AH
									; то есть теперь в X лежит 'Y', а в Y лежит 'X'
	mov ah, 2						; команда вывода символа
	mov dl, Y						; кладем то, что надо вывести, то есть с учетом всех смен это будет 'X'
	int 21h							; вызов дос
	
	mov ax, 4c00h					; конец)
	int 21h							; вызов дос
SC2 ENDS							;
END											