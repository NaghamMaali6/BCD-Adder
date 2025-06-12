/* Structural Verilog model for a 1-bit Full Adder */		
	/*inputs: 1-bit A   	 
	          1-bit B 
	          Carry-in
	*/ 
	/*outputs: 1-bit Sum
	           Carry-out
	*/ 

`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.
	
module FA_1Bit(input A , input B , input Cin , output Sum , output Cout) ;
	
	wire AxorB ;
	wire AandB ;
	wire AandCin ;
	wire BandCin ;
	wire AandBorAandCin ;
	
	xor #15 (AxorB , A , B) ;  //(A^B)
	xor #15 (Sum , AxorB , Cin) ;  //Sum = (A^B)^C
	
	and #11 (AandB , A , B) ;	 //(A&B)
	and #11 (AandCin , A , Cin) ;  //(A&Cin)
	and #11 (BandCin , B , Cin) ;  //(B&Cin) 
	or #11 (AandBorAandCin, AandB , AandCin) ;  //(A&B) | (A&Cin)
	or #11 (Cout , AandBorAandCin , BandCin) ;  //Cout = (A&B) | (A&Cin) | (B&Cin)
	
endmodule
	