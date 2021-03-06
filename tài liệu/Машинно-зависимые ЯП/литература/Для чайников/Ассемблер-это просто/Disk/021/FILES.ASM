; ==== FILES.ASM - ��楤��� ࠡ��� � 䠩���� ====

; === ��⠥� 䠩�� � ⥪�饬 ��⠫��� ===
Get_files proc
      call Get_first    ;����砥� ���� 䠩�
      jc No_morefiles   ;�᫨ ��� 䠩��� ����� - �� ��室

      cmp word ptr cs:[DTA+1Eh],002Eh ;���� 䠩� - '.'?
      je Next_file    ;�᫨ ⠪, � �饬 ᫥���騩 䠩�...

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.

Next_file:
      call Get_other  ;����砥� ᫥���騩 䠩�...
      jc No_morefiles ;����� �����稫��� - �� ��室.

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.
      jmp short Next_file ;�饬 ᫥���騩 䠩�...

No_morefiles:
      ret
Get_files endp

; === ���� ��ࢮ�� 䠩�� � ⥪�饬 ��⠫��� ===
Get_first proc
;��ਡ��� 䠩�� (� CX):
;000001 - ⮫쪮 �⥭��
;000010 - ���⠭��
;000100 - ��⥬��
;001000 - ��⪠ ⮬�
;010000 - �����⠫��
;100000 - ��娢��

      mov ah,4Eh       ;�㭪�� ���᪠ ��ࢮ�� 䠩��
      mov cx,110111b   ;� ��ਡ�⠬�:
                       ;��娢�� (archive), �����⠫�� (directory),
                       ;��⥬�� (system), ���⠭�� (hidden)
                       ;⮫쪮 �⥭�� (read-only)
      mov dx,offset All_files ;��᪠ ���᪠
      int 21h
      ret
Get_first endp

; === ���� ᫥����� 䠩��� ===
Get_other proc
      mov ah,4Fh ;�㭪�� ���᪠ ᫥����� 䠩���
      mov dx,9Eh ;DX 㪠�뢠�� �� DTA
      int 21h

      ret
Get_other endp

; --- ��७�� 䠩�� �� DTA � ᥣ���� 䠩��� ---
Move_file proc
      push es
      mov si,DTA+1Eh  ;SI=DTA+1Eh=��� ���������� 䠩��
      mov di,Current_offset ;����饥 ᢮������ ᬥ饭��
      mov es,Seg_files  ;ES=ᥣ���� ��� ��������� 䠩���

Next_fbyte:
      lodsb         ;����砥� ���� ᨬ��� ����� 䠩��
      or al,al      ;�� ��� (����� �����)?
      jz End_offile ;�� - �� ��室
      stosb         ;��� - ��࠭�� ᨬ��� � �����
      jmp short Next_fbyte ;������騩 ᨬ���...

End_offile:
      stosb         ;����襬 ��� � ������ ��᫥ ����� 䠩��
      mov Current_offset,di ;���࠭�� ⥪�饥 ᬥ饭��
      stosb         ;����襬 �� ���� ���...
      pop es
      ret
Move_file endp

; === �뢮� �������� 䠩��� �� ��࠭ ===
Out_files proc
      mov bl,Number_files  ;BL 㪠�뢠�� �� ������⢮ �뢮����� 䠩���
      push ds
      push es
      mov ds,Seg_files ;DS=ᥣ���� ��������� 䠩��� � �����
      push 0B800h
      pop es

      xor si,si
      mov ah,1Bh   ;��ਡ���
      mov dx,0302h ;��砫� ��� �뢮�� 䠩���

Next_fileout:
      call Print_string ;�뢮��� ��।��� 䠩�

      cmp byte ptr [si],0 ;������騩 ����=0? �����, �� �� ��᫥��� 䠩�...
      jz Exit_files  ;����� ��室��.

      add dx,0100h ;���� 㢥��稢��� DH �� 1 ��� �뢮�� ᫥���饣� �����...
      dec bl       ;�����蠥� ������⢮ �뢮����� 䠩��� �� 1
      jnz short Next_fileout ;��� 0? ����� ����� �뢮���� �� �㦭�...

Exit_files:
      pop es
      pop ds
      ret

Number_files db 20 ;������⢮ �뢮����� 䠩��� �� ��࠭.
Out_files endp
