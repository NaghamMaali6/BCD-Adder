`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.
	
module Register_4Bit(input clk , input rst , input en , input [3:0] D , output [3:0] Q) ;
	
	Register_1Bit R0 (.clk(clk) , .rst(rst) , .en(en) , .D(D[0]) , .Q(Q[0])) ;
	Register_1Bit R1 (.clk(clk) , .rst(rst) , .en(en) , .D(D[1]) , .Q(Q[1])) ;
	Register_1Bit R2 (.clk(clk) , .rst(rst) , .en(en) , .D(D[2]) , .Q(Q[2])) ;
	Register_1Bit R3 (.clk(clk) , .rst(rst) , .en(en) , .D(D[3]) , .Q(Q[3])) ;
	
endmodule
