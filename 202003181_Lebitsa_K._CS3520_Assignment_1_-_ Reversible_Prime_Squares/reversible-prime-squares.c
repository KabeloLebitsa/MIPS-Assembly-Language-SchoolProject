//	Author        : Kabelo Lebitsa
//	Email         : kaybeelebitsa23@gmail.com
//	Call/WhatsApp : +266 50 689 364
//  Date          : October 28,2022
//  Purpose       : Find and print first 10 reversible prime squares

#include<stdio.h>

// Function prototypes
int isPrime(int num);
int reverse(int num);
void print_reversible_prime_squares();

int main()
{
	print_reversible_prime_squares();  // print numbers on console
	
	return 0;
}

int isPrime( int num)  
            
// Function to test if a number is prime
//    Truth values: 
//	    _ true  - 1
//		_ false - 0
		
//	Approach:
//		_ We know that prime number is divisible by 1 and itself ...
//           i.e factors of prime number(number) = {1 ,number}

//		_ We want to therefore iterate between 2(inclusive) and (number-1) ,
//           and check if we can find one more factor of such a number

//		_ If such a factor is found...then number is not prime since it will be having factors more than 2

{
	int i;                         // Declare iterator...
	for(i = 2; i < num/2; i++)     // loop between 2 and (number - 1)
	{
		if (num%i == 0)           // test is there's any factor i that can divide a number and leave remainder 0...
			return 0;             // if such a factor is found... then,return 0
    }
	if (num < 2 )                 // +ve prime numbers are from 2 and above...
		return 0;                 // return 0  if number is less than 2...

	return 1;                     // return 1 by default
}

int reverse( int num)
// Function to return a reversed
{
    int remainder , reversed_num = 0;                   // declaring reversed number and remainder 
    
    for(int i = 0;num!=0;i++)                           // loop until num = 0
	{
		remainder = num%10;                             // remainder of number when divided by 10
		
     	reversed_num = reversed_num*10 + remainder;     // reversed number  =  reversed number multiplied by 10 plus remaider of number 
     	
     	num = num/10;                                   // num =  coefficient of  number when divided by 10
	}

	return reversed_num;	                            // return reversed number 
}

void print_reversible_prime_squares()
{
	// Welcome message
	printf("\n*************************************\n"
	       "* First 10 reversible prime squares *\n"
		   "*************************************\n\n");

	int count = 1,j,i;                                                  // declare iterators and counter which will break the loop
	for ( i = 2; count<=10; i++ )                                       // loop from 2 until counter is 10
	{  
	    if (isPrime(i))                                                 // check if i is prime
	    {
			int num     = i*i;                                          // if so,assume reversible prime square = i * i...
			int rev_num = reverse(num);                                 // ... and assume  reverse of reversible number 
	            
	        if (num != rev_num)                                         // to test if our assumption is true... test if number is not palindrome
	        {
				for( j = 2; j<rev_num/2; j++ )                          // loop factors of reverse number
				{			
					if( j*j == rev_num && isPrime(j) )                  // if we can find j that is prime and square root of reverse... 
				   	{
						printf("%d %s %d %s",count,".   ",num,"\n\n");  // then our assumption becomes true and hence print our reversible prime square
						
						count++;	                                    // increment counter only if our assumption becomes true		
				   	}		
			    }
		    }
		}
	}
}
