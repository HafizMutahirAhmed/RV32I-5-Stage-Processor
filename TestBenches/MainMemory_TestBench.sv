`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:14:55 AM
// Design Name: 
// Module Name: MainMemory_TestBench
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


module MainMemory_TestBench;
    logic CLK, Reset, MemWrite;
    logic [2:0] Funct3;
    logic [INSTRUCTION_SIZE-1:0] InstructionAddress, DataAddress, WriteData;
    logic [INSTRUCTION_SIZE-1:0] ReadInstruction, ReadData;
    
    MainMemory DUT(
            .CLK(CLK), 
            .Reset(Reset), 
            .MemWrite(MemWrite),
            .Funct3(Funct3), 
            .InstructionAddress(InstructionAddress),
            .DataAddress(DataAddress),
            .WriteData(WriteData),
            .ReadInstruction(ReadInstruction),
            .ReadData(ReadData)
    );
    
    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    initial begin
        $display("----- Main Memory Test Started -----");

        // Initialize inputs
        CLK = 0;
        Reset = 1;
        MemWrite = 0;
        Funct3 = 3'b000;
        WriteData = 0;
        InstructionAddress = 0;
        DataAddress = 0;

        #10;
        Reset = 0;

        // Since WriteInstruction logic is removed, we only test reading the preloaded instruction
        // Assuming address 0x00 has some instruction loaded from "Instructions.mem"
        InstructionAddress = 32'h00000000;
        @(posedge CLK);
        #1;
        $display("Instruction Read @ 0x00 = %h", ReadInstruction);

        // --- Write data ---
        @(posedge CLK);
        DataAddress = 32'h00000004;
        WriteData = 32'hCAFEBABE;
        Funct3 = 3'b010; // sw
        MemWrite = 1;

        @(posedge CLK);
        MemWrite = 0;

        // --- Read data as LW ---
        @(posedge CLK);
        Funct3 = 3'b010;
        #1;
        $display("LW  Read @ 0x04 = %h (Expected CAFEBABE)", ReadData);

        // --- Read data as LB ---
        @(posedge CLK);
        Funct3 = 3'b000;
        #1;
        $display("LB  Read @ 0x04 = %h (Expected FFFFFFBE)", ReadData);

        // --- Read data as LBU ---
        @(posedge CLK);
        Funct3 = 3'b100;
        #1;
        $display("LBU Read @ 0x04 = %h (Expected 000000BE)", ReadData);

        // --- Read data as LH ---
        @(posedge CLK);
        Funct3 = 3'b001;
        #1;
        $display("LH  Read @ 0x04 = %h (Expected FFFFBABE)", ReadData);

        // --- Read data as LHU ---
        @(posedge CLK);
        Funct3 = 3'b101;
        #1;
        $display("LHU Read @ 0x04 = %h (Expected 0000BABE)", ReadData);

        // --- Apply reset again ---
        Reset = 1;
        @(posedge CLK); 
        Reset = 0;
        @(posedge CLK); 
        
        // Read again after reset, should be cleared
        InstructionAddress = 32'h00000000;
        DataAddress = 32'h00000004;
        Funct3 = 3'b010;
        @(posedge CLK);
        #1;
        $display("Instruction Read After Reset @ 0x00 = %h (Expected 00000000)", ReadInstruction);
        $display("Data Read After Reset @ 0x04 = %h (Expected 00000000)", ReadData);

        $display("----- Main Memory Test Completed -----");
        $finish;
    end
endmodule
