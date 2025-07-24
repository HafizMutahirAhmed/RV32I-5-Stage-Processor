import RISCV_PKG::*;

module ControlUnit(input logic [OPCODE_SIZE-1:0] Opcode, 
                   input logic ONE,
                   output logic [2:0] ALUOp,
                   output logic ID_Flush, JumpReg, Jump, Branch, RegSrc1, RegSrc2, UpperImm, RegWrite, MemWrite, MemToReg, RetAddr, imm, 
                   output logic rvfi_i_bool);

    always_comb begin
        case(Opcode)
            7'b0110011: begin 
                JumpReg = 0; 
                Branch = 0;
                Jump = 0;
                RegSrc1 = 1;
                RegSrc2 = 1;
                UpperImm = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemToReg = 0;
                RetAddr = 0;
                ALUOp = 3'b101;
                imm = 0;
                ID_Flush = 0;
                rvfi_i_bool = 1;
            end 
            
            7'b0010011: begin 
                JumpReg = 0; 
                Branch = 0;
                Jump = 0;
                RegSrc1 = 1;
                RegSrc2 = 0;
                UpperImm = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemToReg = 0;
                RetAddr = 0;
                ALUOp = 3'b000;
                imm = 1;
                ID_Flush = 0;
                rvfi_i_bool = 1;
            end 
            7'b0000011: begin 
                JumpReg = 0; 
                Branch = 0;
                Jump = 0;
                RegSrc1 = 1;
                RegSrc2 = 0;
                UpperImm = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemToReg = 1;
                RetAddr = 0;
                ALUOp = 3'b110;
                imm = 1;
                ID_Flush = 0;
                rvfi_i_bool = 1;
            end 
            7'b0100011: begin 
                JumpReg = 0; 
                Branch = 0;
                Jump = 0;
                RegSrc1 = 1;
                RegSrc2 = 0;
                UpperImm = 0;
                RegWrite = 0;
                MemWrite = 1;
                MemToReg = 0;
                RetAddr = 0;
                ALUOp = 3'b001;  
                imm = 1;
                ID_Flush = 0;
                rvfi_i_bool = 1;
            end 
            7'b1100011: begin 
                Jump = 0;
                JumpReg = 0; 
                Branch = 1;
                RegSrc1 = 1;
                RegSrc2 = 1;
                UpperImm = 0;
                RegWrite = 0;
                MemWrite = 0;
                MemToReg = 0;
                RetAddr = 0;
                ALUOp = 3'b011;  
                imm = 0;
                ID_Flush = ONE;
                rvfi_i_bool = 1;
            end 
            7'b1100111: begin 
                Jump = 1;
                JumpReg = 1; 
                Branch = 1;
                RegSrc1 = 0;
                RegSrc2 = 0;
                UpperImm = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemToReg = 0;
                RetAddr = 1;
                ALUOp = 3'b100;  
                imm = 0;
                ID_Flush = 1;
                rvfi_i_bool = 1;
            end 
            7'b1101111: begin 
                Jump = 1;
                JumpReg = 0; 
                Branch = 1;
                RegSrc1 = 0;
                RegSrc2 = 0;
                UpperImm = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemToReg = 0;
                RetAddr = 1;
                ALUOp = 3'b100;
                imm = 0;  
                ID_Flush = 1;
                rvfi_i_bool = 1;
            end 
            7'b0110111: begin 
                Jump = 0;
                JumpReg = 0; 
                Branch = 0;
                RegSrc1 = 0;
                RegSrc2 = 0;
                UpperImm = 1;
                RegWrite = 1;
                MemWrite = 0;
                MemToReg = 0;
                RetAddr = 0;
                ALUOp = 3'b010;  
                imm = 1;
                ID_Flush = 0;
                rvfi_i_bool = 1;
            end   
            7'b0010111: begin 
                Jump = 0;
                JumpReg = 0; 
                Branch = 0;
                RegSrc1 = 0;
                RegSrc2 = 0;
                UpperImm = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemToReg = 0;
                RetAddr = 0;
                ALUOp = 3'b010;  
                imm = 1;
                ID_Flush = 0;
                rvfi_i_bool = 1;
            end
            default: begin
                JumpReg   = 0;
                Jump      = 0;
                Branch    = 0;
                RegSrc1   = 0;
                RegSrc2   = 0;
                UpperImm  = 0;
                RegWrite  = 0;
                MemWrite  = 0;
                MemToReg  = 0;
                RetAddr   = 0;
                ALUOp     = 3'b000;
                imm = 0;
                ID_Flush = 0;
                rvfi_i_bool = 0;
            end
        endcase
    end

endmodule
