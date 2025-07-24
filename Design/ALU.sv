import RISCV_PKG::*;

module ALU(input logic [REG_WIDTH-1:0] dataA, dataB,
           input logic [3:0] ALUOperation,
           output logic [REG_WIDTH-1:0] ALUOutput);
    always_comb begin
        case(ALUOperation)
            4'b0000: ALUOutput = dataA | dataB;
            4'b0001: ALUOutput = dataA & dataB;
            4'b0010: ALUOutput = dataA + dataB;
            4'b0011: ALUOutput = dataA - dataB;
            4'b0101: ALUOutput = {31'b0, ($signed(dataA) < $signed(dataB))};
            4'b1000: ALUOutput = dataA << dataB[4:0];
            4'b1001: ALUOutput = dataA ^ dataB;
            4'b1010: ALUOutput = $unsigned(dataA) >> dataB[4:0];
            4'b1011: ALUOutput = $signed(dataA) >>> dataB[4:0];
            4'b1101: ALUOutput = {31'b0, (dataA < dataB)};
            default: ALUOutput = 32'b0;
        endcase
    end
endmodule
