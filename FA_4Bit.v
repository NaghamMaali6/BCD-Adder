/* Structural Verilog model for a 4-bit Full Adder(Ripple Carry Adder) */	
	/*inputs: 4-bit A   	 
	          4-bit B 
	          Carry-in
	*/ 
	/*outputs: 4-bit Sum
	           Carry-out
	*/
	/* The design uses four 1-bit full adders connected in series */

`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.
	
module FA_4Bit(input [3:0] A , input [3:0] B , input Cin , output [3:0] Sum , output Cout) ;
	
	wire c1 ;
	wire c2 ;
	wire c3 ;
	
	FA_1Bit U1 (.A(A[0]) , .B(B[0]) , .Cin(Cin) , .Sum(Sum[0]) , .Cout(c1)) ;
	FA_1Bit U2 (.A(A[1]) , .B(B[1]) , .Cin(c1) , .Sum(Sum[1]) , .Cout(c2)) ;
	FA_1Bit U3 (.A(A[2]) , .B(B[2]) , .Cin(c2) , .Sum(Sum[2]) , .Cout(c3)) ;
	FA_1Bit U4 (.A(A[3]) , .B(B[3]) , .Cin(c3) , .Sum(Sum[3]) , .Cout(Cout)) ;	 
	
endmodule
	
