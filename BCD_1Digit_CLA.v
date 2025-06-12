`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.

module BCD_1Digit_CLA (input  [3:0] A , input  [3:0] B , input Cin , output [3:0] S , output Cout) ;

    wire [3:0] sum1 ;           //Initial sum
    wire [3:0] sum_corrected ;  //Sum after BCD correction
    wire carry1 ;               //Carry from first CLA adder
    wire carry2 ;               //Carry from correction adder
    wire invalid_bcd ;          //Flag: sum > 9 or carry1
    wire [3:0] correction = 4'b0110 ;  // +6 in binary

    wire check_high ;  //Intermediate wires for invalid BCD check
    wire check_bcd ;

    //First CLA adder(A + B + Cin):
    CLA_4Bit Adder1 (.A(A) , .B(B) , .Cin(Cin) , .Sum(sum1) , .Cout(carry1)) ;

    //Check if sum1 > 9:
    or  #11 (check_high , sum1[2] , sum1[1]) ;
    and #11 (check_bcd , sum1[3] , check_high) ;
    or  #11 (invalid_bcd , carry1 , check_bcd) ;

    //Second CLA adder(sum1 + 6):
    CLA_4Bit Adder2 (.A(sum1) , .B(correction) , .Cin(1'b0), .Sum(sum_corrected) , .Cout(carry2)) ;

    //output:
    assign S = invalid_bcd ? sum_corrected : sum1 ;
    assign Cout  = invalid_bcd ? carry2 : carry1 ;

endmodule