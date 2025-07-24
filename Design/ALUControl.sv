`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2025 11:34:17 AM
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(input logic [2:0] ALUOp,
                  input logic [2:0] func3,
                  input logic [6:0] func7,
                  output logic [3:0] ALUOperation);
    always_comb begin
        casez({ALUOp,func3, func7[5]})
            7'b000110?, 7'b101110?: ALUOperation = 4'b0000;
            7'b000111?, 7'b101111?: ALUOperation = 4'b0001;
            7'b100????, 7'b1010000, 7'b000000?, 7'b110????, 7'b001????, 7'b111????, 7'b010????: ALUOperation = 4'b0010;
            7'b1010001: ALUOperation = 4'b0011;
            7'b101010?, 7'b000010?: ALUOperation = 4'b0101;
            7'b101001?, 7'b000001?: ALUOperation = 4'b1000;
            7'b101100?, 7'b000100?: ALUOperation = 4'b1001;
            7'b1011010, 7'b0001010: ALUOperation = 4'b1010;
            7'b1011011, 7'b0001011: ALUOperation = 4'b1011;
            7'b101011?, 7'b000011?: ALUOperation = 4'b1101;
            default: ALUOperation = 4'b1111;
        endcase
    end
endmodule
