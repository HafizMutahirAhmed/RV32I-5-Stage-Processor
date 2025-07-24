import RISCV_PKG::*;

module InstructionDecode(
    input logic CLK, Reset, EN, MEM_WB_RegWrite, ForwardMemToRegData_RS1, ForwardMemToRegData_RS2, Forward_ID_EX_ALU_To_ID_A, Forward_ID_EX_ALU_To_ID_B, Forward_EX_MEM_ALU_To_ID_A, Forward_EX_MEM_ALU_To_ID_B,
    input logic [ADDRESS_PORT_WIDTH-1:0] prevReadReg1, prevReadReg2, MEM_WB_WriteAddress,
    input logic [OPCODE_SIZE-1:0] prevOpcode, 
    input logic [WORD_LENGTH-1:0] previousPC, ReadInstruction, WriteData, EX_ALUResult, EX_MEM_ALUResult,
    output logic [2:0] ALUOp, Func3,
    output logic [6:0] Func7,
    output logic [OPCODE_SIZE-1:0] Opcode,
    output logic [ADDRESS_PORT_WIDTH-1:0] WriteAddress, ReadReg1, ReadReg2,
    output logic [WORD_LENGTH-1:0] dataA, ReadData1, ReadData2, PC, ImmediateOutput, ImmediateOutputforPC,
    output logic ID_EX_HazardDetected, ID_Flush, ONE, imm, JumpReg, Jump, Branch, RegSrc1, MemToReg, RegSrc2, RegWrite, UpperImm, MemWrite, RetAddr, HazardDetected,
    output logic rvfi_i_bool);

    logic [2:0] iALUOp;
    logic [WORD_LENGTH-1:0] iReadData1, iReadData2, dataB;
    logic iRegSrc1, iRegSrc2, iMemToReg, iUpperImm, iRegWrite, iMemWrite, iRetAddr, iimm;
    
    ControlUnit CU(
        .Opcode(prevOpcode),
        .ONE(ONE),
        .ALUOp(iALUOp),
        .JumpReg(JumpReg),
        .Jump(Jump),
        .Branch(Branch),
        .RegSrc1(iRegSrc1),
        .RegSrc2(iRegSrc2),
        .UpperImm(iUpperImm),
        .RegWrite(iRegWrite),
        .MemWrite(iMemWrite),
        .MemToReg(iMemToReg),
        .RetAddr(iRetAddr),
        .imm(iimm),
        .ID_Flush(ID_Flush),
        .rvfi_i_bool(rvfi_i_bool)
        );

    always_comb begin
        if (HazardDetected) begin
            dataA = WriteData;
        end
        else if (Forward_ID_EX_ALU_To_ID_A) begin
            dataA = EX_ALUResult;
        end
        else if (Forward_EX_MEM_ALU_To_ID_A) begin
            dataA = EX_MEM_ALUResult;
        end
        else if (ForwardMemToRegData_RS1) begin
            dataA = WriteData;
        end
        else begin
            dataA = iReadData1;
        end

        if (HazardDetected) begin
            dataB = WriteData;
        end
        else if (Forward_ID_EX_ALU_To_ID_B) begin
            dataB = EX_ALUResult;
        end
        else if (Forward_EX_MEM_ALU_To_ID_B) begin
            dataB = EX_MEM_ALUResult;
        end
        else if (ForwardMemToRegData_RS2) begin
            dataB = WriteData;
        end      
        else begin
            dataB = iReadData2;
        end

    end

    BranchDecisionUnit BDU(
        .Opcode(prevOpcode),
        .Func3(ReadInstruction[14:12]),
        // .dataA(iReadData1), //change it later for forwarding logic(data hazard)
        // .dataB(iReadData2), //change it later for forwarding logic
        .dataA(dataA),
        .dataB(dataB),
        .ONE(ONE)
    );  

    RegisterFile RF(.CLK(CLK), 
                  .Reset(Reset), 
                  .RegWrite(MEM_WB_RegWrite), 
                  .ReadReg1(prevReadReg1), 
                  .ReadReg2(prevReadReg2),
                  .WriteAddress(MEM_WB_WriteAddress),
                  .WriteData(WriteData),
                  .ReadData1(iReadData1),
                  .ReadData2(iReadData2)
                  );

    ImmediateGenerator IG(.Instruction(ReadInstruction),
                        .ImmediateOutput(ImmediateOutputforPC));

    HazardDetectionUnit HDU(
        .MemToReg(MemToReg),
        .ID_EX_RD(WriteAddress),
        .IF_ID_RS1(prevReadReg1),
        .IF_ID_RS2(prevReadReg2),
        .HazardDetected(HazardDetected)
    );

    always_ff @(posedge CLK) begin
        if (Reset || HazardDetected) begin
            ID_EX_HazardDetected <= (Branch) ? 1 : 0; 
            RegSrc1 <= 0;
            RegSrc2 <= 0;
            UpperImm <= 0;
            MemWrite <= 0;
            RegWrite <= 0;
            MemToReg <= 0;
            RetAddr <= 0;
            ALUOp <= 3'b000;
            ReadData1 <= 32'b0;
            ReadData2 <= 32'b0;
            PC <= 32'b0;
            ImmediateOutput <= 32'b0;
            Func3 <= 3'b0;
            Func7 <= 7'b0;
            WriteAddress <= 5'b0;
            ReadReg1 <= 5'b0;
            ReadReg2 <= 5'b0;
            Opcode <= 0;
            imm <= 0;
        end
        else if (EN) begin
            ID_EX_HazardDetected <= 0;
            RegSrc1 <= iRegSrc1;
            RegSrc2 <= iRegSrc2;
            UpperImm <= iUpperImm;
            MemWrite <= iMemWrite;
            RegWrite <= iRegWrite;
            MemToReg <= iMemToReg;
            RetAddr <= iRetAddr;
            ALUOp <= iALUOp;
            ReadData1 <= (ForwardMemToRegData_RS1)? WriteData : iReadData1;
            ReadData2 <= (ForwardMemToRegData_RS2)? WriteData : iReadData2;
            PC <= previousPC;
            ImmediateOutput <= ImmediateOutputforPC;
            Func3 <= ReadInstruction[14:12];
            Func7 <= ReadInstruction[31:25];
            WriteAddress <= ReadInstruction[11:7];
            ReadReg1 <= prevReadReg1;
            ReadReg2 <= prevReadReg2;
            Opcode <= prevOpcode;
            imm <= iimm;
        end
    end
endmodule
