; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 10.4
Quit macro
     mov   ah, 4ch
     int   21h
endm
LDisp macro line
      mov   dx, offset line
      mov   ah, 09
      int   21h
endm
.8086
.MODEL  small
option casemap:none
.stack 100
.data
hello  db "�� ���� ������!", 0dh, 0ah, '$'
.code
start:
mov  dx,@stack
mov  ss,dx
mov  dx,@data 
mov  ds,dx    ;ॣ���� ������
LDisp hello   ;�뢮� �� ��࠭
Quit          ;�室��
end  start
