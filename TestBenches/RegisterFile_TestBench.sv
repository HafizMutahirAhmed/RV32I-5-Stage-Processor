`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:31:20 PM
// Design Name: 
// Module Name: RegisterFile_TestBench
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


module RegisterFile_TestBench;
    logic [ADDRESS_PORT_WIDTH-1:0] ReadReg1, ReadReg2, WriteAddress;
    logic CLK, Reset, RegWrite;
    logic [REG_WIDTH-1:0] WriteData;
    logic [REG_WIDTH-1:0] ReadData1, ReadData2;
    
    RegisterFile DUT (.ReadReg1(ReadReg1), 
                      .ReadReg2(ReadReg2), 
                      .WriteAddress(WriteAddress),
                      .CLK(CLK),
                      .Reset(Reset),
                      .RegWrite(RegWrite),
                      .WriteData(WriteData),
                      .ReadData1(ReadData1),
                      .ReadData2(ReadData2));
    initial begin
        CLK = 0;
        forever #10 CLK = ~CLK;
    end

    // Test sequence
    initial begin
        $display("----- Register File Test Started -----");
        
        // Initialize signals
        Reset = 1;
        RegWrite = 0;
        WriteAddress = 0;
        WriteData = 0;
        ReadReg1 = 0;
        ReadReg2 = 0;

        // Apply reset
        #10; // Wait for some time before deasserting reset
        Reset = 0;
        
        // Check that all registers are zero after reset
        ReadReg1 = 5'd0; // Read x0
        ReadReg2 = 5'd1; // Read x1
        #20; // Wait for clock cycles
       
        
        // Write 0xAAAA_BBBB to x1
        @(posedge CLK);
        RegWrite = 1;
        WriteAddress = 5'd1;
        WriteData = 32'hAAAA_BBBB;

        @(posedge CLK);
        RegWrite = 0;

        // Write 0x1234_5678 to x2
        @(posedge CLK);
        RegWrite = 1;
        WriteAddress = 5'd2;
        WriteData = 32'h1234_5678;

        @(posedge CLK);
        RegWrite = 0;

        // Read x1 and x2
        ReadReg1 = 5'd1;
        ReadReg2 = 5'd2;
        #20; // Wait for stable read data
        

        // Try writing to x0 (should be ignored)
        @(posedge CLK);
        RegWrite = 1;
        WriteAddress = 5'd0;
        WriteData = 32'hDEADBEEF;

        @(posedge CLK);
        RegWrite = 0;

        // Read x0 and x1
        ReadReg1 = 5'd0;
        ReadReg2 = 5'd1;
        #20; // Wait for stable read data
        

        // Apply reset again to check its functionality
        Reset = 1; // Assert reset
        #10; // Wait for a clock cycle
        Reset = 0; // Deassert reset again

        // Check that all registers are zero after second reset
        ReadReg1 = 5'd0; // Read x0
        ReadReg2 = 5'd1; // Read x1
        #20; // Wait for clock cycles

    end


endmodule
