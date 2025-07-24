`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2025 01:46:52 PM
// Design Name: 
// Module Name: ALUControl_TestBench
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


module ALUControl_TestBench;
    logic [2:0] ALUOp;
    logic [2:0] func3;
    logic [6:0] func7;
    logic [3:0] ALUOperation;
    
    ALUControl DUT(.ALUOp(ALUOp), .func3(func3), .func7(func7), .ALUOperation(ALUOperation));
    
    initial begin
        // Test 1
        ALUOp = 3'b000; func3 = 3'b110; func7 = 7'b0000000; #10;
        // Test 2
        ALUOp = 3'b101; func3 = 3'b110; func7 = 7'b0000000; #10;
        // Test 3
        ALUOp = 3'b000; func3 = 3'b111; func7 = 7'b0000000; #10;
        // Test 4
        ALUOp = 3'b101; func3 = 3'b111; func7 = 7'b0000000; #10;
        // Test 5
        ALUOp = 3'b101; func3 = 3'b000; func7 = 7'b0000000; #10;
        // Test 6
        ALUOp = 3'b011; func3 = 3'b101; func7 = 7'b0000000; #10;
        // Test 7
        ALUOp = 3'b011; func3 = 3'b100; func7 = 7'b0000000; #10;
        // Test 8
        ALUOp = 3'b011; func3 = 3'b000; func7 = 7'b0000000; #10;
        // Test 9
        ALUOp = 3'b101; func3 = 3'b100; func7 = 7'b0000000; #10;
        // Test 10
        ALUOp = 3'b101; func3 = 3'b101; func7 = 7'b0000000; #10;
        // Test 11
        ALUOp = 3'b101; func3 = 3'b011; func7 = 7'b0000000; #10;
        // Test 12
        ALUOp = 3'b010; func3 = 3'b011; func7 = 7'b0000000; #10;
        // Default case (invalid combo)
        ALUOp = 3'b111; func3 = 3'b111; func7 = 7'b1111111; #10;

        #20;
        $finish;
    end
endmodule
