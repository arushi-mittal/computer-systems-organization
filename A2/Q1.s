.global _start

_start:
	#mov  $50, %rbx   	  #Store A
	#mov   $8, %rcx	 	  #Store B
	mov   $1, %r8	 	  #Store iterator i
	mov   $0, %r9	 	  #Store maximum value
	mov   $0, %r10   	  #Store x
	mov  $10, %r15	 	  #For dividing by 10
	mov   $0, %r13	 	  #For storing the final sum

	cmp $0, %rbx     	  #If A is zero, return zero
	je zero			 
	cmp $0, %rcx	 	  #If B is zero, return zero
	je zero

loop1:
	cmp %rbx, %r8	 	  #Iterate through all values between 1 and A
	jg sum
	mov %rbx, %rax   	  #Check if A is divisible by i
	mov $0, %rdx
	idivq %r8		 
	cmp $0, %rdx	 	  #If A is not divisible, increment i
	jne notequal
	mov $0, %rdx	 	  #Store x in %r10
	mov %rbx, %rax
	idivq %r8
	mov %rax, %r10
	pushq %r10		 	  #Push x to stack to calculate gcd
	pushq %rcx		      #Push B to stack to calculate gcd
	call gcd		      #Calculate gcd of b and x

checkgcd:			 
	cmp $1, %r11	      #If gcd is 1, the numbers are co-prime
	jne notequal	      #If not co-prime, the number is invalid, move to the next number
	cmp %r9, %r10	      #If the current value of x is greater, store it in max to use later
	jle notequal		  
	mov %r10, %r9
	jmp notequal		  #Try for the next number

notequal:				  #Increment iterator
	inc %r8
	jmp loop1

gcd:					  #Compute gcd
	push %rbp			  #Push base pointer
	mov %rsp, %rbp		  #Move stack pointer to base pointer
	mov 16(%rbp), %r11    #Store B in %r11 
	mov 24(%rbp), %r12	  #Store x in %r12
	cmp $0, %r12		  #If x is 0, return B
	je equal				
	jne callgcd			  #Else, compute gcd(x, b % x)

callgcd:				  #Compute gcd if x is not zero
	mov %r11, %rax
	mov $0, %rdx
	idivq %r12
	pushq %rdx
	pushq %r12
	call gcd

equal:					  #Return
	mov %rbp, %rsp
	pop %rbp
	ret

sum:					  #Use maximum value to find sum of digits
	cmp $0, %r9
	je last				  #Keep dividing max by zero and add the remainder 
	mov $0, %rdx
	mov %r9, %rax
	idivq %r15
	addq %rdx, %r13
	mov %rax, %r9
	mov $0, %rax
	jmp sum

zero:					  #Return zero if either A or B is zero
	mov $0, %rdx
	jmp exit

last:					  #Store sum of digits in %rdx
	mov %r13, %rdx
	jmp exit

exit:
	mov $60, %rax	      #exit the program
	xor %rdi, %rdi
	syscall
