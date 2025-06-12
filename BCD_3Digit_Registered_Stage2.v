`timescale 1ns / 1ps  //timescale directive: Specifies the time unit (1ns) and precision (1ps) for delays and simulation time.

module BCD_3Digit_Registered_Stage2 (input clk , input rst , input en , input [11:0] A , input [11:0] B , input Cin , output [11:0] S , output Cout) ;
    
	wire [11:0] A_reg ;
    wire [11:0] B_reg ;
    wire Cin_reg ; 
	wire [11:0] S_reg ;	  
	wire Cout_reg ;

    Register_12Bit RegA (.clk(clk), .rst(rst) , .en(en) , .D(A) , .Q(A_reg)) ;
    Register_12Bit RegB (.clk(clk) , .rst(rst) , .en(en), .D(B), .Q(B_reg)) ;
    Register_1Bit  RegCin (.clk(clk) , .rst(rst) , .en(en) , .D(Cin) , .Q(Cin_reg)) ;

    BCD_3Digit_CLA Adder (.A(A_reg) , .B(B_reg) , .Cin(Cin_reg) , .S(S) , .Cout(Cout)) ;	 
	
	Register_12Bit RegS (.clk(clk), .rst(rst) , .en(en) , .D(S) , .Q(S_reg)) ; 
	Register_1Bit RegCout (.clk(clk) , .rst(rst) , .en(en) , .D(Cout) , .Q(Cout_reg)) ;
	
endmodule

//testbench:

module testbench_Stage2 ; 

    parameter CLK_PERIOD = 100 ;  //Defines the clock period in nanoseconds.

    reg clk ;                        // Clock signal
    reg rst ;                        // Asynchronous reset signal (active high)
    reg en ;                         // Enable signal for registers
    reg [11:0] A_in ;                // 12-bit BCD input A (3 digits)
    reg [11:0] B_in ;                // 12-bit BCD input B (3 digits)
    reg Cin ;                        // 1-bit Carry-in
    wire [11:0] S_out ;              // 12-bit BCD sum output (3 digits)
    wire Cout ;                      // 1-bit Carry-out

    //an instance of registered 3-digit BCD adder module and connect each reg to input and each wire to output:
    BCD_3Digit_Registered_Stage2 M (.clk(clk) , .rst(rst) , .en(en) , .A(A_in) , .B(B_in) , .Cin(Cin) , .S(S_out) , .Cout(Cout)) ;

    //--- Clock Generation --- 
    //This 'initial' block runs once at the start of the simulation.
    initial 
	begin
        clk = 1'b0 ;  //Initialize clock to 0.
        //'forever' loop creates a continuous clock signal.
        //# (CLK_PERIOD / 2) waits for half the clock period.
        //clk = ~clk; toggles the clock value (0 to 1, 1 to 0).
        forever #(CLK_PERIOD / 2) clk = ~clk ;
    end

    //--- Test Sequence and Verification Logic --- 
    //This 'initial' block defines the sequence of actions for the test.
    initial 
	begin 		   
		integer file_handle ;
		//Display a starting message in the simulation console.
        $display("Starting Testbench for BCD_3Digit_Registered_Stage2...") ;

        //1. Initialize Inputs and Apply Reset
        rst = 1'b1 ;                 //Assert the reset signal (make it high).
        en = 1'b0 ;                  //Keep the register enable low during reset.
        A_in = 12'h000 ;             //Set inputs to 'X' (unknown) during reset - good practice.
        B_in = 12'h000 ;
        Cin = 1'b0 ;
        //Wait for a couple of clock cycles while reset is active.
        # (CLK_PERIOD * 13) ;

        //2. Deassert Reset and Enable 
        rst = 1'b0 ;                 //Deassert the reset signal (make it low).
        en = 1'b1 ;                  //Assert the register enable (make it high).
        //Wait one full clock cycle for the reset signal change to take effect 
        # (CLK_PERIOD * 13) ;

        //--- Functional Verification Test Cases --- 
        $display("\n--- Starting Critical Functional Tests ---") ;

        //Test Case 1: Zero Test (000 + 000, Cin=0 -> S=000, Cout=0)
        //Apply inputs.
        A_in = 12'h000 ; 
		B_in = 12'h000 ; 
		Cin = 1'b0 ;
        //Wait one full clock cycle for the inputs to be registered and the result to propagate through the combinational logic and be captured by the output registers.
        # (CLK_PERIOD * 3) ;
        //Check the registered outputs against the expected values.
        //Use '===' (case equality) for comparison, which also checks for X and Z values.
        if (S_out === 12'h000 && Cout === 1'b0) 
			$display("PASS: 000 + 000 + 0 = %h , Cout=%b" , S_out , Cout) ;
        else 
			$display("FAIL: 000 + 000 + 0. Expected S=000 , Cout=0. Got S=%h , Cout=%b" , S_out , Cout) ;

        //Test Case 2: Simple Addition (123 + 456, Cin=0 -> S=579, Cout=0)
        A_in = 12'h123 ; 
		B_in = 12'h456 ; 
		Cin = 1'b0 ;
        # (CLK_PERIOD * 3) ; //Wait for result
        if (S_out === 12'h579 && Cout === 1'b0) 
			$display("PASS: 123 + 456 + 0 = %h, Cout=%b" , S_out , Cout) ;
        else 
			$display("FAIL: 123 + 456 + 0. Expected S=579 , Cout=0. Got S=%h , Cout=%b" , S_out , Cout) ;

        //Test Case 3: Single Digit Correction (005 + 007, Cin=0 -> S=012, Cout=0)
        //Tests if the BCD correction logic (add 6 when sum > 9) works in the least significant digit.
        A_in = 12'h005 ; 
		B_in = 12'h007 ; 
		Cin = 1'b0 ;
        # (CLK_PERIOD * 3) ; //Wait for result
        if (S_out === 12'h012 && Cout === 1'b0) 
			$display("PASS: 005 + 007 + 0 = %h, Cout=%b" , S_out , Cout) ;
        else 
			$display("FAIL: 005 + 007 + 0. Expected S=012 , Cout=0. Got S=%h , Cout=%b" , S_out , Cout) ;

        //Test Case 4: Carry Propagation (No Correction) (048 + 051, Cin=0 -> S=099, Cout=0)
        //Tests carry propagation between digits without needing BCD correction.
        A_in = 12'h048 ; 
		B_in = 12'h051 ; 
		Cin = 1'b0 ;
        # (CLK_PERIOD * 3) ; //Wait for result
        if (S_out === 12'h099 && Cout === 1'b0) 
			$display("PASS: 048 + 051 + 0 = %h , Cout=%b" , S_out , Cout) ;
        else 
			$display("FAIL: 048 + 051 + 0. Expected S=099 , Cout=0. Got S=%h , Cout=%b" , S_out , Cout) ;

        //Test Case 5: Carry Propagation with Correction (Digit 0) (048 + 005, Cin=0 -> S=053, Cout=0)
        //Tests interaction: Digit 0 needs correction (8+5=13 -> BCD 3 carry 1), carry propagates to Digit 1.
        A_in = 12'h048 ; 
		B_in = 12'h005; 
		Cin = 1'b0;
        # (CLK_PERIOD * 3) ; //Wait for result
        if (S_out === 12'h053 && Cout === 1'b0) 
			$display("PASS: 048 + 005 + 0 = %h , Cout=%b" , S_out , Cout) ;
        else 
			$display("FAIL: 048 + 005 + 0. Expected S=053 , Cout=0. Got S=%h , Cout=%b" , S_out , Cout) ;

        //Test Case 6: Test with Cin (111 + 222, Cin=1 -> S=334, Cout=0)
        //Simple case testing the initial carry-in.
        A_in = 12'h111 ; 
		B_in = 12'h222 ; 
		Cin = 1'b1 ;
        # (CLK_PERIOD * 3) ; //Wait for result
        if (S_out === 12'h334 && Cout === 1'b0) 
			$display("PASS: 111 + 222 + 1 = %h , Cout=%b" , S_out , Cout) ;
        else 
			$display("FAIL: 111 + 222 + 1. Expected S=334 , Cout=0. Got S=%h , Cout=%b" , S_out , Cout) ;
        
		
		//--- Error Injection Test Case ---
        //This test case targets the specific injected error:
        //In CLA_4Bit.v, reversed AND and OR gates.
        //Test Input: A=004, B=004, Cin=0
        //Expected CORRECT Output: S=008, Cout=0
        //Expected FAULTY Output (due to incorrect correction): S=014 (invalid BCD), Cout=1 (incorrect)
        //We check if the output differs from the CORRECT output.
        $display("\n--- Starting Error Injection Test ---") ;
        $display("Applying inputs for specific error case (A=004 , B=004 , Cin=0)...") ;
        A_in = 12'h004 ;
		B_in = 12'h004 ; 
		Cin = 1'b0 ;
        # (CLK_PERIOD * 3) ; //Wait for result
		
        //Check if the output DIFFERS from the known correct output (S=008, Cout=0)
        if (S_out !== 12'h008 || Cout !== 1'b0)
		begin
            $display("PASS: Injected error detected! Output (S=%h , Cout=%b) differs from correct value (S=008, Cout=0)." , S_out , Cout) ;
            file_handle = $fopen("error_report.txt" , "w") ; //Open file for writing
            $fdisplay(file_handle , "Error detected: Incorrect gate: OR instead of AND: \nor #11 (P1G0 , P[1] , G[0]) ;\nor #11 (P1P0 , P[1] , P[0]) ;\nor #11 (P1P0Cin , P1P0 , Cin) ;\nand AND instead of OR: \nand  #11 (C[2] , G[1] , P1G0 , P1P0Cin) ; \nand  #11 (C[3] , G[2] , P2G1 , P2P1G0 , P2P1P0Cin) ; \nand  #11 (Cout , G[3] , P3G2 , P3P2G1 , P3P2P1G0 , P3P2P1P0Cin) ; \nin CLA_4Bit.v caught by testbench.") ; //Write message
            $fclose(file_handle) ; //Close file
        end 
		else 
		begin
            $display("Injected error NOT detected! Output (S=%h , Cout=%b) matches correct value (S=008 , Cout=0)." , S_out , Cout) ;
        end
        
		
		//--- End Simulation --- 
        $display("\nTestbench Finished.") ;
        //Wait a few more cycles to allow final messages to print before ending.
        # (CLK_PERIOD * 5) ;
        $finish ; //Verilog system task to end the simulation.
    end

endmodule