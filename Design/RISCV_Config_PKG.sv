`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 11:44:02 AM
// Design Name: 
// Module Name: RISCV_Config_PKG
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

package RISCV_PKG;

    parameter REG_COUNT = 32,
              REG_WIDTH = 32,
              ADDRESS_PORT_WIDTH = 5,
              INSTRUCTION_SIZE = 32, 
              IMMEDIATE_SIZE = 32,
              WORD_LENGTH = 32,
              OPCODE_SIZE = 7, 
              MEM_WIDTH=4, 
              MEM_SIZE = 268435456, 
              HALF_MEM = 32768,
              MEM_ROWS = 1 << 25;
    

endpackage
