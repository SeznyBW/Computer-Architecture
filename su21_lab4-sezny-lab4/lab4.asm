#Sezny Watkins
#Reads in an int, then reads in that many coordinates
#Then sorts the coordinates by distance from the origin
#If points are equidistant then they're sorted lexicographically
#Then print the sorted list of coordinates
	
	.data

msgn:	.asciiz "Please enter the number of coordinates: "
msgx:	.asciiz "Please enter the x-coordinate: "
msgy:	.asciiz	"Please enter the y-coordinate: "
tab:	.asciiz "     "
line:	.asciiz	"\n"


	.text 
main:	

	la	$a0, msgn		#Set up my message as an argument - la is Load Address
	addi	$v0, $zero, 4		#Specify system call 4 to print
	syscall				#make the system call

	addi	$v0, $zero, 5		#set up syscall to read number in from command line
	syscall				
	add $s0, $v0, $zero		#move number that was just entered into register $s0
	
	
	add $a0, $s0, $s0		#set the number of bytes to be 4x the number of ints, so that it's the right number of words. this is the number of ints
	add $a0, $a0, $s0		#the right number of ints + the distance from origin for each
	add $a0, $a0, $a0		#two times the number of ints
	add $a0, $a0, $a0		#four times the number of ints
	addi $v0, $zero, 9		#set up the syscall for sbrk
	syscall
	add $s1, $v0, $zero		#save the memory address of the array in $s1
	
	add $t1, $zero, $zero		#set $t1 as a counter to make sure we read in the right number
	add $t2, $s1, $zero		#set $t2 to keep track of where we are in the array 
	
	reading:			#loop to read in the coordinates
	beq $t1, $s0, doner		#if we've read in the right number of coordinates, exit the loop
	
	la	$a0, msgx		#ask for the x coordinate
	addi	$v0, $zero, 4		
	syscall		
	addi	$v0, $zero, 5		#read in the x coordinate
	syscall	
	sw $v0, 0($t2)			#store the x-coordinate in the array
	addi $t2, $t2, 4		#increment the place in the array by one word
	
	la	$a0, msgy		#ask for the y coordinate
	addi	$v0, $zero, 4		
	syscall		
	addi	$v0, $zero, 5		#read in the y coordinate
	syscall	
	sw $v0, 0($t2)			#store the y-coordinate in the array
	addi $t2, $t2, 8		#increment the place in the array by two words
	addi $t1, $t1, 1		#increment the count of how many coordinates we've read in
	
	j reading			#start the loop over again
			
	doner:				#exiting the loop
	
	add $s2, $zero, $zero		#counter to go through the array
	add $s3, $s1, $zero		#keep track of where we are in the array
	
	sorting:
	beq $s2, $s0, breaks		#if we've gone through the whole array, exit the loop
	lw $a0, 0($s3)			#save x in $a0
	lw $a1, 4($s3)			#save y in $a1
	jal distance			#go to the function to calculate the distance
	sw $v0, 8($s3)			#store the distance in the array
	
	add $s4, $zero, $zero		#counter to go through the array to sort
	add $s5, $s1, $zero		#keeps track of where we are in the arry when sorting
	inners:
	
	beq $s2, $s4, breaki		#exit loop if $s2 and $s4 indicate the same index of the array
	lw $t4, 8($s5)			#get the value in the array, store it in t4
	slt $t5, $v0, $t4		#check if the value we just got is less than the one we calculated
	beq $t5, $zero, done1		#if so, this is where we insert it
	add $a0, $s2, $zero		#first argument is the index of the coordinates we're inserting
	add $a1, $s3, $zero		#second argument is the place in memory of the coordinates we're inserting
	add $a2, $s4, $zero		#third arg is the index we're inserting to
	add $a3, $s5, $zero		#fourth arg is the place in memory of where we're inserting
	jal insert			#if so, this is where we insert it, call the insert function
	addi $s2, $s2, 1		#increment the counter
	addi $s3, $s3, 12		#and the index
	j sorting			#and loop again

	done1:				
	bne $t4, $v0, done2		#otherwise, check if they're equal. if so, compare the x values
	lw $t4, 0($s3)			#the x value of the coordinate we're trying to insert
	lw $t5, 0($s5)
	slt $t6, $t4, $t5		#see if the value we're inserting is less than the one we're comparing to
	beq $t6, $zero, done3
	add $a0, $s2, $zero		#first argument is the index of the coordinates we're inserting
	add $a1, $s3, $zero		#second argument is the place in memory of the coordinates we're inserting
	add $a2, $s4, $zero		#third arg is the index we're inserting to
	add $a3, $s5, $zero		#fourth arg is the place in memory of where we're inserting
	jal insert			#if so, this is where we insert it, call the insert function	jal insert			#if so, this is where we insert it, call the insert function
	addi $s2, $s2, 1		#increment the counter
	addi $s3, $s3, 12		#and the index
	j sorting			#and loop again

	done3:	
	bne $t4, $t5, done2		#if not, check if the x values are equal
	lw $t4, 4($s3)			#get the y value of the coordinate we're inserting
	lw $t5, 4($s5)			#and the y value of the coordinate we're comparing to
	slt $t6, $t4, $t5		#see if the y value of the coordinate we're inserting is smaller
	beq $t6, $zero, done2		
	add $a0, $s2, $zero		#first argument is the index of the coordinates we're inserting
	add $a1, $s3, $zero		#second argument is the place in memory of the coordinates we're inserting
	add $a2, $s4, $zero		#third arg is the index we're inserting to
	add $a3, $s5, $zero		#fourth arg is the place in memory of where we're inserting
	jal insert			#if so, this is where we insert it, call the insert functionjal insert			#if so, this is where we insert
	addi $s2, $s2, 1		#increment the counter
	addi $s3, $s3, 12		#and the index
	j sorting			#and loop again

	done2:
	addi $s4, $s4, 1		#otherwise, we compare to the next value. so increment the counter
	addi $s5, $s5, 12		#and the place in memory
	j inners			#and loop again		
	
	breaki:
	addi $s2, $s2, 1		#increment the counter
	addi $s3, $s3, 12		#and the index
	j sorting			#and loop again
	
	breaks:
	
	
	add $t1, $zero, $zero		#set $t1 as a counter to make sure we read in the right number
	add $t2, $s1, $zero		#set $t2 to keep track of where we are in the array 

	printing:			#loop to print out all the coordinates
	
	beq $t1, $s0, donep		#if we've printed the right number of coordinates, exit the loop
	
	lw $a0, 0($t2)			#load the x-coordinate
	addi $v0, $zero, 1		#print the x-coordinate
	syscall
	addi $t2, $t2, 4		#increment the address in memory by one word
	
	la	$a0, tab		#Print a tab
	addi	$v0, $zero, 4		
	syscall				

	
	lw $a0, 0($t2)			#load the y-coordinate
	addi $v0, $zero, 1		#print the y-coordinate
	syscall
	addi $t2, $t2, 8		#increment the address in memory by two words
	
	la	$a0, line		#print a new line
	addi	$v0, $zero, 4		
	syscall				
	
	addi $t1, $t1, 1		#increment the counter since we've read in a coordinate
	
	j printing			#start the loop over again


	donep:				#exiting the loop
	
	
	addi	$v0, $zero, 10		#Specify system call 10 to exit
	syscall				#make the system call
	
	
	distance:			#function to find x^2+y^2
	
	addi $sp, $sp, -4		#spill the register
	sw $ra, 0($sp)
	
	slt $t0, $a0, $zero		#test if x is negative
	beq $t0, $zero, xneg
	sub $a0, $zero, $a0		#if so, negate it
	
	xneg:
	
	slt $t0, $a1, $zero		#test if y is negative
	beq $t0, $zero, yneg
	sub $a1, $zero, $a1		#if so, negate it
	
	yneg:
	
	add $t0, $zero, $zero		#count how many times we add x
	add $t1, $zero, $zero 		#summing x until we get x^2				
	
	x:
	beq $t0, $a0, breakx		#if we've added x x times
	add $t1, $t1, $a0		#add x to our sum
	addi $t0, $t0, 1		#increment our counter
	j x				#start the loop over again
	
	breakx:
	
	add $t0, $zero, $zero		#count how many times we add y
	add $t2, $zero, $zero 		#summing x until we get y^2
	
	y:
	beq $t0, $a1, breaky		#if we've added y y times
	add $t2, $t2, $a1		#add y to our sum
	addi $t0, $t0, 1		#increment our counter
	j y				#start the loop over again
	
	breaky:
	
	add $v0, $t1, $t2		#add x^2 and y^2 to the return register
	
	lw $ra, 0($sp)			#fill the register from stack
	addi $sp, $sp, 4
	
	jr $ra
	
	
	
	
	insert:				#function to help sort the array, inserting a set of coordinates where it belongs
	
	addi $sp, $sp, -4		#spill the register
	sw $ra, 0($sp)
	
	beq $a0, $a2, breakm		#if we're inserting into the last spot, we don't have to do anything
	addi $t0, $a2, -1		#counter to keep track of where we are, starting with where we're inserting
	add $t1, $a3, $zero		#where in memory we are
	lw $t3, 0($a1)			#get the x coordinate we're inserting
	lw $t4, 4($a1)			#get the y coordinate
	lw $t5, 8($a1)			#get the distance
	
	moving:
	
	beq $t0, $a0, breakm		#if the counter is at the coordinate we inserted, we're done
	lw $t6, 0($t1)			#get the x value we're replacing
	sw $t3, 0($t1)			#save the new x value
	add $t3, $t6, $zero		#put the x value we're replacing in the register to be the new one next time
	lw $t6, 4($t1)			#do the same for the y value
	sw $t4, 4($t1)
	add $t4, $t6, $zero		
	lw $t6, 8($t1)			#and the distance value
	sw $t5, 8($t1)
	add $t5, $t6, $zero
	addi $t0, $t0, 1		#incrememnt our counter
	addi $t1, $t1, 12		#increment our index
	j moving
	
	breakm:
	
	lw $ra, 0($sp)			#fill the register from stack
	addi $sp, $sp, 4
	
	jr $ra
	
