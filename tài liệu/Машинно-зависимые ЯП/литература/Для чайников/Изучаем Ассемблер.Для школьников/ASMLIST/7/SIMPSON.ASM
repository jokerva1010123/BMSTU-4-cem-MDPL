; �.��㯭�� "���砥� ��ᥬ����" 
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
Fld     H       ;����㧨�� 蠣
fld     two     ;����㧨�� 2.0
fmul            ;蠣*2
fst     dstep   ;��࠭��� ������� 蠣
fldz            ;����㧨�� �㬬�
fld     X0      ;��砫� ���ࢠ��
fld     H       ;蠣
fadd            ;x0 + step
mov     ecx,NN  ;�᫮ ᫠������
fld     ST      ;�㡫��㥬 x0 + step
nxt:   invoke Fun ;����塞 �㭪��
faddp  ST(2), ST  ;�㬬��㥬 + pop
fadd   ST, ST(2)  ;������塞 dstep
fld    ST         ;�����㥬 ���� x
loop   nxt        ;᫥�. ᫠������
fcompp            ;㡨ࠥ� 2 �᫠
fld    four       ;ST = 4.0
fmul              ;sum = sum*4.0
fld    dstep      ;������� 蠣
fldz              ;sum = 0.0
fld    X0         ;
fld    dstep      ;
fadd              ;����㦠�� x0 + 2.0*H
mov ecx, NN
dec ecx       ;�᫮ ᫠������ �� 1 �����
fld ST        ;�㡫��㥬 x0 + dstep
nxt1:  invoke Fun ;����塞 �㭪��
faddp  ST(2), ST  ;sum = sum + Fun(x) � pop
fadd   ST,ST(2)   ;x = x + dstep
fld    ST         ;�㡫��㥬 x + dstep
loop   nxt1       ;����� ᫠������
fcompp            ;㡨ࠥ� ��� ���祭��
fld    two        ;ST = 2.0
fmul              ;sum = sum * 2
fadd   ST, ST(2)  ;+�।���� �㬬�
fld    X0
invoke Fun        ;fun(x0)
fadd              ;�ਡ���� fun(x0)
fld    X2N        ;
invoke Fun        ;
fadd              ;�ਡ���� fun(x2n)
fld    H          ;
fmul              ;sum = sum * h
fld    three      ;
fdivp  ST(1),ST   ;(h/3) * sum
mov    eax, SUMADDR
fstp   TBYTE PTR [eax];��࠭塞 ��⥣ࠫ
finit             ;��頥� ᮯ�����
ret
Simpson endp
end
