`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2025 11:12:45 AM
// Design Name: 
// Module Name: ControlUnit_TestBench
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


module ControlUnit_TestBench;
    logic [OPCODE_SIZE-1:0] Opcode;
    logic [2:0] ALUOp;
    logic JumpReg, Jump, Branch, RegSrc1, RegSrc2, UpperImm, RegWrite, MemWrite, MemToReg, RetAddr;
    
    ControlUnit DUT (
            .Opcode(Opcode),
            .ALUOp(ALUOp),
            .JumpReg(JumpReg),
            .Jump(Jump),
            .Branch(Branch),
            .RegSrc1(RegSrc1),
            .RegSrc2(RegSrc2),
            .UpperImm(UpperImm),
            .RegWrite(RegWrite),
            .MemWrite(MemWrite),
            .MemToReg(MemToReg),
            .RetAddr(RetAddr)
        );
    initial begin
        // Test each opcode
        Opcode = 7'b0110011; #10;  // R-type
        Opcode = 7'b0010011; #10; // I-type ALU
        Opcode = 7'b0000011; #10;  // Load
        Opcode = 7'b0100011; #10; // Store
        Opcode = 7'b1100011; #10; // Branch
        Opcode = 7'b1100111; #10;  // JALR
        Opcode = 7'b1101111; #10;  // JAL
        Opcode = 7'b0110111; #10;  // LUI
        Opcode = 7'b0010111; #10; // AUIPC
        $finish;
    end
endmodule
