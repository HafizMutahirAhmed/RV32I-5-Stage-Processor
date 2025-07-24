import RISCV_PKG::*;
module InstructionMemory(input logic EN, 
                        input string mem_file_path, 
                        input logic [INSTRUCTION_SIZE-1:0] InstructionAddress,
                        output logic [INSTRUCTION_SIZE-1:0] ReadInstruction);

    logic [WORD_LENGTH-1:0] Memory[0:MEM_ROWS - 1];

    initial begin   
        #1;
        $readmemh(mem_file_path, Memory);
    end

    always_comb begin
        if (EN) begin
            ReadInstruction = Memory[InstructionAddress>>2];
        end

        else begin
            ReadInstruction = 32'b0;
        end
// PC increments by 4 (byte-addressed), but memory is word-addressed (1 word = 4 bytes).
// So divide PC by 4 (>>2) to get the correct word index for instruction fetch.  
    end
endmodule