`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 10:47:43 AM
// Design Name: 
// Module Name: ALU_TestBench
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


module ALU_TestBench;
     logic [31:0] A, B;
     logic [3:0] ALUOp;
     logic [31:0] out;
     logic ONE;
     
     ALU DUT (.dataA(A), .dataB(B), .ALUOperation(ALUOp), .ALUOutput(out), .ONE(0NE));
     
     initial begin
        A = 32'd4; B = 32'd2; #10;
        ALUOp = 4'b0000; #10;
        ALUOp = 4'b0001; #10;
        ALUOp = 4'b0010; #10;
        ALUOp = 4'b0011; #10;
        ALUOp = 4'b0100; #10;
        ALUOp = 4'b0101; #10;
        ALUOp = 4'b0110; #10;
        ALUOp = 4'b0111; #10;
        ALUOp = 4'b1000; #10;
        ALUOp = 4'b1001; #10;
        ALUOp = 4'b1010; #10;
        ALUOp = 4'b1011; #10;

     end
     
endmodule
