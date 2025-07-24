import RISCV_PKG::*;

module Memory(input logic CLK, EN, Reset, MemWrite, prevRegWrite, prevMemToReg,
              input logic [ADDRESS_PORT_WIDTH-1:0] prevWriteAddress,
              input logic [2:0] Funct3,
              input logic [WORD_LENGTH-1:0] ReadData2, prevALUResult,
              input string data_memory_path,
              output logic RegWrite, MemToReg,
              output logic [ADDRESS_PORT_WIDTH-1:0] WriteAddress,
              output logic [WORD_LENGTH-1:0] ReadData, ALUResult,
              output logic [3:0] mask_bits);  

    logic [WORD_LENGTH-1:0] iReadData;

    DataMemory DM(
        .CLK(CLK), 
        .EN(EN), 
        .MemWrite(MemWrite),
        .data_memory_path(data_memory_path),
        .Funct3(Funct3),
        .DataAddress(prevALUResult), 
        .WriteData(ReadData2),
        .mask_bits(mask_bits),
        .ReadData(iReadData) 
    );

    always_ff @(posedge CLK or posedge Reset) begin
        if (Reset) begin
            ReadData <= 32'b0;
            ALUResult <= 32'b0;
            RegWrite <= 0;
            MemToReg <= 0;
            WriteAddress <= 5'b0;
        end
        else if (EN) begin
            ReadData <= iReadData;
            ALUResult <= prevALUResult;
            RegWrite <= prevRegWrite;
            MemToReg <= prevMemToReg;
            WriteAddress <= prevWriteAddress;
        end
    end

endmodule



 