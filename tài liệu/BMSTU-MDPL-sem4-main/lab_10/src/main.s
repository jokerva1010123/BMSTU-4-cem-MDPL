	.file	"main.c"
	.text
	.section	.rodata
.LC0:
	.string	"%lf\n"
	.text
	.globl	dot_prod_vector_arrays
	.type	dot_prod_vector_arrays, @function
dot_prod_vector_arrays:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	%ecx, -44(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movq	-24(%rbp), %rax
	vmovsd	(%rax), %xmm1
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm2
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	vmovsd	(%rax), %xmm0
	vmulsd	%xmm0, %xmm2, %xmm0
	vaddsd	%xmm0, %xmm1, %xmm0
	movq	-24(%rbp), %rax
	vmovsd	%xmm0, (%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	vmovq	%rax, %xmm0
	leaq	.LC0(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L3
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	dot_prod_vector_arrays, .-dot_prod_vector_arrays
	.section	.rodata
.LC8:
	.string	"\n\nScalar (res = %lf) C: %ld\n\n"
	.align 8
.LC9:
	.string	"\n\nScalar (res = %lf) ASM: %ld\n\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movl	%edi, -148(%rbp)
	movq	%rsi, -160(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	fldt	.LC1(%rip)
	fstpt	-112(%rbp)
	fldt	.LC2(%rip)
	fstpt	-96(%rbp)
	fldt	.LC3(%rip)
	fstpt	-80(%rbp)
	fldt	.LC4(%rip)
	fstpt	-64(%rbp)
	fldt	.LC5(%rip)
	fstpt	-48(%rbp)
	fldt	.LC6(%rip)
	fstpt	-32(%rbp)
	vxorpd	%xmm0, %xmm0, %xmm0
	vmovsd	%xmm0, -120(%rbp)
	call	clock@PLT
	movl	%eax, -128(%rbp)
	movl	$0, -132(%rbp)
	jmp	.L5
.L6:
	leaq	-64(%rbp), %rdx
	leaq	-112(%rbp), %rsi
	leaq	-120(%rbp), %rax
	movl	$3, %ecx
	movq	%rax, %rdi
	call	dot_prod_vector_arrays
	addl	$1, -132(%rbp)
.L5:
	cmpl	$0, -132(%rbp)
	jle	.L6
	call	clock@PLT
	movl	%eax, -124(%rbp)
	movl	-124(%rbp), %eax
	subl	-128(%rbp), %eax
	movl	%eax, %edx
	movq	-120(%rbp), %rax
	movl	%edx, %esi
	vmovq	%rax, %xmm0
	leaq	.LC8(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	movl	-124(%rbp), %eax
	subl	-128(%rbp), %eax
	movl	%eax, %edx
	movq	-120(%rbp), %rax
	movl	%edx, %esi
	vmovq	%rax, %xmm0
	leaq	.LC9(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L8
	call	__stack_chk_fail@PLT
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.section	.rodata
	.align 16
.LC1:
	.long	3435974656
	.long	2362232012
	.long	16383
	.long	0
	.align 16
.LC2:
	.long	3435974656
	.long	2362232012
	.long	16384
	.long	0
	.align 16
.LC3:
	.long	858992640
	.long	3543348019
	.long	16384
	.long	0
	.align 16
.LC4:
	.long	3435974656
	.long	2362232012
	.long	16385
	.long	0
	.align 16
.LC5:
	.long	0
	.long	2952790016
	.long	16385
	.long	0
	.align 16
.LC6:
	.long	858992640
	.long	3543348019
	.long	16385
	.long	0
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
