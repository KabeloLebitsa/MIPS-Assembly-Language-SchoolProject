# -------------------------------------------------------------------------------------------------------------------------
#  Author        : Kabelo Lebitsa
#  Date          : October 25,2022 ,2300hrs
#  Email         : kaybeelebitsa23@gmail.com
#  WhatsApp/Call : +266 50689364
#  Purpose       : Print first 10 reversible prime squares
# -------------------------------------------------------------------------------------------------------------------------



# Data Declarations
.data
	welcome_msg:   .asciiz "\n*************************************\n* First 10 reversible prime squares *\n*************************************\n\n" 
	new_line:      .asciiz "\n\n" 
	numbering_msg: .asciiz ".  "
	
.text
# -------------------------------------------------------------------------------------------------------------------------
#  Main procedure
# -------------------------------------------------------------------------------------------------------------------------
#
# I m p l e m e n t a t i o n
# -------------------------------------------------------------------------------------------------------------------------

.globl main
.ent   main
       main:
          jal print_reversible_prime_squares        # print numbers on the console  
.end   main

# End of main procedure implementation
#
# -------------------------------------------------------------------------------------------------------------------------


 
 
 
# -------------------------------------------------------------------------------------------------------------------------
# Procedure to return a reversed number
# -------------------------------------------------------------------------------------------------------------------------

#
# H i g h - L e v e l   M o d e l
#
# int reverse(int num)
# {
#    int remainder , reversed_num = 0;
    
#    while(num != 0)
#	{
#		remainder = num%10;
		
#     	reversed_num = reversed_num*10 + remainder;
     	
#     	num = num/10;
#	}
	
#	return reversed_num;	
# }
#
# L o w -  L e v e l   M o d e l 
#
# Aruguments
#      $a0  - num
# Return value
#      $v0  - reversed_num
#
# I m p l e m e n t a t i o n
# -------------------------------------------------------------------------------------------------------------------------

.globl reverse
.ent   reverse
       reverse:
       
       li  $v0,0                                    # reversed_num = 0  
       
             li  $t0,10                             # divisor and multiplyer
             reverse_loop:          
                  divu $a0,$t0                      # num/10
           
                  mflo $a0                          # take quotient to t3
                  mfhi $t1                          # take the remainder to t2
                    
                  mul  $v0,$v0,$t0                  # reversed_num = reversed_num*10
                  addu $v0,$v0,$t1                  # reversed_num = reversed_num + remainder
           
             bnez $a0,reverse_loop                  # while (num != 0), loop
            
       jr $ra                                       # return address to the caller
           
                                                    # used t0,t1..a0...and can be re-used after this procedure is called
         
.end   reverse

# End of reverse procedure implementation
#
# -------------------------------------------------------------------------------------------------------------------------





# -------------------------------------------------------------------------------------------------------------------------
# Procedure to check if a number is Prime or not Prime
# -------------------------------------------------------------------------------------------------------------------------

# H i g h - L e v e l   M o d e l
#
# int isPrime( int num)
# {
#	int i;
#	for(i = 2; i < num/2; i++)
#	{
#		if (num%i == 0)
#			return 0;
#	}
#	return 1;
# }
#
# L o w -  L e v e l   M o d e l 
#
# Arguments
#     $a0 - num
#
# Return values
#     $v0 - 1 (True) and null(0) if False
#
# I m p l e m e n t a t i o n
# -------------------------------------------------------------------------------------------------------------------------


.globl isPrime
.ent   isPrime
       isPrime:
          li $v1,1                                  # Truth value is true(1) by default
           
                li $t2,2                            # i = 2  
                div $t3,$a1,2                       # num/2 store the result in $t3        
                loop_isPrime:                        
                          div $a1,$t2               # num/i
                        
                          mfhi $t4                  # t2 =  remainder
                        
                          beqz $t4,isNotprime       # if the remainder is 0,then such a number is not prime
                        
                          addi $t2,$t2,1            # i ++
                                                
                blt $t2,$t3,loop_isPrime            # if i < num/2,continue looping
       
          jr $ra                                    # jump register to the caller and return address
                         isNotprime:
                 	       addi $v1,$v1,-1      # subract 1 such that the truth value goes to 0
                 	       jr $ra               # return address to the caller
                 	     
      		               b exit               # exit lable
                         exit:     
                               li $v0,10            # code to exit
                 	       syscall              # execute code
                 	    
                 	     
                 				    # used t2-t4 and can only be re-used after this procedure is call            	                 
