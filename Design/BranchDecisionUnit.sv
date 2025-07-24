import RISCV_PKG::*;

module BranchDecisionUnit(input logic [OPCODE_SIZE-1:0] Opcode, 
                          input logic [WORD_LENGTH-1:0] dataA, dataB,
                          input logic [2:0] Func3,
                          output logic ONE);
    always_comb begin
        case({Opcode, Func3}) 
            10'b1100011_000: ONE = ($signed(dataA) == $signed(dataB));
            10'b1100011_001: ONE = ($signed(dataA) != $signed(dataB));
            10'b1100011_100: ONE = ($signed(dataA) < $signed(dataB));
            10'b1100011_101: ONE = ($signed(dataA) >= $signed(dataB));
            10'b1100011_110: ONE = (dataA < dataB);
            10'b1100011_111: ONE = (dataA >= dataB);
            default: ONE = 1'b0;
        endcase
    end
endmodule