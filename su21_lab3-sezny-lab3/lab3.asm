# Sezny Watkins
# Take in a first number, a second number, and the total numbers of the sequence
# Then, starting with the third number, each number in the sequence is computed by adding the previous two
# For each number in the sequence, print the int in decimal form, hexadecimal form, and then print the number of ones in binary form



.data

msg1:	.asciiz "Please enter the first number in the sequence: "
msg2: .asciiz "Please enter the second number in the sequence: "
msg3: .asciiz "Please enter the total number of elements in the sequence: "
tab: .asciiz "     "
line: .asciiz "\n"

	.text 
main:	

	la	$a0, msg1		#Set up my message as an argument
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call

	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				
	add $s0, $v0, $zero		#move number that was just entered into register $s0
					#so $s0 has the first number in the sequence
	
	la	$a0, msg2		#set up the second message
	addi	$v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5		#read in from the command line again
	syscall
	add $s1, $v0, $zero		#save the second number in the sequence as $s1
	
	la	$a0, msg3		#set up the third message
	addi	$v0, $zero, 4
	syscall	
	
	addi $v0, $zero, 5		#read in from the command line again
	syscall
	add $s2, $v0, $zero		#save the length of the sequence in $s2
	
	
	
	Loop: 
	slt $t0, $zero, $s2		#if $s2 (which will countdown from the length of the sequence) is less than 0, loop
	beq $t0, $zero, Exit		#otherwise, exit the loop
	
	add $a0, $s0, $zero		#set up to print the integer
	addi $v0, $zero, 1
	syscall
	
	la $a0, tab			#set up to print some spaces
	addi $v0, $zero, 4
	syscall
	
	add $a0, $s0, $zero		#set up to print the int in hex
	addi $v0, $zero, 34
	syscall
	
	la $a0, tab			#set up to print some spaces again
	addi $v0, $zero, 4
	syscall
	
	add $a0, $s0, $zero		#set up to call the function to count the ones in the int
	jal Ones			
	
	add $a0, $v0, $zero		#set up to print the number of ones
	addi $v0, $zero, 1 
	syscall
	
	la $a0, line			#set up to print a new line
	addi $v0, $zero, 4
	syscall
	
	add $t2, $s0, $s1		#update the numbers
	add $s0, $s1, $zero
	add $s1, $t2, $zero
	addi $s2, $s2, -1
	
	j Loop				#go back to start of loop
	
	Exit:
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall				#make the system call
	
	
	
	Ones: 
	add $t0, $zero, $a0		#store the int in $t0 to be modified
	add $v0, $zero, $zero		#set $v0 to 0, this will be used to count the number of 1's
	add $t1, $zero, $zero		#set $t1 to be 0, this will be used to count the bits we've gone through
	
	addi $sp, $sp, -4		#spill the register
	sw $ra, 0($sp)
	
	Loop2: 
	slti $t2, $t1, 32		#while our counter is less than 32, we're going to loop
	beq $t2, $zero, Return		#otherwise, exit the function
	
	andi $t3, $t0, 1		#get the rightmost bit. will be 0 if it's a 0, 1 otherwise
	beq $t3, $zero, Done		#check if it's 1
	addi $v0, $v0, 1		#if so, increment $v0
	
	Done:
	srl $t0, $t0, 1			#shift right by 1 so we can look at the next bit
	addi $t1, $t1, 1		#increment our counter, $t1
	j Loop2				#restart the loop
	
	
	Return:
	lw $ra, 0($sp)			#fill the register from stack
	addi $sp, $sp, 4
	
	jr $ra				#return to the main function
	
	
	
	
