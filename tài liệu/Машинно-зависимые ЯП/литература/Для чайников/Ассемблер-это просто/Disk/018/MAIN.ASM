
;                  === MAIN.ASM - �������� ��楤�� ===

Main_proc proc
      call Hide_cursor ;���祬 �����

      call Save_mainscr ;��࠭�� ᮤ�ন��� ��࠭�...

      push 23     ;���� ࠬ�� ��� '�ͻ' � '�ͼ'
      push 78     ;�ਭ� ࠬ�� (�.�. �� ���� ��࠭) ��� '�' � '�'
      push 1F00h  ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_head ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 1E00h  ;梥� ������ ������ ࠬ��
      push offset Mess_down ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push 1D00h  ;梥� ������ ����� ࠬ��
      push 0      ;ᮮ�饭�� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push 0      ;��ਡ��� ������ ����� ࠬ��
      push 0      ;����஢��� �� ��࠭? 1 - ��, 0 - ���
      call Draw_frame ;���㥬 ࠬ�� �� ���� ��࠭
;�����: � �⥪ ����ᨬ 20 ����.

Next_key:
      call Pause ;����� ������!!!
      or al,al
      jz Ext_code  ;�� ���७�� ASCII-��� ������? �� - �஢��塞 ���. 

      cmp al,27    ;������ ESC?
      jne Next_key ;��� - ���� �����... 

      call Quit_prog ;����⮢�ਬ�� � ���짮��⥫� � ��室� �� �ணࠬ��. 
      jnc Next_key   ;���짮��⥫� ���⢥न� ��室? ���? ����� �� Next_key 

;��, ���⢥न� (� ����!). ����� ��室��.
      call Restore_mainscr ;����⠭���� ᮤ�ন��� ��࠭�
      call Restore_cursor  ;����⠭���� ������ �����

      ret ;��室!

Ext_code:
      cmp ah,62h         ;������ Ctrl+F5?
      je User_screenl    ;�� - �����뢠�� ��࠭ ���짮��⥫� .
      jmp short Next_key ;��� - ���� ����� ������� 

User_screenl:
      mov ax,0501h ;�����뢠�� ���짮��⥫� 1 �������࠭���.
      int 10h
      call Pause   ;����� ����, ��������?.. �������, � �� ��� ����!

      mov ax,0500h ;����� �� �㫥��� ��⠭��������.
      int 10h
      jmp short Next_key ;���� �����... 
Main_proc endp

; === ��室�� �� �ணࠬ��? ===
Quit_prog proc
      push 1     ;���� ࠬ��
      push offset Mess_quitl ;�ਭ� ࠬ��
      push 4F00h ;梥� - ᢥ⫮-���� �� ᨭ�� 䮭�
      push offset Mess_qup   ;������� ������ ࠬ�� (�᫨ 0, � �� �뢮����)
      push 4E00h ;梥� ������ ������ ࠬ��
      push 0     ;������� ����� ࠬ�� (�᫨ 0, � �� �뢮����)
      push 0     ;梥� ������ ����� ࠬ��
      push offset Mess_quit  ;ᮮ�饭�� ����� ࠬ��
      push 4B00h ;梥� ᮮ�饭�� ����� ࠬ��
      push 1     ;����஢��� �� ��࠭? 1 - ��, 0 - ���
      call Draw_frame ;���㥬 ࠬ��

      call Pause
      call Restore_scr ;����⠭���� ��࠭㭭�� ���� ��࠭�.

      cmp al,'Y'       ;������ 'Y' / 'y' / Enter (13)?
      je Yes_quit      ;��! 
      cmp al,'y'
      je Yes_quit
      cmp al,13
      je Yes_quit

      clc  ;�⠢�� �����, �� ������ ����� ������� (��ᨬ 䫠� ��७��).
      ret

Yes_quit:
      stc  ;��⠭���� 䫠� ��७�� (������ 'Y', ����� ��室��)...
      ret
Quit_prog endp