`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 01:11:27 PM
// Design Name: 
// Module Name: ProgramCounter_TestBench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ProgramCounter_TestBench;

    // Inputs
    logic CLK;
    logic Reset, JumpReg, Jump, Branch, ONE;
    logic [31:0] ImmediateOutput, ReadData1;

    // Output
    logic [31:0] PC = 0;

    // Instantiate the ProgramCounter module
    ProgramCounter DUT (
        .CLK(CLK),
        .Reset(Reset),
        .JumpReg(JumpReg),
        .Jump(Jump),
        .Branch(Branch),
        .ONE(ONE),
        .ImmediateOutput(ImmediateOutput),
        .ReadData1(ReadData1),
        .PC(PC)
    );

    // Clock generation: toggles every 5ns
    always #5 CLK = ~CLK;

    initial begin
        // Initialize inputs
        CLK = 0;
        Reset = 1;
        JumpReg = 0;
        Jump = 0;
        Branch = 0;
        ONE = 0;
        ImmediateOutput = 32'd20; // doesn't matter in this case
        ReadData1 = 32'd300;      // doesn't matter in this case
        Reset = 0;
        // Wait for a few clock cycles to see PC increment
        #10;  // 1st posedge -> PC = 0 + 4 = 4

        // Print final result
        $display("Final PC after 3 cycles = %0d (Expected: 12)", PC);

        $finish;
    end

endmodule




