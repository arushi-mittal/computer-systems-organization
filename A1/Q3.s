.global _start

.text 

_start:
	mov $10, %r8		#set a = 10 by moving it to %r8   	   
	mov $5, %r9         #set b = 5 by moving it to %r9
	mov $7, %r10  		#set n = 7 by moving it to %r10	
	mov $1, %r11	    #mov 1 to the accumulator
						#lines 11-14 for a = a mod n
	mov %r8, %rax      	#move a to %rax to perform modulo operation
	mov $0, %rdx        #move 0 to %rdx 
	idiv %r10			#divide %rax by n
	mov %rdx, %r8		#remainder of previous operation is stored in %rdx, store in a

loop:					#while loop
	cmp $0, %r9			#check b > 0
	jle exit			
						#lines 20-23 check if b is odd
	mov %r9, %rcx		#store b in %rcx for the next operation
	and $1, %rcx		#change %rcx to LSB of b
	cmp $0, %rcx		#if LSB is zero, b is even, else b is odd
	je loop2			#if the condition is true, b is even, and can jump to the next step.
	mov %r11, %rax		#store accumulator in %rax to perform multiplication 
	imul %r8			#multiply accumulator by a 
	idiv %r10			#divide accumulator by n to get modulo in %rdx
	mov %rdx, %r11		#store (accumulator*a)mod n in accumulator
	
loop2:					#conditonal jump if b is even; reach sequentially if not.
	sar $1, %r9			#halve b
	mov %r8, %rax		#move a to %rax to perform multiplication and modulo
	imul %rax			#multiply a by itself and store in %rax
	idiv %r10			#divide %rax to get modulo in %rdx
	mov %rdx, %r8		#store (a * a)mod n in a
	jmp loop 			#go back tp while loop


exit:					#exit program
	mov $60, %rax
	xor %rdi, %rdi
	syscall
