import RISCV_PKG::*;

module WriteBack(input logic CLK, MemToReg,
                input logic [WORD_LENGTH-1:0] ReadData, ALUResult,
                output logic [WORD_LENGTH-1:0] WriteData);
            
    always_comb begin 
        WriteData = (MemToReg) ? ReadData : ALUResult;
    end
    
endmodule