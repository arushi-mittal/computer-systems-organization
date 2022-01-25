.global _start

#Factorial function uses %r12 = x, %r13 = return value, %r14 = previous x
_start:
	#mov  $5, %rbx		#Store n
	#mov $13, %rcx		#Store k
	mov  $1, %r8		#Store first fibonacci number a
	mov  $2, %r9		#Store second fibonacci number b
	mov  $0, %r10		#Store sum of fibonacci numbers i
	mov  $0, %r11 		#Store current fibonacci number

	cmp  $0, %rbx		#If n is zero, jump to zero block
	je zero	
	cmp  $1, %rbx		#If n is one, jump to one block
	je one
	cmp  $2, %rbx		#If If n is two, jump to two block
	je two
	cmp  $1, %rcx		#If k is zero, jump to end block
	je mod
	cmp $0, %rcx
	je mod
	mov  $3, %r10		#If n is greater than 2, set sum = 3

loop1:					#Start main loop
	mov %r8, %r11		#Set i = a + b to compute next fibonacci number
	add %r9, %r11 		
	cmp %rbx, %r11		#Check if current fibonacci number is less than n
	jg exit
	mov %r9, %r8		#Set a = b to get next fibonacci number
	mov %r11, %r9		#Set b = i to get next fibonacci number
	push %r11			#Push current fibonacci number to calculate factorial
	call factorial
	mov %r10, %rax		#Add factorial of current number to sum
	mov $0, %rdx		#Clear %rdx before division
	idivq %rcx			#Get sum % k
	mov %rdx, %r10		
	add %r13, %r10
	mov %r10, %rax	
	mov $0, %rdx		#Clear %rdx before division	
	idivq %rcx
	mov %rdx, %r10			
	jmp loop1			#Jump to main loop to continue to next fibonacci number

factorial:				#Factorial function
	push %rbp			#Initialize stack
	mov %rsp, %rbp
	mov 16(%rbp), %r12  #Store the number in %r12 
	cmp $0, %r12		#Base case: if x == 0 return 1
	je equal
	dec %r12			#Decrement number and push
	push %r12			
	call factorial      #Calculate factorial of x - 1
	mov %r13, %rax		#Perform (x - 1)%k
	mov $0, %rdx	
	idivq %rcx
	mov %rdx, %r13
	mov 16(%rbp), %r14	#Access the value of x
	mov %r14, %rax
	mov $0, %rdx
	idivq %rcx
	mov %rdx, %r14		
	imulq %r14, %r13	#Multiply factorial(x - 1)%m * x%m
	mov %r13, %rax
	mov $0, %rdx		#Clear %rdx before division
	idivq %rcx		
	mov %rdx, %r13 		
	jmp return    		#Jump to return function 

equal:			
	mov $1, %r13		#Store return value in %r13
	jmp return

return:					#Return 
	mov %rbp, %rsp		#Deallocate the stack
	pop %rbp			
	ret 				#Return to function call

zero:					#If n = 0, return 1
	mov $1, %rdx
	jmp exit

one:					#If n = 1, return 1
	mov $1, %rdx 
	jmp exit

two:					#If n = 2, return 3
	mov $3, %rdx
	jmp exit

mod:					#If k = 1 or 0, return 0
	mov $0, %rdx
	jmp exit

exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall
