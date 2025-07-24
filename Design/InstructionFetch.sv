import RISCV_PKG::*;

module InstructionFetch(input logic IF_Flush, CLK, EN, ONE, Reset, JumpReg, Jump, Branch, RetainPC, RetainIF_ID,
                        input logic Forward_ID_EX_ALU_To_ID_A, Forward_EX_MEM_ALU_To_ID_A, ForwardMemToRegData_RS1,
                        input logic [WORD_LENGTH-1:0] ImmediateOutput, ReadData1, WriteData,EX_ALUResult,EX_MEM_ALUResult,
                        input string mem_file_path,
                        input logic [WORD_LENGTH-1:0] IF_ID_ReadData1,
                        output logic [INSTRUCTION_SIZE-1:0] Instruction, PC, PCcomputed
                        );

    logic [INSTRUCTION_SIZE-1:0] InstructionFetched;
    logic [WORD_LENGTH-1:0] ForwardedRS1;

    always_comb begin
        if (Forward_ID_EX_ALU_To_ID_A) begin
            ForwardedRS1 = EX_ALUResult;
        end
        else if (Forward_EX_MEM_ALU_To_ID_A) begin
            ForwardedRS1 = EX_MEM_ALUResult;
        end
        else if (ForwardMemToRegData_RS1) begin
            ForwardedRS1 = WriteData;
        end
        else begin
            ForwardedRS1 = IF_ID_ReadData1;
        end
    end

    ProgramCounter ProgCount(
            .CLK(CLK),
            .Reset(Reset),
            .JumpReg(JumpReg),
            .Jump(Jump),
            .Branch(Branch),
            .IF_ID_PC(PC),
            .ONE(ONE),
            .ImmediateOutput(ImmediateOutput),
            .IF_ID_ReadData1(ForwardedRS1),
            .ReadData1(ReadData1),
            .PC(PCcomputed),
            .RetainPC(RetainPC)
        );
    InstructionMemory IM(
        .EN(EN),
        .InstructionAddress(PCcomputed),
        .ReadInstruction(InstructionFetched),
        .mem_file_path(mem_file_path)
    );
    always_ff @(posedge CLK or posedge Reset) begin
        if (Reset || IF_Flush) begin
            Instruction <= 32'b0;
            PC <= 32'b0;
        end
        else if (EN && !RetainIF_ID) begin
            Instruction <= InstructionFetched;
            PC <= PCcomputed;
        end
    end
endmodule