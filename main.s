	.section	.rodata
	d:		.string "%d"
	s:		.string "%s"
	.text
	
.global main

main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%r13
	subq	$4, %rsp
	movq	%rsp, %rsi
	movq	$d, %rdi
	movq	$0, %rax
	call 	scanf			# scan first int
	movslq	(%rsp), %rsi	# get number
	movb	(%rsp), %r12b	# first byte of length
	dec		%rsp			# for \0
	movb	$0, (%rsp)		# put \0
	subq	%rsi, %rsp	# add n bytes
	movq	$s, %rdi
	movq	%rsp, %rsi
	movq	$0, %rax
	call	scanf			# scan first string
	dec		%rsp
	movb	%r12b, (%rsp)	# put length
	movq	%rsp, %r12		# points to first pstring

	subq	$4, %rsp
	movq	%rsp, %rsi
	movq	$d, %rdi
	movq	$0, %rax
	call 	scanf			# scan second int
	movslq	(%rsp), %rsi	# get number
	movb	(%rsp), %r13b	# first byte of length
	dec		%rsp			# for \0
	movb	$0, (%rsp)		# put \0
	subq	%rsi, %rsp	# add n bytes
	movq	$s, %rdi
	movq	%rsp, %rsi
	movq	$0, %rax
	call	scanf			# scan second string
	dec		%rsp
	movb	%r13b, (%rsp)	# put length
	movq	%rsp, %r13		# points to second pstring

	subq	$4, %rsp
	movq	%rsp, %rsi
	movq	$d, %rdi
	movq	$0, %rax
	call 	scanf			# scan choice
	movl 	(%rsp), %edi
	movq	%r12, %rsi
	movq	%r13, %rdx
	call	run_func
	#	now restore r12 and r13
	movzbq	(%r13), %rdx
	addq	$2, %rsp
	addq	%rdx, %rsp

	movzbq	(%r12), %rdx
	addq	$2, %rsp
	addq	%rdx, %rsp

	popq	%r13
	popq	%r12
	leave
	ret
