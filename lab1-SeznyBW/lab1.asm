#Sezny Watkins
# Takes in a number and stores it in an array at a given index
#Then prints the array


.data

arr:	.space 16			#This is 16 bytes, or 4 words
messg1:	.asciiz "Please enter a number "
colon:  .asciiz ": "
endline:.asciiz "\n" 
messg2: .asciiz "Which element of the array would you like this to be? "

	.text 
main:	

	la	$a0, messg1		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call

	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				
	add $t0, $v0, $zero		#move number that was just entered into register $t0
	
	#print the second message
	addi $v0, $zero, 4
	la $a0, messg2
	syscall
	
	#and read in the int again
	addi $v0, $zero, 5
	syscall
	add $t1, $zero, $v0 	#store the element of the array in $t1
	
	#save it into the array
	la $t2, arr 		#$t2 is the array address
	mul $t3, $t1, 4		#4* the index = number to add to the starting address to get address in memory
	add $t4, $t3, $t2	#store the address
	sw $t0, 0($t4)
	
	#print the array
	addi $v0, $zero, 1
	addi $a0, $zero, 0
	syscall
	addi $v0, $zero, 4
	la $a0, colon 
	syscall
	addi $v0, $zero, 1
	lw $a0, 0($t2)
	syscall
	addi $v0, $zero, 4
	la $a0, endline
	syscall
	addi $v0, $zero, 1
	addi $a0, $zero, 1
	syscall
	addi $v0, $zero, 4
	la $a0, colon
	syscall
	addi $v0, $zero, 1
	lw $a0, 4($t2)
	syscall
	addi $v0, $zero, 4
	la $a0, endline
	syscall
	addi $v0, $zero, 1
	addi $a0, $zero, 2
	syscall
	addi $v0, $zero, 4
	la $a0, colon
	syscall
	addi $v0, $zero, 1
	lw $a0, 8($t2)
	syscall
	addi $v0, $zero, 4
	la $a0, endline
	syscall
	addi $v0, $zero, 1
	addi $a0, $zero, 3
	syscall
	addi $v0, $zero, 4
	la $a0, colon
	syscall
	addi $v0, $zero, 1
	lw $a0, 12($t2)
	syscall
	addi $v0, $zero, 4
	la $a0, endline
	syscall
	
	
	
	
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall				#make the system call







