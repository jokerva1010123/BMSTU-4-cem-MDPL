; ==== FILES.ASM - ��楤��� ࠡ��� � 䠩���� ====

; !!! ����� �ਤ���� ���������� �� �����, 祬 � Keyboard.asm !!!

; === ��⠥� 䠩�� � ⥪�饬 ��⠫��� ===
Get_files proc
      push es
      mov es,Seg_files

      mov Current_offset,500
      mov Prev_file,0

      mov di,Current_offset
      xor eax,eax
      stosd

      call Get_first  ;����砥� ���� 䠩�
      jc No_morefiles ;�᫨ ��� 䠩��� ����� - �� ��室

      cmp word ptr es:[2Ch],002Eh ;���� 䠩� - '.'?
      je Next_file_   ;�᫨ ⠪, � �饬 ᫥���騩 䠩�...

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.

Next_file_:
      call Get_other  ;����砥� ᫥���騩 䠩�...
      jc No_morefiles ;����� �����稫��� - �� ��室.

      call Move_file  ;�᫨ ���, � ��७�ᨬ 䠩� � ������.
      jmp short Next_file_ ;�饬 ᫥���騩 䠩�...

No_morefiles:
      mov di,Next_file
      xor ax,ax
      stosw

      mov di,500
      mov Current_file,di
;�㤥� 㪠�뢠�� �� �, �� ���� 䠩� - ⥪�騩
      mov di,Current_file
      or byte ptr es:[di+4],1

      pop es
      ret

All_files db '*.*',0
Seg_files dw ? ;�������� ���� ���� 䠩���
Current_offset dw 500
Next_file dw ?
Prev_file dw 0
Get_files endp

; === ���� ��ࢮ�� 䠩�� � ⥪�饬 ��⠫��� ===
Get_first proc
;����� ����� ���⠢��� �������� int 3 � � ����� �⫠��� ���������
;�⫠�稪� �믮����� �ணࠬ�� �� ���� (Run). ����� �� int 3 �⫠�稪
;��易⥫쭮 ��⠭������, �� �������� ��� �஠������஢��� ࠡ���
;�ਢ������� ���� ��ப. ���஡��!

;     int 3        ;<=== ��� �窠 ��⠭��� ��� �⫠�稪� (BreakPoint)

      mov ax,714Eh ;�㭪�� ���᪠ ��ࢮ�� 䠩��
      xor di,di ;DI ������ 㪠�뢠�� �� ����, �㤠 ���� �����뢠����
      xor si,si ;����� � ��������� 䠩�� (⨯� DTA). SI ���� ��⠥��� ⠩���!
      mov cx,0FFh ;�饬 �� �������� 䠩��. �� ��-� �த� ��ਡ�⮢ 䠩��
      mov dx,offset All_files ;��᪠ ���᪠
      int 21h
      mov Handle,ax ;���࠭�� ����� ����� ���᪠ 䠩��� ��� 714Fh
      ret
Get_first endp

; === ���� ᫥����� 䠩��� ===
Get_other proc
      mov bx,Handle ;����뢠�� ����� �����.
      mov ax,714Fh  ;�㭪�� ���᪠ ᫥����� 䠩���
      xor si,si
      xor di,di     ;DI ������ 㪠�뢠�� �� ����, �㤠 ���� �����뢠����
      int 21h       ;����� � ��������� 䠩�� (⨯� DTA).
      ret
Get_other endp

; --- ��७�� ����� ���������� 䠩�� � ᥣ���� 䠩��� ��襩 �ணࠬ�� ---
Move_file proc
;���������� ����� ⠪�� ��⠭����� ��� ��⠭���, ��� �������� ��� 
;      int 3
      push ds
      mov di,Current_offset ;����饥 ᢮������ ᬥ饭��
      push di

;�ய��⨬ 4 ����, � ����� ���� ����ᥭ� ���� �।��饣� � ᫥���饣�
;䠩��� � 楯�窥. 0000h �㤥� ᢨ��⥫��⢮���� � ��ࢮ� ��� ��᫥���� 䠩��.
      add di,4

      xor al,al      ;����ᥬ 0, �� �㤥� ᢨ��⥫��⢮����...
      stosb          ;...� ����� 䠩�� (⥪�騩 �/��� �⬥祭��)
      mov ds,Seg_files
      mov si,2Ch     ;SI=��� ���������� 䠩��

