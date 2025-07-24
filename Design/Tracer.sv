module Tracer(
  input         rvfi_i_bool,
  input  [3:0]  rvfi_i_uint4,
  input  [4:0]  rvfi_i_uint5_0,
  input  [4:0]  rvfi_i_uint5_1,
  input  [4:0]  rvfi_i_uint5_2,
  input  [31:0] rvfi_i_uint32_0,
  input  [31:0] rvfi_i_uint32_1,
  input  [31:0] rvfi_i_uint32_2,
  input  [31:0] rvfi_i_uint32_3,
  input  [31:0] rvfi_i_uint32_4,
  input  [31:0] rvfi_i_uint32_5,
  input  [31:0] rvfi_i_uint32_6,
  input  [31:0] rvfi_i_uint32_7,
  input  [31:0] rvfi_i_uint32_8,
  output        rvfi_o_valid_0,
  output [31:0] rvfi_o_insn_0,
  output [4:0]  rvfi_o_rs1_addr_0,
  output [4:0]  rvfi_o_rs2_addr_0,
  output [31:0] rvfi_o_rs1_rdata_0,
  output [31:0] rvfi_o_rs2_rdata_0,
  output [4:0]  rvfi_o_rd_addr_0,
  output [31:0] rvfi_o_rd_wdata_0,
  output [31:0] rvfi_o_pc_rdata_0,
  output [31:0] rvfi_o_pc_wdata_0,
  output [31:0] rvfi_o_mem_addr_0,
  output [3:0]  rvfi_o_mem_wmask_0,
  output [31:0] rvfi_o_mem_rdata_0,
  output [31:0] rvfi_o_mem_wdata_0
);
  assign rvfi_o_valid_0 = rvfi_i_bool; // @[Tracer.scala 55:19]
  assign rvfi_o_insn_0 = rvfi_i_uint32_0; // @[Tracer.scala 78:18]
  assign rvfi_o_rs1_addr_0 = rvfi_i_uint5_0; // @[Tracer.scala 64:18]
  assign rvfi_o_rs2_addr_0 = rvfi_i_uint5_1; // @[Tracer.scala 64:18]
  assign rvfi_o_rs1_rdata_0 = rvfi_i_uint32_1; // @[Tracer.scala 78:18]
  assign rvfi_o_rs2_rdata_0 = rvfi_i_uint32_2; // @[Tracer.scala 78:18]
  assign rvfi_o_rd_addr_0 = rvfi_i_uint5_2; // @[Tracer.scala 64:18]
  assign rvfi_o_rd_wdata_0 = rvfi_i_uint32_3; // @[Tracer.scala 78:18]
  assign rvfi_o_pc_rdata_0 = rvfi_i_uint32_4; // @[Tracer.scala 78:18]
  assign rvfi_o_pc_wdata_0 = rvfi_i_uint32_5; // @[Tracer.scala 78:18]
  assign rvfi_o_mem_addr_0 = rvfi_i_uint32_6; // @[Tracer.scala 78:18]
  assign rvfi_o_mem_wmask_0 = rvfi_i_uint4; // @[Tracer.scala 57:23]
  assign rvfi_o_mem_rdata_0 = rvfi_i_uint32_7; // @[Tracer.scala 78:18]
  assign rvfi_o_mem_wdata_0 = rvfi_i_uint32_8; // @[Tracer.scala 78:18]
endmodule