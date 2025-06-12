/*D-ff*/
`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.

module Register_1Bit(input clk , input rst , input en , input D , output reg Q) ;

    always @(posedge clk or posedge rst) 
	begin
        if (rst)
            Q <= 1'b0 ;  //Reset to 0 when reset is asserted
        else if (en)
            Q <= D ;  //Update q to d on clock edge		
    end

endmodule