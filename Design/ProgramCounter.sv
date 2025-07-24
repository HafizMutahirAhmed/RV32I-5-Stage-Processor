import RISCV_PKG::*;

module ProgramCounter(input logic CLK, Reset, JumpReg, Jump, Branch, ONE, RetainPC,
                      input logic [31:0] ImmediateOutput, ReadData1, IF_ID_PC,
                      input logic [WORD_LENGTH-1:0] IF_ID_ReadData1,
                      output logic signed [31:0] PC);
    
    always_ff @(posedge CLK or posedge Reset) begin
        if (Reset) begin
            PC <= -4;
        end
        else begin
            PC <= ((JumpReg)? IF_ID_ReadData1: ((Jump||(Branch && ONE))? IF_ID_PC: PC))  +  ((RetainPC) ? 32'b0 : ((Jump||(Branch && ONE))? ImmediateOutput: 32'd4)); 
        end
    end
endmodule