Next_fbyte:
      lodsb          ;����砥� ���� ᨬ��� ����� 䠩��
      stosb          ;���࠭�� ᨬ��� � �����
      or al,al       ;�� ��� (����� �����)?
      jnz Next_fbyte ;������騩 ᨬ���...

;����ᨬ ࠧ��� 䠩��
      mov si,1Ch     ;�� �⮬� ᬥ饭�� �㤥� ࠧ��� 䠩�� (4 ᫮��)
      lodsd
      stosd
      lodsd
      stosd

      pop si
      pop ds
      mov es:[si],di   ;���� ᫥���饣� 䠩��
      mov Next_file,si

      mov ax,Prev_file ;���� �।��饣� 䠩��
      mov es:[si+2],ax
      mov Prev_file,si

      mov Current_offset,di ;���࠭�� ⥪�饥 ᬥ饭��
      ret
Move_file endp

; === �뢮� �������� 䠩��� �� ��࠭ ===
Out_files proc
      ;int 3  ;--- !!! ����������� ��⠭���� ����� ��� ��⠭��� !!!

      mov bl,Number_files  ;BL 㪠�뢠�� �� ������⢮ �뢮����� 䠩���
      push ds
      push es
      push 0B800h
      pop es

      mov si,Start_file ;SI = ��砫��� ������ �� �뢮�� �� ��࠭
      mov ah,1Bh
      mov dx,0302h      ;��砫� ��� �뢮�� 䠩���
      mov ds,Seg_files  ;DS=ᥣ���� ��������� 䠩��� � �����

Next_fileout:
      mov di,[si]

      mov bh,[si+4]
      push di
      add si,5

      call Print_string     ;�뢮��� ��।��� 䠩�...

      call Print_fsize      ;�뢮��� ࠧ��� 䠩��...

      call Get_status       ;�஢�ਬ ����� 䠩��...

      pop si
      or si,si          ;��᫥���� 䠩�?
      jz Exit_files     ;����� ��室��.

      add dx,0100h ;���� 㢥��稢��� DH �� 1 ��� �뢮�� ᫥���饣� �����...
      dec bl       ;�����蠥� ������⢮ �뢮����� 䠩��� �� 1
      jnz short Next_fileout ;��� 0? ����� ����� �뢮���� �� �㦭�...

Exit_files:
      pop es
      pop ds
      ret

Number_files db 21 ;������⢮ �뢮����� 䠩��� �� ��࠭.
Start_file dw 500  ;���� (ᬥ饭��) ���⮢��� 䠩�� ��� �뢮�� �� ��࠭
                   ;���� 500 ���� �⢮����� ��� �㭪権 714Eh � 714Fh, �㤠
                   ;��� ���� ������� ���ଠ�� � ��������� 䠩��.
                   ;��-� �த� DTA, ⮫쪮 "��ᮢ६�����"...
Out_files endp

; === �஢��塞 ����� 䠩�� ===
Get_status proc
      pusha
      mov ah,1Bh   ;����� 䠩�...

      or bh,bh     ;���� �����-����� ��⪨?
      jz Quit_sts  ;��� - �� ��室 

      mov ah,30h
      cmp bh,1     ;�� ⥪�騩 䠩�?
      jz Quit_sts  ;�� - �� ��室 

      mov ah,1Eh
      cmp bh,2     ;�� �⬥祭�� 䠩�?
      jz Quit_sts  ;�� - �� ��室 

      mov ah,3Eh   ;����砥���, �� ⥪�騩 + �⬥祭��...

Quit_sts:
      mov dl,1     ;����ᮢ뢠�� ���...
      mov cx,78
      call Color_line
      popa
      ret
Get_status endp

; === �뢮��� ࠧ��� 䠩�� ===
Print_fsize proc
      pusha
      push ds

      mov eax,ds:[si]   ;����稬 ����� ���� ࠧ��� 䠩��
      mov ebx,ds:[si+4] ;����稬 ����� ����

      push cs
      pop ds

      mov si,offset Number_dec ;����ᥬ ࠧ��� 䠩�� � ��६����� Number_dec
      mov dword ptr [si],ebx   ;��楤�� Out_dec �㤥� �뢮���� �᫮,
      mov dword ptr [si+4],eax ;���஥ ��室���� ������ � �⮩ ��६�����.

      mov dl,50        ;DL 㪠�뢠�� �� �������
      mov ah,1Bh       ;AH ᮤ�ন� ��ਡ��� ��� �뢮������ �᫠
      call Out_dec     ;�뢮��� �᫮

      pop ds
      popa
      ret
Print_fsize endp