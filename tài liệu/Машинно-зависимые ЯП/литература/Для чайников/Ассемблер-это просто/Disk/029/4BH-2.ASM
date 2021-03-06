
;              4BH-2.ASM - �ணࠬ�� � ����� � 29

; (�) ����᪨� �ࠢ� �� 䠩��-�ਫ������ �ਭ������� ����� �����
; "��ᥬ����? �� ����! �稬�� �ணࠬ��஢��� ��� MS-DOS"
; ����: ����譨��� ���� ����ᠭ�஢�� (e-mail: Assembler@Kalashnikoff.ru)
;	 http://www.Kalashnikoff.ru

; --- ��ᥬ���஢���� (����祭�� *.com 䠩��) ---
;�� �ᯮ�짮����� MASM 6.11 - 6.13:
;ML.EXE 4BH-2.asm /AT

;�� �ᯮ�짮����� TASM:
;TASM.EXE 4BH-2.asm
;TLINK.EXE 4BH-2.obj /t/x


;__________________________________________________________________________
;
;!!! ��������! ���ࢠ ����� ����� 29, ���� ��祣� �� �㤥� ����⭮ !!!
;__________________________________________________________________________


;�ணࠬ�� ����㦠�� 䠩� (File) �ᯮ���� COMMAND.COM � ��������� ��ப��
;(Comm_param) 'abc'.

.186
CSEG segment
assume cs:CSEG, ds:CSEG, es:CSEG, ss:CSEG
org 100h

Start:
      mov bx,offset Finish
      shr bx,4
      inc bx
      mov ah,4Ah
      int 21h    ;������� ࠧ��� �⢥������ ����� �� ��⪨ Finish

;������� �⥪, �.�. �� ��室���� � "墮��" ᥣ����, �� ���� ���ண�
;�㤥� ����㦥�� �ணࠬ��
      mov sp,0FFh

; --- ��⮢�� EPB ---
      mov bx,offset EPB
      mov C_F,cs ;������� ��������� ��ப� (ᬥ饭�� 㦥 ����ᥭ�! ��. ����)

; --- ���࠭塞 ��� ॣ�����, �.�. ��� ���� ࠧ��襭�!!! ---
      pusha
      push ds
      push es
      mov SS_Seg,ss
      mov SP_Seg,sp

; --- ����᪠�� �ணࠬ�� ---
      mov ah,4Bh  ;�㭪�� EXEC (EXECute - ����� �ணࠬ��)
      mov dx,offset File ;��� 䠩�� ��� ����᪠
      mov al,0    ;����㧪� � �����
      int 21h

; --- ����⠭�������� ॣ����� ---
      mov ss,cs:SS_Seg
      mov sp,cs:SP_Seg
      pop es
      pop ds
      popa

      mov ah,9
      jnc OK      ;�� �뫮 �訡�� - ᮮ�頥� 


;������ ��� �������!
      mov dx,offset Mess_Error
      int 21h
      int 20h

;�ᯥ譠� ����㧪� �ணࠬ��
OK:
      mov dx,offset Mess_OK
      int 21h
      int 20h

;���, �� �� ����稬, �᫨ � ������� ������ �ணࠬ�� �� ����㧨� DN,
;� �� DN - Volcov Commander (��१�� �� VC) (�ࠢ��� � 4BH-1.com):

; ������   �ணࠬ��      ���墠�뢠��� ���뢠���
;����������������������������������������������������
;53 776   DOS 7.10       01 02 03 04 0E
;    64   system         19
; 6 928   KEYB           09 E0
; 3 824   WIN            EA F5
; 3 120   vmm32          33 67
; 1 280   DN.COM         FF              <==== �� DN ����㦠� 4BH-2.COM
; 7 456   COMMAND        2E              <==== ���� ��㧨��� Command.com
;   880   4BH-2.COM                      <==== ��⮬ ⮫쪮 4BH-2.COM
; 7 264   command                        <==== 4BH-2 ����㦠�� COMMAND.COM!
; 1 296   DN.COM         2F              <==== � ⮫쪮 ��⮬ DN.COM
; 7 280   COMMAND        22              <==== � �.�. (��� �� ��諮�� �ਬ��)
;76 096   VC.COM         00 1B 21 23 24


;����, ����� �㤥� ����㦠��
File db 'c:\command.com',0

;��������� ��ப� ����� ������ ᮤ�ঠ�� (�. ����):
;1. ����� ��������� ��ப� (�� 256 ����) (Comm_size)
;2. "/� ", 㪠�뢠�騩 COMMAND.COM, �� �㦭� ����㧨��, �믮����� � ���
;   �� COMMAND.COM (Comm_switch)
;3. ��� 䠩�� ��� ����㧪� (Comm_file)
;4. ��������� ��ப� ��� ����㦠����� �� COMMAND.COM 䠩�� (Comm_param)
Comm_line:
Comm_size   db 21      ;!!! �� ��������� �������� ����� ���������� ������ !!!
Comm_switch db ' /C '
Comm_file   db 'c:\dn\dn.com'
  ;Comm_file   db 'test(1)'  ;������� test(1).com (exe ��� bat), �᫨
			     ;⠪���� ������� � ⥪�饬 ��⠫��� ���
			     ;���� � ���� 㪠��� � ��६����� PATH.

  ;Comm_file   db 'dir /p'   ;�믮���� 㪠������ �������.

;�᫨ �ணࠬ�� ����㦠���� � �ᯮ�짮������ COMMAND.COM, � ���७��
;㪠�뢠�� �� ��易⥫쭮. �������� �������� (COMMAND.COM) �������
;�� �������� �������� �ணࠬ��, ���७�� ���ன �� COM, EXE ��� BAT!

Comm_param  db ' abc'
Comm_last   db 0Dh

;��������! ��१ COMMAND.COM ����� �믮����� ⠪�� ����� ����७���
;������� DOS, ��� �: DIR, CLS, TYPE � �� (�. ��� "dir /p").


; === Exec Parameter Block (EPB) ��� �㭪樨 4Bh ===
EPB:
Env dw 0   ;������� �।� (���㦥��� DOS) ��� ����㦠���� �ணࠬ��
C_O dw offset Comm_line ;���饭�� ��������� ��ப� +
C_F dw 0   ;+ ᥣ���� ��������� ��ப�
    dd 0   ;FCB (�� �ᯮ������)
    dd 0   ;FCB (�� �ᯮ������)
Len dw $-EPB  ;����� EPB


Mess_OK db 0Dh,0Ah,0Ah, '����饭�� �� 4Bh-2.com: �ணࠬ�� �뫠 �ᯥ譮 ����㦥�� � �믮�����!',0Ah,0Dh,0Ah,0Ah,'$'
Mess_Error db 0Dh,0Ah,0Ah, '����饭�� �� 4Bh-2.com: ���� �� ������!',0Ah,0Dh,0Ah,0Ah,'$'

; ��६���� ��� �࠭���� ᥣ������ ॣ���஢
SS_Seg dw ?
SP_Seg dw ?

; ��⪠ ���� �ணࠬ�� (�१��� ������ �� �⮩ ��⪨)
Finish equ $

CSEG ends
end Start