; ==== KEYBOARD.ASM - ��楤��� ࠡ��� � ��������ன ====

;  === ���� ������ ������ ===
Pause proc
      mov ah,0
      int 16h
      ret
Pause endp

; === ������ ���� ===
;���짮��⥫� ����� ������� ����! ��ॢ���� ����� �� ᫥���騩 䠩�...
Down_pressed proc
      ;int 3  ;--- !!! ����������� ��⠭���� ����� ��� ��⠭��� !!!

      push es
      mov es,Seg_files
      mov di,Current_file

      mov ax,es:[di]
      or ax,ax
      jz Lowest_file

      mov Current_file,ax
      and byte ptr es:[di+4],11111110b

      mov di,ax
      or byte ptr es:[di+4],1

Lowest_file:
      pop es
      ret
Down_pressed endp

; === ������ ����� ===
;���짮��⥫� ����� ������� ����! ��ॢ���� ����� �� �।��騩 䠩�...
Up_pressed proc
      ;int 3  ;--- !!! ����������� ��⠭���� ����� ��� ��⠭��� !!!

      push es
      mov es,Seg_files
      mov di,Current_file

      mov ax,es:[di+2]
      or ax,ax
      jz Uppest_file

      mov Current_file,ax
      and byte ptr es:[di+4],11111110b

      mov di,ax
      or byte ptr es:[di+4],1

Uppest_file:
      pop es
      ret
Up_pressed endp

; === ������ Enter ===
Enter_pressed proc
;���짮��⥫� ����� ������� Enter! ���塞 ⥪�騩 ��⠫��...
;!!! ����� ��������, �� �� ���� �� �஢��塞, ����� �� ���짮��⥫� Enter
;�� ��⠫��� ��� 䠩�� !!!
;!!! ����� ⮣�, �� "���" ���室�� �� ��⠫�� ���孥�� �஢�� (..) !!!

      push ds
      push cs
      pop es

      mov si,Current_file
      add si,5

      mov di,Current_dir
      mov cx,0FFFFh
      xor al,al
      repne scasb
      dec di

      mov ds,Seg_files

Next_cdir:
      lodsb
      or al,al
      jz Got_dir
      stosb
      jmp short Next_cdir

Got_dir:
      mov ax,005Ch  ;'\'
      stosw

      pop ds

      call Draw_main_frame
      call Change_dir
      call Get_files
      call Out_files

      ret
Enter_pressed endp
