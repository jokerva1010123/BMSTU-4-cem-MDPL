
;            ENV23.ASM - �������⥫쭠� �ணࠬ�� � ����� � 23

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

;   === ��砫� �ணࠬ��: ===
cseg segment
assume cs:cseg, ds:cseg, ss:cseg, es:cseg
org 100h

Begin:
       mov ax,3
       int 10h        ;���⨬ ��࠭

       mov ax,cs:[2Ch]
       mov ds,ax      ;DS 㪠�뢠�� ᥣ���� ���㦥��� DOS
       xor si,si      ;SI - ᬥ饭��

       mov ah,2       ;�㭪�� �뢮�� ������ ᨬ���� �� ��࠭

Next_char:
       lodsb          ;����砥� ���� ᨬ���
       or al,al       ;�� ���?
       jz End_param   ;�� - ⮣�� ���� ��ࠬ��� �����稫�� 

Next_param:
       mov dl,al      ;���, �� ���. ����� �뢮��� ����祭�� ᨬ���...
       int 21h        ;...�� ��࠭ � ⥪���� ������ �����
       jmp short Next_char ; ����㯠�� � ᫥���饬� ᨬ����... 

End_param:
       mov dl,0Ah     ;���⨣��� ����� ��ࢮ�� ��ࠬ���
       int 21h        ;�뢥��� ������ ���⪨ / ��ॢ�� ��ப�,
       mov dl,0Dh     ;�⮡� ��ࠬ���� �� �뫨 � ���, � ����� ��稭����
       int 21h        ;� ᫥���饩 ��ப�.

       lodsb          ;����稬 ��।��� ᨬ��� �� ��ப� ���㦥��� DOS
       or al,al       ;�᫨ �� 0, � �� ��ࠬ���� �뢥����.
       jnz Next_param ;��� ��室��� � DOS.
                      ;���� - �뢮��� ��।��� ��ࠬ���... 

       int 20h

cseg ends
end Begin
