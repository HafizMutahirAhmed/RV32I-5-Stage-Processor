import RISCV_PKG::*;

module MainDatapath(input logic CLK, EN, Reset,
                    input string mem_file_path,
                    input string data_memory_path,
                    output        rvfi_o_valid_0,
                    output [31:0] rvfi_o_insn_0,
                    output [4:0]  rvfi_o_rs1_addr_0,
                    output [4:0]  rvfi_o_rs2_addr_0,
                    output [31:0] rvfi_o_rs1_rdata_0,
                    output [31:0] rvfi_o_rs2_rdata_0,
                    output [4:0]  rvfi_o_rd_addr_0,
                    output [31:0] rvfi_o_rd_wdata_0,
                    output [31:0] rvfi_o_pc_rdata_0,
                    output [31:0] rvfi_o_pc_wdata_0,
                    output [31:0] rvfi_o_mem_addr_0,
                    output [3:0]  rvfi_o_mem_wmask_0,
                    output [31:0] rvfi_o_mem_rdata_0,
                    output [31:0] rvfi_o_mem_wdata_0);
    

                    // Tracer rvfi);
    // logic [63:0] instruction_counter = 0;
    logic [WORD_LENGTH-1:0] IF_PC, IF_Instruction, prevPC;
    logic [WORD_LENGTH-1:0] ReadData1_TO_IF, ID_PC, ID_ImmediateOutput, ImmediateOutputforPC, ID_ReadData1, ID_ReadData2;
    logic [WORD_LENGTH-1:0] iALUResult, EX_ALUResult, EX_ReadData2, EX_ReadData1, EX_ImmediateOutput;
    logic [WORD_LENGTH-1:0] MEM_ReadData, MEM_ALUResult;
    logic [WORD_LENGTH-1:0] WB_WriteData;
    logic ID_EX_HazardDetected;
    logic ID_ValidInstruction, ID_Flush, ID_imm, ID_JumpReg, ID_Jump, ID_Branch, ID_RegSrc1, ID_RegSrc2, ID_UpperImm, ID_RegWrite, ID_MemWrite, ID_MemToReg, ID_RetAddr, HazardDetected, ID_ONE;
    logic EX_RegWrite, EX_MemWrite, EX_MemToReg;
    logic MEM_RegWrite, MEM_MemToReg;
    logic ForwardMemToRegData_RS1, ForwardMemToRegData_RS2, Forward_ID_EX_ALU_To_ID_A, Forward_ID_EX_ALU_To_ID_B, Forward_EX_MEM_ALU_To_ID_A, Forward_EX_MEM_ALU_To_ID_B;

    logic [2:0] ID_Func3, EX_Func3, ID_ALUOp;
    logic [3:0] mask_bits;
    logic [6:0] ID_Func7;
    logic [OPCODE_SIZE-1:0] ID_Opcode;
    logic [ADDRESS_PORT_WIDTH-1:0] ID_WriteAddress, EX_WriteAddress, MEM_WriteAddress;
    logic [ADDRESS_PORT_WIDTH-1:0] ID_ReadReg1, ID_ReadReg2;

    //Signals for Tracer
    logic rvfi_i_bool;
    logic  [3:0]  rvfi_i_uint4;
    logic  [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_0;
    logic  [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_1;
    logic  [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_2;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_0;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_1;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_2;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_3;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_4;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_5;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_6;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_7;
    logic  [WORD_LENGTH-1:0] rvfi_i_uint32_8;

    // logic rvfi_o_valid_0;
    // logic [31:0] rvfi_o_insn_0;
    // logic [4:0]  rvfi_o_rs1_addr_0;
    // logic [4:0]  rvfi_o_rs2_addr_0;
    // logic [31:0] rvfi_o_rs1_rdata_0;
    // logic [31:0] rvfi_o_rs2_rdata_0;
    // logic [4:0]  rvfi_o_rd_addr_0;
    // logic [31:0] rvfi_o_rd_wdata_0;
    // logic [31:0] rvfi_o_pc_rdata_0;
    // logic [31:0] rvfi_o_pc_wdata_0;
    // logic [31:0] rvfi_o_mem_addr_0;
    // logic [3:0]  rvfi_o_mem_wmask_0;
    // logic [31:0] rvfi_o_mem_rdata_0;
    // logic [31:0] rvfi_o_mem_wdata_0;
    

    TracerPipelineRegister TPR(
        .CLK(CLK),
        .ID_ValidInstruction(ID_ValidInstruction),
        .IF_Instruction(IF_Instruction),
        .ID_ReadReg1(ID_ReadReg1),
        .ID_ReadReg2(ID_ReadReg2),
        .ID_ReadData1(ID_ReadData1),
        .ID_ReadData2(ID_ReadData2),
        .MEM_WriteAddress(MEM_WriteAddress), //RD ADDRESS
        .WB_WriteData(WB_WriteData), //RD DATA
        .IF_ID_PC(IF_PC), //PC read data
        .IF_PC(prevPC), //PC write data
        .MEM_ReadData(MEM_ReadData), //MEM READ
        .MEM_ReadAddress(EX_ALUResult), //MEM ADDRESS
        .MEM_WriteData(EX_ReadData2), //MEM WRITE
        .MEM_mask_bits(mask_bits), //WRITE MASK

        .ID_EX_HazardDetected(ID_EX_HazardDetected),
        .HazardDetected(HazardDetected),
        
        .rvfi_i_bool(rvfi_i_bool), // VALID INSTRUCTION
        .rvfi_i_uint32_0(rvfi_i_uint32_0), //INSTRUCTION
        .rvfi_i_uint32_1(rvfi_i_uint32_1), //READDATA1
        .rvfi_i_uint32_2(rvfi_i_uint32_2), //READDATA2
        .rvfi_i_uint32_3(rvfi_i_uint32_3), //RD DATA
        .rvfi_i_uint5_0(rvfi_i_uint5_0), //RS1 ADDRESS
        .rvfi_i_uint5_1(rvfi_i_uint5_1), //RS2 ADDRESS
        .rvfi_i_uint5_2(rvfi_i_uint5_2), //RD ADDRESS
        .rvfi_i_uint32_4(rvfi_i_uint32_4), //PC read data
        .rvfi_i_uint32_5(rvfi_i_uint32_5), //PC write data
        .rvfi_i_uint32_6(rvfi_i_uint32_6), //MEM ADDRESS
        .rvfi_i_uint32_7(rvfi_i_uint32_7), //MEM READ
        .rvfi_i_uint32_8(rvfi_i_uint32_8), //MEM WRITE
        .rvfi_i_uint4(rvfi_i_uint4) //WRITE MASK
    );

    Tracer TRACER(
        .rvfi_i_bool(rvfi_i_bool), // VALID INSTRUCTION
        .rvfi_i_uint32_0(rvfi_i_uint32_0), //INSTRUCTION
        .rvfi_i_uint32_1(rvfi_i_uint32_1), //READDATA1
        .rvfi_i_uint32_2(rvfi_i_uint32_2), //READDATA2
        .rvfi_i_uint32_3(rvfi_i_uint32_3), //RD DATA
        .rvfi_i_uint5_0(rvfi_i_uint5_0), //RS1 ADDRESS
        .rvfi_i_uint5_1(rvfi_i_uint5_1), //RS2 ADDRESS
        .rvfi_i_uint5_2(rvfi_i_uint5_2), //RD ADDRESS
        .rvfi_i_uint32_4(rvfi_i_uint32_4), //PC read data
        .rvfi_i_uint32_5(rvfi_i_uint32_5), //PC write data
        .rvfi_i_uint32_6(rvfi_i_uint32_6), //MEM ADDRESS
        .rvfi_i_uint32_7(rvfi_i_uint32_7), //MEM READ
        .rvfi_i_uint32_8(rvfi_i_uint32_8), //MEM WRITE
        .rvfi_i_uint4(rvfi_i_uint4), //WRITE MASK

        .rvfi_o_valid_0(rvfi_o_valid_0),
        .rvfi_o_insn_0(rvfi_o_insn_0),
        .rvfi_o_rs1_addr_0(rvfi_o_rs1_addr_0),
        .rvfi_o_rs2_addr_0(rvfi_o_rs2_addr_0),
        .rvfi_o_rs1_rdata_0(rvfi_o_rs1_rdata_0),
        .rvfi_o_rs2_rdata_0(rvfi_o_rs2_rdata_0),
        .rvfi_o_rd_addr_0(rvfi_o_rd_addr_0),
        .rvfi_o_rd_wdata_0(rvfi_o_rd_wdata_0),
        .rvfi_o_pc_rdata_0(rvfi_o_pc_rdata_0),
        .rvfi_o_pc_wdata_0(rvfi_o_pc_wdata_0),
        .rvfi_o_mem_addr_0(rvfi_o_mem_addr_0),
        .rvfi_o_mem_wmask_0(rvfi_o_mem_wmask_0),
        .rvfi_o_mem_rdata_0(rvfi_o_mem_rdata_0),
        .rvfi_o_mem_wdata_0(rvfi_o_mem_wdata_0)
    );

    InstructionFetch IF_STAGE (
        .CLK(CLK),
        .EN(EN),
        .ONE(ID_ONE),
        .Reset(Reset),
        .Forward_ID_EX_ALU_To_ID_A(Forward_ID_EX_ALU_To_ID_A),
        .Forward_EX_MEM_ALU_To_ID_A(Forward_EX_MEM_ALU_To_ID_A),
        .ForwardMemToRegData_RS1(ForwardMemToRegData_RS1),
        .WriteData(WB_WriteData),
        .EX_ALUResult(iALUResult),
        .EX_MEM_ALUResult(EX_ALUResult),
        .JumpReg(ID_JumpReg),
        .Jump(ID_Jump),
        .Branch(ID_Branch),
        .ImmediateOutput(ImmediateOutputforPC),
        .IF_ID_ReadData1(ReadData1_TO_IF),
        .ReadData1(EX_ReadData1),
        .Instruction(IF_Instruction),
        .PC(IF_PC),
        .PCcomputed(prevPC),
        .RetainPC(HazardDetected || ID_EX_HazardDetected),
        .RetainIF_ID(HazardDetected || ID_EX_HazardDetected),
        .IF_Flush(ID_Flush),
        .mem_file_path(mem_file_path)
    );

    InstructionDecode ID_STAGE (
        .CLK(CLK),
        .Reset(Reset),
        .EN(EN),
        .ID_Flush(ID_Flush),
        .MEM_WB_RegWrite(MEM_RegWrite),
        .ID_EX_HazardDetected(ID_EX_HazardDetected),
        .prevReadReg1(IF_Instruction[19:15]),
        .prevReadReg2(IF_Instruction[24:20]),
        .MEM_WB_WriteAddress(MEM_WriteAddress),
        .prevOpcode(IF_Instruction[6:0]),
        .ForwardMemToRegData_RS1(ForwardMemToRegData_RS1),
        .ForwardMemToRegData_RS2(ForwardMemToRegData_RS2),
        .Forward_ID_EX_ALU_To_ID_A(Forward_ID_EX_ALU_To_ID_A), 
        .Forward_ID_EX_ALU_To_ID_B(Forward_ID_EX_ALU_To_ID_B), 
        .Forward_EX_MEM_ALU_To_ID_A(Forward_EX_MEM_ALU_To_ID_A), 
        .Forward_EX_MEM_ALU_To_ID_B(Forward_EX_MEM_ALU_To_ID_B),
        .Opcode(ID_Opcode),
        .previousPC(IF_PC),
        .ReadInstruction(IF_Instruction),
        .WriteData(WB_WriteData),
        .EX_ALUResult(iALUResult),
        .EX_MEM_ALUResult(EX_ALUResult),
        .ALUOp(ID_ALUOp),
        .Func3(ID_Func3),
        .Func7(ID_Func7),
        .WriteAddress(ID_WriteAddress),
        .ReadReg1(ID_ReadReg1),
        .ReadReg2(ID_ReadReg2),
        .ReadData1(ID_ReadData1),
        .ReadData2(ID_ReadData2),
        .dataA(ReadData1_TO_IF),
        .PC(ID_PC),
        .ImmediateOutput(ID_ImmediateOutput),
        .ImmediateOutputforPC(ImmediateOutputforPC),
        .JumpReg(ID_JumpReg),
        .Jump(ID_Jump),
        .Branch(ID_Branch),
        .RegSrc1(ID_RegSrc1),
        .MemToReg(ID_MemToReg),
        .RegSrc2(ID_RegSrc2),
        .RegWrite(ID_RegWrite),
        .UpperImm(ID_UpperImm),
        .MemWrite(ID_MemWrite),
        .RetAddr(ID_RetAddr),
        .HazardDetected(HazardDetected),
        .imm(ID_imm),
        .ONE(ID_ONE),
        .rvfi_i_bool(ID_ValidInstruction)
    );

    Execute EX_STAGE (
        .CLK(CLK),
        .EN(EN),
        .Reset(Reset),
        .Opcode(ID_Opcode),
        .UpperImm(ID_UpperImm),
        .imm(ID_imm),
        .RetAddr(ID_RetAddr),
        .RegSrc1(ID_RegSrc1),
        .RegSrc2(ID_RegSrc2),
        .ID_EX_HazardDetected(ID_EX_HazardDetected),
        .MEM_WB_WriteAddress(MEM_WriteAddress),
        .MEM_WB_MemToReg(MEM_MemToReg),
        .MEM_WB_RegWrite(MEM_RegWrite),
        .ID_RS1(IF_Instruction[19:15]),
        .ID_RS2(IF_Instruction[24:20]),
        .prevMemToReg(ID_MemToReg),
        .prevRegWrite(ID_RegWrite),
        .prevMemWrite(ID_MemWrite),
        .prevWriteAddress(ID_WriteAddress),
        .prevReadReg1(ID_ReadReg1),
        .prevReadReg2(ID_ReadReg2),
        .PC(ID_PC),
        .ReadData1(ID_ReadData1),
        .previousReadData2(ID_ReadData2),
        .ImmediateOutput(ID_ImmediateOutput),
        .prevFunc3(ID_Func3),
        .WB_WriteData(WB_WriteData),
        .ALUOp(ID_ALUOp),
        .Func7(ID_Func7),
        .Func3(EX_Func3),
        .ALUResult(EX_ALUResult),
        .iALUResult(iALUResult),
        .ReadData2(EX_ReadData2),
        .MemToReg(EX_MemToReg),
        .RegWrite(EX_RegWrite),
        .MemWrite(EX_MemWrite),
        .exReadData1(EX_ReadData1),
        .exImmediateOutput(EX_ImmediateOutput),
        .WriteAddress(EX_WriteAddress),
        .ForwardMemToRegData_RS1(ForwardMemToRegData_RS1),
        .ForwardMemToRegData_RS2(ForwardMemToRegData_RS2),
        .Forward_ID_EX_ALU_To_ID_A(Forward_ID_EX_ALU_To_ID_A), 
        .Forward_ID_EX_ALU_To_ID_B(Forward_ID_EX_ALU_To_ID_B), 
        .Forward_EX_MEM_ALU_To_ID_A(Forward_EX_MEM_ALU_To_ID_A), 
        .Forward_EX_MEM_ALU_To_ID_B(Forward_EX_MEM_ALU_To_ID_B),
        .HazardDetected(HazardDetected)
    );

    Memory MEM_STAGE (
        .CLK(CLK),
        .prevWriteAddress(EX_WriteAddress),
        .EN(EN),
        .Reset(Reset),
        .data_memory_path(data_memory_path),
        .MemWrite(EX_MemWrite),
        .prevRegWrite(EX_RegWrite),
        .prevMemToReg(EX_MemToReg),
        .Funct3(EX_Func3),
        .ReadData2(EX_ReadData2),
        .prevALUResult(EX_ALUResult),
        .RegWrite(MEM_RegWrite),
        .MemToReg(MEM_MemToReg),
        .ReadData(MEM_ReadData),
        .ALUResult(MEM_ALUResult),
        .mask_bits(mask_bits),
        .WriteAddress(MEM_WriteAddress)
    );

    WriteBack WB_STAGE (
        .CLK(CLK),
        .MemToReg(MEM_MemToReg),
        .ReadData(MEM_ReadData),
        .ALUResult(MEM_ALUResult),
        .WriteData(WB_WriteData)
    );


//     always_ff @(posedge CLK or posedge Reset) begin
//         if (Reset)
//             instruction_counter <= 0;
//         else
//             instruction_counter <= instruction_counter + 1;
//     end

//     logic illegal_instruction;
//     logic [3:0] mask_bits;
//     logic [3:0] final_mask_bits;
    
//     always_comb begin
//         case (Opcode)
//             7'b0110011, // R-type
//             7'b0010011, // I-type
//             7'b0000011, // Loads
//             7'b0100011, // Stores
//             7'b1100011, // Branches
//             7'b1101111, // JAL
//             7'b1100111, // JALR
//             7'b0110111, // LUI
//             7'b0010111: // AUIPC
//                 illegal_instruction = 1'b0;
//             default:
//                 illegal_instruction = 1'b1;
//         endcase
//         rvfi.trap  = illegal_instruction;
//         rvfi.valid = ~illegal_instruction && (Reset == 0);
    
//         case (Func3)
//             3'b000: mask_bits = 4'b0001; // Byte
//             3'b001: mask_bits = 4'b0011; // Half-word
//             3'b010: mask_bits = 4'b1111; // Word
//             default: mask_bits = 4'b0000;
//         endcase
        
//         final_mask_bits = mask_bits << ALUResult[1:0];

//         rvfi.mem_wmask = MemWrite ? final_mask_bits : 4'b0000;
    

//         if (~MemWrite && MemToReg) 
//             rvfi.mem_rmask = final_mask_bits;  // Use final_mask_bits only for load operations
//         else 
//             rvfi.mem_rmask = 4'b0000;  // For store operations, set to 0000 (no read mask)
    
//         rvfi.order     = instruction_counter;
//         rvfi.insn      = ReadInstruction;
    
//         rvfi.rs1_addr  = RS1;
//         rvfi.rs2_addr  = RS2;
//         rvfi.rs1_rdata = ReadData1;                     // Data from RS1 before execution
//         rvfi.rs2_rdata = ReadData2;                     // Data from RS2 before execution
    
//         rvfi.rd_addr   = RD;
//         rvfi.rd_wdata  = (MemToReg) ? ReadData : ALUResult;  // Data written to RD after execution
    
//         // Program Counter Read/Write
//         rvfi.pc_rdata  = PC;                           // PC before instruction execution
//         rvfi.pc_wdata  = PC + 4;                       // PC after instruction execution
    
//         // Memory Access
//         rvfi.mem_addr  = ALUResult;                     // Memory access address (ALU result)
//         rvfi.mem_wdata = ReadData2;                     // Memory write data
//         rvfi.mem_rdata = ReadData;                      // Memory read data
 

//         // Memory Write/Read Masks
//         rvfi.mem_wmask = MemWrite ? final_mask_bits : 4'b0000;  // Write mask for memory
//         rvfi.mem_rmask = (MemWrite) ? 4'b0000 : final_mask_bits; // Read mask for memory during load operations

//     end
endmodule
