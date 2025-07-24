`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2025 08:01:18 AM
// Design Name: 
// Module Name: ImmediateGen_TestBench
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


module ImmediateGen_TestBench;
    logic [INSTRUCTION_SIZE-1:0] Instruction;
    logic [IMMEDIATE_SIZE-1:0] ImmediateOutput;
    
    ImmediateGenerator DUT(.Instruction(Instruction), .ImmediateOutput(ImmediateOutput));
    
    initial begin
            $display("Time\tOpcode\t\tInstruction\t\t\tImmediate");
            $monitor("%0t\t%b\t%h\t%h", $time, Instruction[6:0], Instruction, ImmediateOutput);
    
            // -------- I-type: lw x1, 4(x2) --------
            // Opcode: 0000011
            // imm[11:0] = 000000000100 (4)
            Instruction = 32'b000000000100_00010_010_00001_0000011; #10;
            // Expected: 00000004
    
            // -------- I-type: addi x1, x2, -1 --------
            // Opcode: 0010011
            // imm[11:0] = 111111111111 (-1 signed)
            Instruction = 32'b111111111111_00010_000_00001_0010011; #10;
            // Expected: FFFFFFFF
    
            // -------- S-type: sw x1, 8(x2) --------
            // Opcode: 0100011
            // imm = 0000000 (31:25), rs2=00001, rs1=00010, funct3=010, imm[4:0]=01000 (11:7)
            Instruction = 32'b0000000_00001_00010_010_01000_0100011; #10;
            // Expected: 00000008
    
            // -------- B-type: beq x1, x2, -4 --------
            // Opcode: 1100011
            // Immediate = -4 = FFFFFFFC
            Instruction = 32'hFE000EE3; #10;
            // Expected: FFFFFFFC
    
            // -------- U-type: lui x1, 0x12345 --------
            // Opcode: 0110111
            // imm[31:12] = 0x12345, so Immediate = 0x12345000
            Instruction = 32'b00010010001101000101_00001_0110111; #10;
            // Expected: 12345000
    
            // -------- J-type: jal x1, 0x000FF0 --------
            // Immediate = 20-bit signed: 000000000000111111110000 (0xFF0)
            // Encoded as: imm[20]=0, imm[10:1]=0x7C, imm[11]=1, imm[19:12]=0x00
            Instruction = 32'h7F1000EF; #10;
            // Expected: 00000FF0
    
            $finish;
        end
endmodule
