`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.
	
module Register_12Bit(input clk , input rst , input en , input [11:0] D , output [11:0] Q) ;
	
	Register_4Bit R0 (.clk(clk) , .rst(rst) , .en(en) , .D(D[3:0]) , .Q(Q[3:0])) ;
	Register_4Bit R1 (.clk(clk) , .rst(rst) , .en(en) , .D(D[7:4]) , .Q(Q[7:4])) ;
	Register_4Bit R2 (.clk(clk) , .rst(rst) , .en(en) , .D(D[11:8]) , .Q(Q[11:8])) ;
	
endmodule