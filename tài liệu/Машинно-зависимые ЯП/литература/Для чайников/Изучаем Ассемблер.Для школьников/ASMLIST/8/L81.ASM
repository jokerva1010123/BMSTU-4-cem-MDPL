; �.��㯭�� "���砥� ��ᥬ����" ���⨭� 8.1
.8086
.MODEL  small
.stack 100
.data
hello db  "�� ���� ������!", 0dh, 0ah, '$'
.code
start:
mov  dx,@stack
mov  ss,dx
mov  dx,@data ;
mov  ds,dx    ;ॣ���� ������
mov  dx, offset hello
mov  ah, 09   ;�뢥�� �� ��࠭
int  21h
mov  ah, 4ch  ;�������� �ணࠬ��
int  21h
end  start
