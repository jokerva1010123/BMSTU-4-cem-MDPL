
;            RESID27_.ASM - �������⥫�� १����� � ����� � 27

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

;!!! ������ �ணࠬ�� ���� "��蠥���" �� 21h-�� ���뢠��� !!!

;        !!! ��� �� ���짮������ - �⠩� 27 ����� !!!


;   === ��砫� �ணࠬ��: ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
    jmp Init ; �� ���� ���樠����樨


; === ��ࠡ��稪 21h-��� ���뢠��� ===
Int_21h_proc proc
    cmp ax,9977h
    jne No_test
    xchg ah,al
    iret

No_test:
    cmp ah,2
    jne Go_21h

    cmp dl,'A'
    jne Go_21h

    mov dl,'X'

Go_21h:
    jmp dword ptr cs:[Int_21h_vect]

Int_21h_vect dd ?
Int_21h_proc endp


;   === ���樠������ (�����⮢�� � ����ன�� १�����) ===
Init:
       mov ax,9977h ;�஢�ઠ �� ������� ����㧪�.
       int 21h
       cmp ax,7799h
       jne Next_step2

       mov ah,9      ;�� 㦥 � �����! �뢥��� ᮮ⢥�������� ��ப�.
       mov dx,offset Mess_memory
       int 21h

       ret   ;�멤�� � DOS...

Next_step2:
; === 21h ===
       mov ax,3521h
       int 21h ;����稬 � ��࠭�� ���� (�����) 09h ���뢠���
       mov word ptr cs:[Int_21h_vect],bx ;���饭��...
       mov word ptr cs:[Int_21h_vect+2],es ;�������...

       mov ax,2521h
       mov dx,offset Int_21h_proc
       int 21h  ;"����ᨬ" ���� ��楤��� �� 09h ���뢠���

       mov ah,9
       mov dx,offset Mess_hello
       int 21h  ;�� � ���浪�!!!

       mov dx,offset Init
       int 27h  ;��⠢�� ���� �ணࠬ�� � �����.

;  === ����饭�� ===
Mess_hello db 0Ah,0Dh,'�������� � ����� "��ᥬ����? �� ����! �稬�� �ணࠬ��஢���", ����� � 27.',0Ah,0Dh,0Ah
           db '����: ����譨��� ���� ����ᠭ�஢�� (Assembler@Kalashnikoff.ru),',0Ah,0Dh
           db 'http://www.Kalashnikoff.ru, �����, ��᪢�, 2001 ���.',0Ah,0Dh,'$'

Mess_memory db 0Ah,0Dh,'!!! �ணࠬ�� 㦥 ����㦥�� � ������ !!!',0Ah,0Dh,'$'

cseg ends
end Begin
