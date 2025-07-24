import RISCV_PKG::*;

module HazardDetectionUnit(input logic MemToReg, 
                           input logic [ADDRESS_PORT_WIDTH-1:0] ID_EX_RD, IF_ID_RS1, IF_ID_RS2,
                           output logic HazardDetected);
    always_comb begin
        HazardDetected = 1'b0;
        if (MemToReg && (ID_EX_RD != 0) && (ID_EX_RD == IF_ID_RS1 || ID_EX_RD == IF_ID_RS2)) begin
            HazardDetected = 1'b1;
        end
        else begin
            HazardDetected = 1'b0;
        end

    end

endmodule
