/* Structural Verilog model for a 1-Digit BCD Adder */
	
`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.

module BCD_1Digit(input [3:0] A , input [3:0] B , input Cin , output [3:0] S , output Cout);
    
	wire [3:0] sum1 ;
    wire [3:0] sum2 ;
    wire carry1 ;
	wire carry2 ;
    wire invalid_bcd ;
	wire [3:0] correction = 4'b0110 ;  //6 
	wire s1 ;
	wire s2 ;

    //First 4-bit adder(A+B+Cin):
    FA_4Bit Adder1 (.A(A) , .B(B) , .Cin(Cin) , .Sum(sum1) , .Cout(carry1)) ;

    //Check if sum > 9 or carry1 = 1: 
	/* (sum1 > 1001) = sum1[3] & (sum1[2] | sum1[1]) */	
    or #11 (s1 , sum1[2] , sum1[1]) ; 
	and #11 (s2 , sum1[3] , s1) ;   
	or #11 (invalid_bcd , carry1 , s2) ;

    //Second 4-bit adder for BCD correction(if invalid, add 6):
    FA_4Bit Adder2 (.A(sum1) , .B(correction) , .Cin(0) , .Sum(sum2) , .Cout(carry2)) ;

    //output:
	assign S = invalid_bcd ? sum2 : sum1 ;
    assign Cout = invalid_bcd ? carry2 : carry1 ;
	
endmodule
