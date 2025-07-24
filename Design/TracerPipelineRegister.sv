module TracerPipelineRegister (
    input logic CLK, ID_ValidInstruction, ID_EX_HazardDetected, HazardDetected,
    input logic [WORD_LENGTH-1:0] IF_Instruction, ID_ReadData1, ID_ReadData2, WB_WriteData, IF_ID_PC, 
    input logic [WORD_LENGTH-1:0] IF_PC, MEM_ReadData, MEM_WriteData, MEM_ReadAddress,
    input logic [ADDRESS_PORT_WIDTH-1:0] ID_ReadReg1, ID_ReadReg2, MEM_WriteAddress,
    input logic [3:0] MEM_mask_bits,
    output  rvfi_i_bool,
    output  [3:0]  rvfi_i_uint4,
    output  [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_0,
    output  [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_1,
    output  [ADDRESS_PORT_WIDTH-1:0]  rvfi_i_uint5_2,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_0,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_1,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_2,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_3,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_4,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_5,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_6,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_7,
    output  [WORD_LENGTH-1:0] rvfi_i_uint32_8);

    logic ID_EX_ValidInstruction, EX_MEM_ValidInstruction, MEM_WB_ValidInstruction;
    logic [WORD_LENGTH-1:0] EX_MEM_ReadData1, MEM_WB_ReadData1;
    logic [WORD_LENGTH-1:0] EX_MEM_ReadData2, MEM_WB_ReadData2;
    logic [WORD_LENGTH-1:0] ID_EX_Instruction, EX_MEM_Instruction, MEM_WB_Instruction;
    logic [WORD_LENGTH-1:0] ID_EX_previousPC, EX_MEM_previousPC, MEM_WB_previousPC;
    logic [WORD_LENGTH-1:0] ID_EX_nextPC, EX_MEM_nextPC, MEM_WB_nextPC;
    logic [WORD_LENGTH-1:0] MEM_WB_ReadAddress;
    logic [ADDRESS_PORT_WIDTH-1:0] EX_MEM_ReadReg1, MEM_WB_ReadReg1;
    logic [ADDRESS_PORT_WIDTH-1:0] EX_MEM_ReadReg2, MEM_WB_ReadReg2;


    //ID/EX Register
    always_ff @(posedge CLK) begin
        ID_EX_ValidInstruction <= (HazardDetected)? 0: ID_ValidInstruction;
        ID_EX_Instruction <= IF_Instruction;
        ID_EX_previousPC <= IF_ID_PC;
        ID_EX_nextPC <= IF_PC;
    end
    //EX/MEM Register
    always_ff @(posedge CLK) begin
        EX_MEM_ValidInstruction <= (ID_EX_HazardDetected)? 0: ID_EX_ValidInstruction;
        EX_MEM_ReadData1 <= ID_ReadData1;
        EX_MEM_ReadData2 <= ID_ReadData2;
        EX_MEM_Instruction <= ID_EX_Instruction;
        EX_MEM_previousPC <= ID_EX_previousPC;
        EX_MEM_nextPC <= ID_EX_nextPC;
        EX_MEM_ReadReg1 <= ID_ReadReg1;
        EX_MEM_ReadReg2 <= ID_ReadReg2;
    end
    //MEM/WB Register
    always_ff @(posedge CLK) begin
        rvfi_i_bool <= EX_MEM_ValidInstruction;
        rvfi_i_uint32_1 <= EX_MEM_ReadData1;
        rvfi_i_uint32_2 <= EX_MEM_ReadData2;
        rvfi_i_uint32_0 <= EX_MEM_Instruction;
        rvfi_i_uint32_4 <= EX_MEM_previousPC;
        rvfi_i_uint32_5 <= EX_MEM_nextPC;
        rvfi_i_uint32_6 <= MEM_ReadAddress;
        rvfi_i_uint5_0 <= EX_MEM_ReadReg1;
        rvfi_i_uint5_1 <= EX_MEM_ReadReg2;
        rvfi_i_uint32_8 <= MEM_WriteData;
        
    end
    always_comb begin
        rvfi_i_uint4 = MEM_mask_bits;
        rvfi_i_uint32_3 = WB_WriteData;
        rvfi_i_uint32_7 = MEM_ReadData; 
        rvfi_i_uint5_2 = MEM_WriteAddress;
    end
endmodule