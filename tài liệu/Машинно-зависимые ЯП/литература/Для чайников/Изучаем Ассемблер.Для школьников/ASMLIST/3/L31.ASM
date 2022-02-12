; А.Крупник "Изучаем Ассемблер" листинг 3.1
.386
.model  flat,stdcall
.data
data_8     db -3 
data_16    dw ?
.code
start:
mov al, data_8
sub ah, ah
dec ah
mov data_16, ax
ret
end start
