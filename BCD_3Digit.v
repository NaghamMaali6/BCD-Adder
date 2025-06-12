`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.

module BCD_3Digit(input [11:0] A , input [11:0] B , input Cin , output [11:0] S , output Cout) ;

    wire c1 ;
	wire c2 ;

    BCD_1Digit D0 (.A(A[3:0]) ,  .B(B[3:0]) ,  .Cin(Cin) , .S(S[3:0]) ,  .Cout(c1)) ;  //Digit 0(Least Significant)
    BCD_1Digit D1 (.A(A[7:4]) ,  .B(B[7:4]) ,  .Cin(c1) ,  .S(S[7:4]) ,  .Cout(c2)) ;  //Digit 1
    BCD_1Digit D2 (.A(A[11:8]) , .B(B[11:8]) , .Cin(c2) ,  .S(S[11:8]) , .Cout(Cout)) ;  //Digit 2(Most Significant)

endmodule