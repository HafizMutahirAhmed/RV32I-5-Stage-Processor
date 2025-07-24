module MainDatapath_TestBench;

    logic CLK, Reset, EN;
    string mem_file_path, data_memory_path;
    logic [31:0] sim_time = 0;


    logic rvfi_o_valid_0;
    logic [31:0] rvfi_o_insn_0;
    logic [4:0]  rvfi_o_rs1_addr_0;
    logic [4:0]  rvfi_o_rs2_addr_0;
    logic [31:0] rvfi_o_rs1_rdata_0;
    logic [31:0] rvfi_o_rs2_rdata_0;
    logic [4:0]  rvfi_o_rd_addr_0;
    logic [31:0] rvfi_o_rd_wdata_0;
    logic [31:0] rvfi_o_pc_rdata_0;
    logic [31:0] rvfi_o_pc_wdata_0;
    logic [31:0] rvfi_o_mem_addr_0;
    logic [3:0]  rvfi_o_mem_wmask_0;
    logic [31:0] rvfi_o_mem_rdata_0;
    logic [31:0] rvfi_o_mem_wdata_0;

    MainDatapath uut (
        .CLK(CLK),
        .EN(EN),
        .Reset(Reset),
        .mem_file_path(mem_file_path),
        .data_memory_path(data_memory_path),
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

    always begin
        #1 CLK = ~CLK;
    end

    initial begin
        CLK=0;
        Reset=1;
        EN = 1;
        if (!$value$plusargs("MEMFILE=%s", mem_file_path)) begin
            mem_file_path = "";
            $finish;
        end
        if (!$value$plusargs("DMEMFILE=%s", data_memory_path)) begin
            data_memory_path = "";
            $finish;
        end

        #2;
        Reset=0;
    end

    always @(posedge CLK) begin
        sim_time++;

        if (rvfi_o_valid_0 && rvfi_o_mem_wmask_0 == 4'b1111) begin
            if (rvfi_o_mem_addr_0 == 32'h8004) begin
                $display("%08x", rvfi_o_mem_wdata_0);  // Print signature word
            end else if (rvfi_o_mem_addr_0 == 32'h8008 && rvfi_o_mem_wdata_0 == 32'hCAFECAFE) begin
                $finish(0);
            end
        end

        if (sim_time > 900000) begin
            $finish(0);
        end
    end
    
    initial begin
        $dumpfile("MainDatapath.vcd");
        $dumpvars(0,MainDatapath_TestBench);
    end


endmodule
