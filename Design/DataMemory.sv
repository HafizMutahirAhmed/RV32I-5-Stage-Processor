`timescale 1ns / 1ps
import RISCV_PKG::*;

module DataMemory(
    input  logic CLK, EN, MemWrite,
    input  logic [2:0] Funct3,
    input  string data_memory_path,
    input  logic [INSTRUCTION_SIZE-1:0] DataAddress, WriteData,
    output logic [INSTRUCTION_SIZE-1:0] ReadData,
    output logic [3:0] mask_bits
);

    logic [WORD_LENGTH-1:0] Memory[0:MEM_ROWS - 1];

    initial begin
        #1;
        $readmemh(data_memory_path, Memory);
    end

    // ---------- Write Logic ----------
    always_ff @(posedge CLK or posedge EN) begin
        if (EN && MemWrite && (DataAddress >> 2) < MEM_SIZE) begin
            case (Funct3)
                3'b010: begin // sw (full word)
                    Memory[DataAddress >> 2] <= WriteData;
                    mask_bits <= 4'b1111;
                end

                3'b001: begin // sh (halfword)
                    case (DataAddress[1])
                        1'b0: Memory[DataAddress >> 2][15:0]  <= WriteData[15:0];
                        1'b1: Memory[DataAddress >> 2][31:16] <= WriteData[15:0];
                    endcase
                    mask_bits <= 4'b0011;
                end

                3'b000: begin // sb (byte)
                    case (DataAddress[1:0])
                        2'b00: Memory[DataAddress >> 2][7:0]   <= WriteData[7:0];
                        2'b01: Memory[DataAddress >> 2][15:8]  <= WriteData[7:0];
                        2'b10: Memory[DataAddress >> 2][23:16] <= WriteData[7:0];
                        2'b11: Memory[DataAddress >> 2][31:24] <= WriteData[7:0];
                    endcase
                    mask_bits <= 4'b0001;
                end

                default: mask_bits <= 4'b0000;
            endcase
        end else begin
            mask_bits <= 4'b0000;
        end
    end

    // ---------- Read Logic ----------
    always_comb begin
        if (EN && (DataAddress >> 2) < MEM_SIZE) begin
            case (Funct3)
                3'b010: begin // lw
                    ReadData = Memory[DataAddress >> 2];
                end

                3'b001: begin // lh (sign-extended)
                    case (DataAddress[1])
                        1'b0: ReadData = {{16{Memory[DataAddress >> 2][15]}}, Memory[DataAddress >> 2][15:0]};
                        1'b1: ReadData = {{16{Memory[DataAddress >> 2][31]}}, Memory[DataAddress >> 2][31:16]};
                    endcase
                end

                3'b000: begin // lb (sign-extended)
                    case (DataAddress[1:0])
                        2'b00: ReadData = {{24{Memory[DataAddress >> 2][7]}},  Memory[DataAddress >> 2][7:0]};
                        2'b01: ReadData = {{24{Memory[DataAddress >> 2][15]}}, Memory[DataAddress >> 2][15:8]};
                        2'b10: ReadData = {{24{Memory[DataAddress >> 2][23]}}, Memory[DataAddress >> 2][23:16]};
                        2'b11: ReadData = {{24{Memory[DataAddress >> 2][31]}}, Memory[DataAddress >> 2][31:24]};
                    endcase
                end

                3'b101: begin // lhu (zero-extended)
                    case (DataAddress[1])
                        1'b0: ReadData = {16'b0, Memory[DataAddress >> 2][15:0]};
                        1'b1: ReadData = {16'b0, Memory[DataAddress >> 2][31:16]};
                    endcase
                end

                3'b100: begin // lbu (zero-extended)
                    case (DataAddress[1:0])
                        2'b00: ReadData = {24'b0, Memory[DataAddress >> 2][7:0]};
                        2'b01: ReadData = {24'b0, Memory[DataAddress >> 2][15:8]};
                        2'b10: ReadData = {24'b0, Memory[DataAddress >> 2][23:16]};
                        2'b11: ReadData = {24'b0, Memory[DataAddress >> 2][31:24]};
                    endcase
                end

                default: ReadData = 32'b0;
            endcase
        end else begin
            ReadData = 32'b0;
        end
    end

endmodule
