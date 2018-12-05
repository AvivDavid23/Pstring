	.section	.rodata
	 input_error:  .string "invalid input!\n" # for wrong input
	
	.text
.global pstrln
.global replaceChar
.global pstrijcpy
.global swapCase
.global pstrijcmp

pstrln:
	pushq	%rbp
	movq	%rsp, %rbp
	movb 	(%rdi), %al	# return val
	leave
	ret
	
replaceChar:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax 	# saving pointer to string
	movzbl	(%rdi), %r8d	# r8d will have the size of the string
	movl	$0, %ecx 	# ecx will be a 'counter'
	inc	%rdi		# pointer inc
	dec	%r8d
	.WHILE:
	  cmpb	%sil, (%rdi) 	# check if char == oldChar
	  je  .TRUE 		# if equal, jmp to true
	  jmp .FALSE
	 .TRUE:
	   movb	%dl, (%rdi) 	# replace to newChar
	 .FALSE:
	   inc	%rdi
	   inc	%ecx
	   cmpl	%r8d, %ecx
	   jle .WHILE
	leave
	ret
	
pstrijcpy:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	movq	%rdi, %r15 	# saving pointer to string
	movb	(%rdi), %r8b 	# saving dst length
	movb	(%rsi), %r9b 	# saving src length
	dec		%r8b
	dec		%r9b
	# INPUT CHECK:
	cmpb	$0, %dl	# i < 0
	jl .ERR
	cmpb	$0, %cl	# j < 0
	jl .ERR
	cmpb	%r8b, %dl # i > n1
	ja .ERR
	cmpb	%r8b, %cl # j > n1
	ja .ERR
	cmpb	%r9b, %dl # i > n2
	ja .ERR
	cmpb	%r9b, %cl # j > n2
	ja .ERR
	jmp .SEC
	.ERR:
	  movq 	$input_error, %rdi
	  movq	$0, %rax
	  call printf
		movq	%r15, %rax
		popq	%r15
	  leave
	  ret
	.SEC:
	  inc	%rdi		# skip length byte
	  inc	%rsi		# skip length byte
	  movb	$0, %r10b 	# 'counter'
	  cmpb	%dl, %r10b
	  jl  .WHILE1
	  jmp .WHILE2
	 .WHILE1: # increase counter until counter == i
	   inc	%r10b
	   inc	%rdi
	   inc	%rsi
	   cmpb	%dl, %r10b
	   jl .WHILE1
	 # now counter = i
	 .WHILE2: # switch until counter > j
	   movb	(%rsi), %r11b
	   movb	%r11b, (%rdi)
	   inc	%r10b
	   inc	%rdi
	   inc	%rsi
	   cmpb	%cl, %r10b
	   jle .WHILE2
	 movq	 %r15, %rax
	 popq	 %r15
	 leave
	 ret
	 
swapCase:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %rax	# saving pointer to string
	movzbl	(%rdi), %r8d 	# length
	dec	%r8d
	inc	%rdi
	movl	$0, %r9d 	# 'counter'
	.while:	# while counter <= length -1
	  # checking if char is a letter, by ASCII value
	  cmpb	$122, (%rdi)
	  ja .pass
	  cmpb	$65, (%rdi)
	  jl .pass
	  cmpb	$91, (%rdi)
	  jl .capital
	  cmpb	$96, (%rdi)
	  ja .small
	  .capital: # capital, add 32
	    addb    $32, (%rdi)
	    jmp .pass
	  .small:   # small, dec 32
	    subb    $32, (%rdi)
	  .pass:
	    inc	    %r9d
	    inc	    %rdi
	    cmpl    %r8d, %r9d
	    jle .while
	leave
	ret

pstrijcmp:
	pushq	%rbp
	movq	%rsp, %rbp
	movb	(%rdi), %r8b 	# saving dst length
	movb	(%rsi), %r9b 	# saving src length
	dec	%r8b
	dec	%r9b
	#INPUT CHECK:
	cmpb	$0, %dl	# i < 0
	jl .ERROR
	cmpb	$0, %cl	# j < 0
	jl .ERROR
	cmpb	%r8b, %dl # i > n1
	ja .ERROR
	cmpb	%r8b, %dl # j > n1
	ja .ERROR
	cmpb	%r9b, %dl # i > n2
	ja .ERROR
	cmpb	%r9b, %cl # j > n2
	ja .ERROR
	jmp .SECS
	.ERROR:
	  movq 	$input_error, %rdi
	  movq	$0, %rax
	  call   printf
	  movl	$-2, %eax
	  leave
	  ret
	.SECS:
	  inc	%rdi		# skip length byte
	  inc	%rsi		# skip length byte
	  movb	$0, %r10b 	# 'counter'
	  cmpb	%dl, %r10b
	  jl .WHILEA
	  jmp .WHILEB
	 .WHILEA: # increase counter until counter == i
	   inc	%r10b
	   inc	%rdi
	   inc	%rsi
	   cmpb	%dl, %r10b
	   jl .WHILEA
	 # now counter = i
	 .WHILEB:	# check until counter > j or need to return 1/-1
	   movb	(%rsi), %r11b
	   cmpb	%r11b, (%rdi)
	   jl .SMALLER
	   ja .Bigger
	   jmp .PASS
	   .SMALLER:
	     movl    $-1, %eax
	     jmp .DONE
	   .Bigger:
	     movl    $1, %eax
	     jmp .DONE
	   .PASS: 
	     inc    %r10b
	     inc    %rdi
	     inc    %rsi
	     cmpb   %cl, %r10b
	     jle .WHILEB
	     movl   $0, %eax
	  .DONE:
	    leave
	    ret
