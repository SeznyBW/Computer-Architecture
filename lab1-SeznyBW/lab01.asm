.data

arr:	.space 16			#This is 16 bytes, or 4 words
messg1:	.asciiz "Please enter a number "
colon:  .asciiz ": "
endline:.asciiz "\n" 

	.text 
main:	

	la	$a0, messg1		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call

	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				
	add $t0, $v0, $zero		#move number that was just entered into register $t0
	
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall				#make the system call
