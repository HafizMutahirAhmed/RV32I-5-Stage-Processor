import RISCV_PKG::*;

module ForwardingUnit(input logic [ADDRESS_PORT_WIDTH-1:0] ID_EX_RD, EX_MEM_RD, MEM_WB_RD, ID_RS1, ID_RS2, ID_EX_RS1, ID_EX_RS2,
                      input logic ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite, MemToReg,
                      output logic ForwardALU_A, ForwardALU_B, ForwardMemToRegData_A, ForwardMemToRegData_B, ForwardMemToRegData_RS1, ForwardMemToRegData_RS2, Forward_EX_MEM_ALU_To_ID_A, Forward_EX_MEM_ALU_To_ID_B, Forward_ID_EX_ALU_To_ID_A, Forward_ID_EX_ALU_To_ID_B);
    
    always_comb begin
        ForwardALU_A = 1'b0;
        ForwardALU_B = 1'b0;
        ForwardMemToRegData_A = 1'b0;
        ForwardMemToRegData_B = 1'b0; 
        ForwardMemToRegData_RS1 = 1'b0;
        ForwardMemToRegData_RS2 = 1'b0;
        Forward_EX_MEM_ALU_To_ID_A = 1'b0;
        Forward_EX_MEM_ALU_To_ID_B = 1'b0;
        Forward_ID_EX_ALU_To_ID_A = 1'b0;
        Forward_ID_EX_ALU_To_ID_B = 1'b0;

        if (EX_MEM_RD == ID_EX_RS1 && EX_MEM_RegWrite && EX_MEM_RD != 0) begin
            ForwardALU_A = 1'b1;
        end
        if (EX_MEM_RD == ID_EX_RS2 && EX_MEM_RegWrite && EX_MEM_RD != 0) begin
            ForwardALU_B = 1'b1;
        end
        if (MEM_WB_RD == ID_EX_RS1 && MEM_WB_RegWrite && MEM_WB_RD != 0) begin
            ForwardMemToRegData_A = 1'b1;
        end
        if (MEM_WB_RD == ID_EX_RS2 && MEM_WB_RegWrite && MEM_WB_RD != 0) begin
            ForwardMemToRegData_B = 1'b1;
        end
        if (MEM_WB_RD == ID_RS1 && MEM_WB_RegWrite && MEM_WB_RD != 0) begin
            ForwardMemToRegData_RS1 = 1'b1;
        end
        if (MEM_WB_RD == ID_RS2 && MEM_WB_RegWrite && MEM_WB_RD != 0) begin
            ForwardMemToRegData_RS2 = 1'b1;
        end
        if (EX_MEM_RD == ID_RS1 && EX_MEM_RegWrite && EX_MEM_RD !=0) begin
            Forward_EX_MEM_ALU_To_ID_A = 1'b1;
        end
        if (EX_MEM_RD == ID_RS2 && EX_MEM_RegWrite && EX_MEM_RD !=0) begin
            Forward_EX_MEM_ALU_To_ID_B = 1'b1;
        end
        if (ID_EX_RD == ID_RS1 && ID_EX_RegWrite && ID_EX_RD !=0) begin
            Forward_ID_EX_ALU_To_ID_A = 1'b1;
        end
        if (ID_EX_RD == ID_RS2 && ID_EX_RegWrite && ID_EX_RD !=0) begin
            Forward_ID_EX_ALU_To_ID_B = 1'b1;
        end
    end 
    
endmodule
