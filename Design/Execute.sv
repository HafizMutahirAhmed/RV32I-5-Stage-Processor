import RISCV_PKG::*;

module Execute(input logic CLK, EN, Reset, ID_EX_HazardDetected, HazardDetected, imm, MEM_WB_MemToReg, MEM_WB_RegWrite, UpperImm, RetAddr, RegSrc1, RegSrc2, prevMemToReg, prevRegWrite, prevMemWrite,
               input logic [WORD_LENGTH-1:0] PC, ReadData1, previousReadData2, ImmediateOutput, WB_WriteData,
               input logic [ADDRESS_PORT_WIDTH-1:0] ID_RS1, ID_RS2, prevWriteAddress, MEM_WB_WriteAddress, prevReadReg1, prevReadReg2,
               input logic [2:0] prevFunc3, ALUOp, 
               input logic [OPCODE_SIZE-1:0] Opcode,
               input logic [6:0] Func7,
               output logic [2:0] Func3,
               output logic [WORD_LENGTH-1:0] ALUResult, ReadData2, exReadData1, exImmediateOutput, iALUResult,
               output logic [ADDRESS_PORT_WIDTH-1:0] WriteAddress,
               output logic MemToReg, RegWrite, MemWrite, ForwardMemToRegData_RS1, ForwardMemToRegData_RS2, Forward_ID_EX_ALU_To_ID_A, Forward_ID_EX_ALU_To_ID_B, Forward_EX_MEM_ALU_To_ID_A, Forward_EX_MEM_ALU_To_ID_B);

    logic [3:0] ALUOperation;
    logic [WORD_LENGTH-1:0] DataA, DataB, FinalReadData2;   
    logic ForwardALU_A, ForwardALU_B, ForwardMemToRegData_A, ForwardMemToRegData_B;
    // logic StoreInstruction = (Opcode == 7'b0100011);
    always_comb begin
        if (UpperImm) begin
            DataA = 32'b0;
        end
        else if (RetAddr) begin 
            DataA = PC;
        end
        else if (ForwardALU_A) begin
            DataA = ALUResult;
        end

        else if (ForwardMemToRegData_A && (Opcode != 7'b1100111)) begin
            DataA = WB_WriteData;
        end
        else if (RegSrc1) begin
            DataA = ReadData1;
        end
        else begin
            DataA = PC;
        end
        
    end

    always_comb begin
        FinalReadData2 = previousReadData2;
        DataB = 0;    
        if (ForwardALU_B) begin
            FinalReadData2 = ALUResult;
        end
        else if (ForwardMemToRegData_B) begin
            FinalReadData2 = WB_WriteData;
        end

        if(imm) begin
            DataB = ImmediateOutput;
        end    

        else if (RetAddr) begin
            DataB = 4;
        end 
        else if (RegSrc2) begin
            DataB = FinalReadData2;
        end
    end
    
    
    ALUControl ALUCU(.ALUOp(ALUOp),
                .func3(prevFunc3),
                .func7(Func7),
                .ALUOperation(ALUOperation));
                  
    ALU ALU(
        .dataA(DataA),
        .dataB(DataB),
        .ALUOperation(ALUOperation),
        .ALUOutput(iALUResult)        
        );

    ForwardingUnit FU(
        .EX_MEM_RD(WriteAddress),
        .MEM_WB_RD(MEM_WB_WriteAddress),
        .ID_EX_RS1(prevReadReg1),
        .ID_EX_RS2(prevReadReg2),
        .ID_RS1(ID_RS1),
        .ID_RS2(ID_RS2),
        .ID_EX_RD(prevWriteAddress),
        .ID_EX_RegWrite(prevRegWrite),
        .EX_MEM_RegWrite(RegWrite),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .MemToReg(MEM_WB_MemToReg),
        .ForwardALU_A(ForwardALU_A),
        .ForwardALU_B(ForwardALU_B),
        .ForwardMemToRegData_A(ForwardMemToRegData_A),
        .ForwardMemToRegData_B(ForwardMemToRegData_B),
        .ForwardMemToRegData_RS1(ForwardMemToRegData_RS1),
        .ForwardMemToRegData_RS2(ForwardMemToRegData_RS2),
        .Forward_ID_EX_ALU_To_ID_A(Forward_ID_EX_ALU_To_ID_A),
        .Forward_ID_EX_ALU_To_ID_B(Forward_ID_EX_ALU_To_ID_B),
        .Forward_EX_MEM_ALU_To_ID_A(Forward_EX_MEM_ALU_To_ID_A),
        .Forward_EX_MEM_ALU_To_ID_B(Forward_EX_MEM_ALU_To_ID_B)
        );

    always_ff @(posedge CLK) begin
        if (Reset || ID_EX_HazardDetected) begin
            MemWrite <= 1'b0;
            RegWrite <= 1'b0;
            MemToReg <= 1'b0;
            ALUResult <= 32'b0;
            ReadData2 <= 32'b0;   
            Func3 <= 3'b0;
            exReadData1 <= 32'b0;
            exImmediateOutput <= 32'b0;
            WriteAddress <= 5'b0;
        end

        else if (EN) begin
            MemWrite <= prevMemWrite;
            RegWrite <= prevRegWrite;
            MemToReg <= prevMemToReg;
            ALUResult <= iALUResult;
            ReadData2 <= FinalReadData2;
            Func3 <= prevFunc3;
            exReadData1 <= ReadData1;
            exImmediateOutput <= ImmediateOutput;
            WriteAddress <= prevWriteAddress;
        end
    end
endmodule
