.global _start

_start:
	mov $27, %r8	#move the value of x to %r8
	mov $1, %r10	#store factorial in %r10
	mov $1, %r11	#store i in %r11

cmp $0, %r8			#check if x is 0
je zero				#jump to zero condition to prevent zero division error
	
loop:					
	mov %r10, %rax	#move %r10 to %rax for multiplication operation
	mov $0, %rdx	#move 0 to %rdx to prevent error
	divq %r8		#divide by x to get remainder in %rdx
	cmp $0, %rdx	#check if remainder is 0 
	je exit			#if remainder is 0, the factorial is divisible, jump to exit
	inc %r11		#increment i
	mov %r10, %rax	#move factorial to %rax for multiplication operation.
	mul %r11		#multiply factorial by i to get factorial of i
	mov %rax, %r10	#store new factorial in factorial
	jmp loop		#return to loop to check divisibility


zero:				#zero condition 
	mov $0, %r11	#if x is 0, return 0
	jmp exit		#unconditional jump to exit

exit:				#exit program
	mov $60, %rax	
	xor %rdi, %rdi	
	syscall
