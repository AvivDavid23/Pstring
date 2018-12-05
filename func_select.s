	.section .rodata
	input_err:  		.string "invalid option!\n" # for wrong input
	func_50:		.string "first pstring length: %d, second pstring length: %d\n"
	func_51:		.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
	f51_sc:     		.string "%c %c"
	dummy:			.string	"%c"
	func_52:		.string "length: %d, string: %s\n"
	f52_sc:			.string "%d"
	func_53:		.string "length: %d, string: %s\n"
	func_54:		.string "compare result: %d\n"
	f54_sc:			.string "%d"

	.align 8
   .SWITCH:	# jump table
   	.quad .L50
	.quad .L51
	.quad .L52
	.quad .L53
	.quad .L54
	.text 
.globl	run_func
run_func:
	pushq	%rbp
	movq	%rsp, %rbp
	leal	-50(%edi), %ecx
	cmpl 	$4, %ecx
	ja .ERR
	jmp *.SWITCH(,%ecx,8)
	.L50:
	  pushq		%r12
	  pushq		%r13
	  pushq		%rdx
	  movq		%rsi, %rdi 
	  call  	pstrln 
	  movzbl	%al, %r12d	# first length
	  popq	   	 %rdi
	  call 		pstrln 
	  movzbl   	 %al, %r13d	# second length
	  movq		$func_50, %rdi
	  movl		%r12d, %esi
	  movl		%r13d, %edx
	  movq		$0, %rax
	  call 		printf
	  popq		%r13
	  popq		%r12
	  jmp .DONE
	 
	.L51:
		pushq	%r12
		pushq	%r13
		movq	%rsi, %r12
		movq	%rdx, %r13
		subq	$1, %rsp
		leaq	(%rsp), %rsi
		movq	$dummy, %rdi
		movq	$0, %rax
		call	scanf		# first scan new lone from previous scan

		subq	$2, %rsp
		leaq	1(%rsp), %rsi
		leaq	(%rsp), %rdx
		movq	$f51_sc, %rdi
		movq	$0, %rax
		call	scanf		# scan 2 chars

		movq	%r12, %rdi
		movb	1(%rsp), %sil
		movb	(%rsp), %dl
		call 	replaceChar
		movq	%rax, %r12

		movq	%r13, %rdi
		movb	1(%rsp), %sil
		movb	(%rsp), %dl
		call 	replaceChar
		movq	%rax, %r13

		movb	1(%rsp), %sil
		movb	(%rsp), %dl
		movq	%r12, %rcx
		inc	%rcx		# skip length byte
		movq	%r13, %r8
		inc	%r8		# skip length byte
		movq	$0, %rax
		movq	$func_51, %rdi
		call	printf
		addq	$3, %rsp
		popq	%r13
		popq	%r12
	  jmp .DONE
	 
	.L52:
		pushq	%rsi		# save first ptr
		pushq	%rdx		# save second ptr
	  	subq	$8, %rsp
		leaq	4(%rsp), %rsi
		movq	$f52_sc, %rdi
		movq	$0, %rax
		call 	scanf		# scan first int
		leaq	(%rsp), %rsi
		movq	$f52_sc, %rdi
		movq	$0, %rax
		call 	scanf		# scan second int
		movb	4(%rsp), %dl
		movb	(%rsp), %cl
		movq	8(%rsp), %rsi	# second ptr
		movq	16(%rsp),%rdi	# first ptr
		call 	pstrijcpy
		movq	%rax, %rdx
		inc	%rdx		# skip length byte
		movzbl	(%rax), %esi	# get length
		movq	$func_52, %rdi
		movq	$0, %rax
		call	printf
		movq	8(%rsp), %rax	# rax will have second str ptr
		movzbl	(%rax), %esi	# get length
		movq	%rax, %rdx
		inc	%rdx		# skip length byte
		movq	$func_52, %rdi
		movq	$0, %rax
		call	printf
		jmp .DONE			
	 
	.L53:
		pushq	%r12
		pushq	%r13
		pushq	%r14
		pushq	%r15
		movq	%rsi, %r12	# temp for first pointer
		movq	%rdx, %r13      # temp for second pointer
		movq	%rsi, %rdi
		call	swapCase

		pushq	%rax # save first pointer
		movq	%r12, %rdi
		call	pstrln
		movzbl	%al, %r14d	# save first length
		movq	%r13, %rdi
		call	swapCase

		pushq	%rax 		# save second pointer
		movq	%r13, %rdi
		call	pstrln
		movzbl	%al, %r15d	# save second length

		popq	%r13		# second pointer
		inc	%r13		# skip length byte
		movl  	%r14d, %esi 	# first length
		popq	%rdx		# first pointer
		inc	%rdx  		# skip length byte
		movq	$0, %rax
		movq	$func_53, %rdi
		call 	printf

		movq	$0, %rax
		movq	$func_53, %rdi
		movl	%r15d, %esi
		movq	%r13, %rdx
		call 	printf

		popq	%r15
		popq	%r14
		popq	%r13
		popq	%r12
	  	jmp .DONE
	 
	.L54:
		pushq	%rsi		# save first ptr
		pushq	%rdx		# save second ptr
		subq	$8, %rsp
		leaq	4(%rsp), %rsi
		movq	$f54_sc, %rdi
		movq	$0, %rax
		call 	scanf		# scan first int
		leaq	(%rsp), %rsi
		movq	$f54_sc, %rdi
		movq	$0, %rax
		call 	scanf		# scan second int
		movb	4(%rsp), %dl
		movb	(%rsp), %cl
		movq	8(%rsp), %rsi
		movq	16(%rsp),%rdi
		call 	pstrijcmp
		movl	%eax, %esi
		movq	$func_54, %rdi
		movq	$0, %rax
		call	printf
		jmp .DONE
	 
	.ERR:	 # printing error
	  movq	 $input_err, %rdi
	  movq 	 $0, %rax
	  call 	 printf
	  jmp 	 .DONE
	 
	.DONE:
	  leave	
	  ret			
	
	
	
	
