; А.Крупник "Изучаем Ассемблер"
	.386p
	ifdef ??version
	if    ??version GT 500H
	.mmx
	endif
	endif
	model flat
	ifndef	??version
	?debug	macro
	endm
	endif
	?debug	S "xchg.c"
	?debug	T "xchg.c"
_TEXT	segment dword public use32 'CODE'
_TEXT	ends
_DATA	segment dword public use32 'DATA'
_DATA	ends
_BSS	segment dword public use32 'BSS'
_BSS	ends
DGROUP	group	_BSS,_DATA
_TEXT	segment dword public use32 'CODE'
_xchg	proc	near
?live1@0:
   ;	
   ;	void xchg(int *a,int *b){
   ;	
	push      ebp
	mov       ebp,esp
	push      ebx
	mov       edx,dword ptr [ebp+12]
	mov       eax,dword ptr [ebp+8]
   ;	
   ;	int tmp;
   ;	tmp=*a;
   ;	
?live1@16: ; EAX = a, EDX = b
@1:
	mov       ecx,dword ptr [eax]
   ;	
   ;	*a=*b;
   ;	
?live1@32: ; EAX = a, EDX = b, ECX = tmp
	mov       ebx,dword ptr [edx]
	mov       dword ptr [eax],ebx
   ;	
   ;	*b=tmp;
   ;	
?live1@48: ; EDX = b, ECX = tmp
	mov       dword ptr [edx],ecx
   ;	
   ;	}
   ;	
?live1@64: ; 
@2:
	pop       ebx
	pop       ebp
	ret 
_xchg	endp
_TEXT	ends
	public	_xchg
	?debug	D "xchg.c" 12017 25409
	end
