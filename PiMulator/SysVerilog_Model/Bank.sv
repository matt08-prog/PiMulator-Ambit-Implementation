`timescale 1ns / 1ps

module Bank
  #(parameter DEVICE_WIDTH = 4,
  parameter COLWIDTH = 10,
  parameter CHWIDTH = 5,
  localparam COLS = 2**COLWIDTH, 
  localparam CHROWS = 2**CHWIDTH, 
  localparam DEPTH = COLS*CHROWS) 
  (
  input  logic clk,
  input  logic [0:0]              rd_o_wr,
  input  logic                    rowclone_en, // NEW
  input  logic [CHWIDTH-1:0]      src_row,     // NEW
  input  logic [16:0]             virt_src_row, // NEW
  input  logic [CHWIDTH-1:0]      AmbitOp1RowId,     // NEW
  input  logic [CHWIDTH-1:0]      AmbitOp2RowId,     // NEW
  input  logic [CHWIDTH-1:0]      AmbitOp3RowId,     // NEW
  input  logic [0:0]              ambit_en,
  input  logic [DEVICE_WIDTH-1:0] dqin,
  output logic [DEVICE_WIDTH-1:0] dqout,
  input  logic [CHWIDTH-1:0]      row,         // This acts as the destination row
  input  logic [COLWIDTH-1:0]     column
  );

  bank_array #(
      .WIDTH(DEVICE_WIDTH), 
      .DEPTH(DEPTH), 
      .COLWIDTH(COLWIDTH),   // NEW
      .CHWIDTH(CHWIDTH)      // NEW
  ) arrayi (
      .clk(clk),
      .addr({row, column}),
      .rd_o_wr(rd_o_wr), 
      .rowclone_en(rowclone_en), // NEW
      .src_row(src_row),         // NEW
      .virt_src_row(virt_src_row),
      .AmbitOp1RowId(AmbitOp1RowId),
      .AmbitOp2RowId(AmbitOp2RowId),
      .AmbitOp3RowId(AmbitOp3RowId),
      .ambit_en(ambit_en), 
      .i_data(dqin),
      .o_data(dqout)
  );
endmodule