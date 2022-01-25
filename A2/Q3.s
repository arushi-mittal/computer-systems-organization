.global _start

_start:
	#movq  $6, %rbx				#Store n	
	movq  $0, %r8				#Store iterator i
	movq  $0, %r9				#Store stack size


	movq $-1,   (%rdi)			#Store -1 in answer array
	movq $-1,  8(%rdi)
	movq $-1, 16(%rdi)
	movq $-1, 24(%rdi)
	movq $-1, 32(%rdi)
	movq $-1, 40(%rdi)


	#movq $4,   (%rcx)	    	#Store values in memory by incrementing by 8
	#movq $4,  8(%rcx)		
	#movq $5, 16(%rcx)
	#movq $2, 24(%rcx)
	#movq $10,32(%rcx)
	#movq $8, 40(%rcx)

loop1:
	cmp %r8, %rbx				#If iterator > array size, exit
	jle shift
	movq (%rcx, %r8, 8), %r11	#Else, store current array element in %r11

while:
	cmp $0, %r9					#If stack is empty jump to if 
	je if 						
	movq (%rsp), %r12			#Else get stack.top() in %r12
	cmp %r11, %r12				#If stack.top() >= arr[i], pop element
	jl if 						#Else, jump to if
	popq %rax					
	decq %r9					#Decrease stack size with each pop
	jmp while					#Continue popping until stack is empty or a lesser element is found

if:								
	cmp $0, %r9					#If stack is not empty, stack.top() is nearest smallest element
	je insert					#If stack is empty, push element and move to next element
	movq (%rsp), %r12			#Move stack.top() into answer i
	movq %r12, (%rdi, %r8, 8)	

insert:							#Push current element into stack
	pushq %r11
	incq %r9					#Increment iterator
	incq %r8					#Increment stack size
	jmp loop1					#Repeat

shift:
	movq %rdi, %rdx				#Store the answer array base pointer in %rdx
	
exit:							#Exit program
	movq $60, %rax
	xorq %rdi, %rdi
	syscall
