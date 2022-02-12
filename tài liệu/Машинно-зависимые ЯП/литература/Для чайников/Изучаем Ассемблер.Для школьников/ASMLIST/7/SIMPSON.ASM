; А.Крупник "Изучаем Ассемблер" 
.386
.model  flat, stdcall
option  casemap:none
Fun     PROTO
.data
two     dq 2.0
three   dq 3.0
four    dq 4.0
.code
Simpson  proc X0:DWORD,X2N:DWORD,NN:DWORD,
              H:QWORD,SUMADDR:DWORD
LOCAL   dstep:QWORD
Fld     H       ;загрузить шаг
fld     two     ;загрузить 2.0
fmul            ;шаг*2
fst     dstep   ;сохранить двойной шаг
fldz            ;загрузить сумму
fld     X0      ;начало интервала
fld     H       ;шаг
fadd            ;x0 + step
mov     ecx,NN  ;число слагаемых
fld     ST      ;дублируем x0 + step
nxt:   invoke Fun ;вычисляем функцию
faddp  ST(2), ST  ;суммируем + pop
fadd   ST, ST(2)  ;добавляем dstep
fld    ST         ;копируем новый x
loop   nxt        ;след. слагаемое
fcompp            ;убираем 2 числа
fld    four       ;ST = 4.0
fmul              ;sum = sum*4.0
fld    dstep      ;двойной шаг
fldz              ;sum = 0.0
fld    X0         ;
fld    dstep      ;
fadd              ;загружаем x0 + 2.0*H
mov ecx, NN
dec ecx       ;число слагаемых на 1 меньше
fld ST        ;дублируем x0 + dstep
nxt1:  invoke Fun ;вычисляем функцию
faddp  ST(2), ST  ;sum = sum + Fun(x) и pop
fadd   ST,ST(2)   ;x = x + dstep
fld    ST         ;дублируем x + dstep
loop   nxt1       ;новое слагаемое
fcompp            ;убираем два значения
fld    two        ;ST = 2.0
fmul              ;sum = sum * 2
fadd   ST, ST(2)  ;+предыдущая сумма
fld    X0
invoke Fun        ;fun(x0)
fadd              ;прибавим fun(x0)
fld    X2N        ;
invoke Fun        ;
fadd              ;прибавим fun(x2n)
fld    H          ;
fmul              ;sum = sum * h
fld    three      ;
fdivp  ST(1),ST   ;(h/3) * sum
mov    eax, SUMADDR
fstp   TBYTE PTR [eax];сохраняем интеграл
finit             ;очищаем сопроцессор
ret
Simpson endp
end
