`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.   

module CLA_4Bit (input [3:0] A , input [3:0] B , input Cin , output [3:0] Sum , output Cout) ;

    wire [3:0] G ;    //Generate
    wire [3:0] P ;    //Propagate
    wire [3:1] C ;    //Internal carries
    wire P0Cin ;
	wire P1G0 ;
	wire P1P0 ;
	wire P1P0Cin ;
    wire P2G1 ;
	wire P2P1 ;
	wire P2P1G0 ;
	wire P2P1P0 ;
	wire P2P1P0Cin ;
    wire P3G2 ;
	wire P3P2 ;
	wire P3P2P1 ;
	wire P3P2P1G0 ;
	wire P3P2P1P0 ;
	wire P3P2P1P0Cin ;
    wire P3P2G1 ;

    //Propagate (P = A ^ B):
    xor #15 (P[0] , A[0] , B[0]) ;
    xor #15 (P[1] , A[1] , B[1]) ;
    xor #15 (P[2] , A[2] , B[2]) ;
    xor #15 (P[3] , A[3] , B[3]) ;

    //Generate (G = A & B):
    and #11 (G[0] , A[0] , B[0]) ;
    and #11 (G[1] , A[1] , B[1]) ;
    and #11 (G[2] , A[2] , B[2]) ;
    and #11 (G[3] , A[3] , B[3]) ;

    //Carry C1 = G0 | (P0 & Cin):
    and #11 (P0Cin , P[0] , Cin) ;
    or  #11 (C[1] , G[0] , P0Cin) ;

    //Carry C2 = G1 | (P1 & G0) | (P1 & P0 & Cin):
    and #11 (P1G0 , P[1] , G[0]) ;
    and #11 (P1P0 , P[1] , P[0]) ;
    and #11 (P1P0Cin , P1P0 , Cin) ;
    or  #11 (C[2] , G[1] , P1G0 , P1P0Cin) ;

    //Carry C3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & Cin):
    and #11 (P2G1 , P[2] , G[1]) ;
    and #11 (P2P1 , P[2] , P[1]) ;
    and #11 (P2P1G0 , P2P1 , G[0]) ;
    and #11 (P2P1P0 , P2P1 , P[0]) ;
    and #11 (P2P1P0Cin , P2P1P0 , Cin) ;
    or  #11 (C[3] , G[2] , P2G1 , P2P1G0 , P2P1P0Cin) ;

    //Carry-out = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & Cin):
    and #11 (P3G2 , P[3] , G[2]) ;
    and #11 (P3P2 , P[3] , P[2]) ;
    and #11 (P3P2G1 , P3P2 , G[1]) ;
    and #11 (P3P2P1 , P3P2 , P[1]) ;
    and #11 (P3P2P1G0 , P3P2P1 , G[0]) ;
    and #11 (P3P2P1P0 , P3P2P1 , P[0]) ;
    and #11 (P3P2P1P0Cin , P3P2P1P0 , Cin) ;
    or  #11 (Cout , G[3] , P3G2 , P3P2G1 , P3P2P1G0 , P3P2P1P0Cin) ;

    //Sum = P ^ C:
    xor #15 (Sum[0] , P[0] , Cin) ;
    xor #15 (Sum[1] , P[1] , C[1]) ;
    xor #15 (Sum[2] , P[2] , C[2]) ;
    xor #15 (Sum[3] , P[3] , C[3]) ;

endmodule
