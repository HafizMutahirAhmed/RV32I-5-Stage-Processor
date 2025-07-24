`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 11:05:23 AM
// Design Name: 
// Module Name: RegisterFile
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
import RISCV_PKG::*;

module RegisterFile (input logic [ADDRESS_PORT_WIDTH-1:0] ReadReg1, ReadReg2, WriteAddress,
                    input logic CLK, Reset, RegWrite,
                    input logic [REG_WIDTH-1:0] WriteData,
                    output logic [REG_WIDTH-1:0] ReadData1, ReadData2);
    logic [REG_WIDTH-1:0] Registers [REG_COUNT-1:0] = '{default:0};


    always_comb begin
        ReadData1 = Registers[ReadReg1];
        ReadData2 = Registers[ReadReg2];
    end
                
    always @(posedge CLK or posedge Reset) begin
        if (Reset) begin
             Registers <= '{default:0};
        end
        else begin
             if (RegWrite && (WriteAddress != 5'b0)) begin
                 Registers[WriteAddress]<= WriteData;
             end
        end
    end
            
endmodule