.end   isPrime

# End of isPrime Procedure implementation
#
# -------------------------------------------------------------------------------------------------------------------------



# -------------------------------------------------------------------------------------------------------------------------
# Procedure/Function to find and print Reversible Prime Squares
# -------------------------------------------------------------------------------------------------------------------------
#
#
# H i g h - L e v e l   M o d e l 
#
# void print_reversible_prime_squares()
# {
#	printf("\n*************************************\n"
#	       "* First 10 reversible prime squares *\n"
#		   "*************************************\n\n");
#
#	int count = 1,j,i;
#	for ( i = 2; count<=10; i++ )
#	{  
#	    if (isPrime(i))
#	    {
#			int num     = i*i;
#			int rev_num = reverse(num);
#	            
#	        if (num != rev_num)
#	        {
#				for( j = 2; j<rev_num/2; j++ )
#				{			
#					if( j*j == rev_num && isPrime(j) )
#				   	{
#						printf("%d %s %d %s",count,".   ",num,"\n\n");	
#						
#						count++;			
#				   	}		
#			    }
#		    }
#		}
#	}
# }
#
#
#  L o w - L e v e l   M o d e l 
#
#  Arguments : 
#          None
#
# Returns:
#         reversible prime squares - $t7's
#
#  I m p l e m e n t a t i o n 
# -------------------------------------------------------------------------------------------------------------------------

.globl print_reversible_prime_squares
.ent   print_reversible_prime_squares
       print_reversible_prime_squares:
       
             li $v0,4                                     # code to print text
             la $a0,welcome_msg                           # load welcome message from RAM
             syscall                                      # execute 
       
           li $t5,1                                       # count = 1
           li $t6,2                                       # i = 2 
           loop:
               move $a1,$t6                               # pass i to check if is prime
               jal isPrime                                # used t2-t4,a1, we can now re-use them after this call
           
               beqz $v1,loop_i                            # if isPrime returns 0,loop
           
                    mul $t7,$t6,$t6                       # num=t7=     = i*i= t6*t6
                    move $a0,$t7                          # pass num(t7) as arg to reverse()
                    jal reverse                           # used t0,t1,a0 and can be reused after this call
                    move $t4,$v0                          # move reversed number to $t4
                    beq $t7,$t4, loop_i                   # if num = reverse(num).i.e if palindrome ...loop
                   
                   li $t1,2                               # j = 2
                   div $t8,$t4,2                          # move half of reversed number to t8 to loop is square roots
                   loop_rev_fac:
                        mul $t0,$t1,$t1                   # sq = j*j
                        bne $t0,$t4,loop_j                # if reversed num != sq ... , loop
                        move $a1,$t1                      # if  reversed num = sq ... ,check if j is prime
                        jal isPrime                       # call isPrime procedure to check if j is prime
                        beq $v1,0,loop_i                  # if j is not prime ... 
             
             li $v0,1                                     # code to print integer
             move $a0,$t5                                 # move numbering num into t5
             syscall                                      # execute
             
             li $v0,4                                     # code to print text
             la $a0,numbering_msg                         # load numbering text from RAM 
             syscall                                      # execute
             
             li $v0,1                                     # code to print integer                           
             move $a0,$t7                                 # move reversible prime square into t5
             syscall                                      # execute
             
                  
             li $v0,4                                     # code to print text
             la $a0,new_line                              # load newline from RAM
             syscall                                      # execute
               
             addi $t5,$t5,1                               # counter ++
             
           
           loop_j:                                        # loop factors of reversed number to check which one is a square root
             addi $t1,$t1,1                               # j++
             blt  $t1,$t8,loop_rev_fac                    # if not find square root ... loop
         
           loop_i:
             addi $t6,$t6,1                               # i++
             ble  $t5,11,loop                             # if count<=10,continue
             beq  $t5,11,exitm                            # if counter = 11...exit
           exitm:                                         # lable to terminate program
	     li $v0,10                                    # code to terminate
	     syscall                                      # execute
        
           jr $ra                                         # return address of print_reversible_prime_squares to the caller
.end   print_reversible_prime_squares
       
# End of print_reversible_prime_squares function implementation
#
# -------------------------------------------------------------------------------------------------------------------------
