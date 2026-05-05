`timescale 1ns / 1ps

module bank_array #(
    parameter WIDTH = 8, 
    parameter DEPTH = 1024, // From SIMDRAM paper: Using a typical subarray size of 1024 rows,
    // parameter DEPTH = 1024, // From SIMDRAM paper: Using a typical subarray size of 1024 rows,
                                // SIMDRAM splits the row addressing into 1006 D-group rows, 2 C-group rows, and 16 B-group rows
    parameter COLWIDTH = 10, // Added to understand row boundaries
    parameter CHWIDTH = 5    // Added to understand row boundaries
) (
    input logic clk, 
    input logic [$clog2(DEPTH)-1:0] addr, // destination row; AMBIT: Destination row
    input logic rd_o_wr, 
    input logic rowclone_en,             // NEW: Trigger the copy
    input logic [CHWIDTH-1:0] src_row,   // AMBIT: tells BA which rows to activate simultaneously (by selecting into the BITWISE_GROUP Enum)
    input logic [16:0] virt_src_row, // NEW: The untranslated 17-bit address!
        // In a tripple row activation, the third row selected (EX: T2 in BITWISE_GROUP.TO_T1_T2) will act as the operand type (C0 = AND, C1 = OR)
    input logic [CHWIDTH-1:0] AmbitOp1RowId, // AMBIT: acts as Operand 1 
    input logic [CHWIDTH-1:0] AmbitOp2RowId, // AMBIT: acts as Operand 2
    input logic [CHWIDTH-1:0] AmbitOp3RowId, // AMBIT: acts as Operand 3 
    input logic [1:0] ambit_en,             // NEW: Trigger the copy
    input logic [WIDTH-1:0] i_data, 
    output logic [WIDTH-1:0] o_data 
);
    // enum {C0 = 1006, C1 = 1007} CONTROL_GROUP;
    enum {T0 = 1008, T1, T2, T3, DCC0, n_DCC0, DCC1, n_DCC1, n_DCC0_T0, n_DCC1_T1, T2_T3, T0_T3, T0_T1_T2=66, T1_T2_T3, DCC0_T1_T2, DCC1_T0_T3} BITWISE_GROUP;

    (* ram_style = "block" *) logic [WIDTH-1:0] memory_array [0:DEPTH-1];
    
    `ifndef SYNTHESIS
    integer i;
    initial begin
        for (i=0; i<=DEPTH; i=i+1)
            memory_array[i] = {WIDTH{1'b0}};
    end
    `endif
    
    always @ (posedge clk) begin
        if (ambit_en == 2'd1) begin
                if (virt_src_row == T0_T1_T2 || virt_src_row == T1_T2_T3 || virt_src_row == DCC0_T1_T2 || virt_src_row == DCC1_T0_T3) begin
                    for (int c = 0; c < (1<<COLWIDTH); c++) begin
                        
                        // Check if T2 (AmbitOp3) is initialized to 0 for this specific column
                        if (|memory_array[{AmbitOp3RowId, c[COLWIDTH-1:0]}] == 0) begin
                            // if (c == 0) begin
                            //     $display("BANK ARRAY - OK: AMBITing AND row %d to row address %d into row %d", AmbitOp1RowId, AmbitOp2RowId, addr);
                            // end
                            // AND operation
                            memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                                memory_array[{AmbitOp1RowId, c[COLWIDTH-1:0]}] & 
                                memory_array[{AmbitOp2RowId, c[COLWIDTH-1:0]}];
                        end 
                        else begin
                            // if (c == 0) begin
                            //     $display("BANK ARRAY - OK: AMBITing OR row %d to row address %d into row %d", AmbitOp1RowId, AmbitOp2RowId, addr);
                            // end
                            // OR operation
                            memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                                memory_array[{AmbitOp1RowId, c[COLWIDTH-1:0]}] | 
                                memory_array[{AmbitOp2RowId, c[COLWIDTH-1:0]}];
                        end
                    end
                end
        end else if (ambit_en == 2'd2) begin
            for (int c = 0; c < (1<<COLWIDTH); c++) begin
                // memory_array[{src_row[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                //         ~memory_array[{addr, c[COLWIDTH-1:0]}];
                memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                        ~memory_array[{src_row, c[COLWIDTH-1:0]}];
                if (c == 0) begin
                    $display("BANK ARRAY - OK: AMBITing NOT row %d to (cached) row address %d", virt_src_row, AmbitOp1RowId);
                end
                
                // // Check if T2 (AmbitOp3) is initialized to 0 for this specific column
                // if (|memory_array[{AmbitOp3RowId, c[COLWIDTH-1:0]}] == 0) begin
                //     // AND operation
                //     memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                //         memory_array[{AmbitOp1RowId, c[COLWIDTH-1:0]}] & 
                //         memory_array[{AmbitOp2RowId, c[COLWIDTH-1:0]}];
                // end 
                // else begin
                //     // if (c == 0) begin
                //     //     $display("BANK ARRAY - OK: AMBITing OR row %d to row address %d into row %d", AmbitOp1RowId, AmbitOp2RowId, addr);
                //     // end
                //     // OR operation
                //     memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                //         memory_array[{AmbitOp1RowId, c[COLWIDTH-1:0]}] | 
                //         memory_array[{AmbitOp2RowId, c[COLWIDTH-1:0]}];
                // end
            end
        end else if (rowclone_en) begin
            // NEW: Bulk copy the entire row in simulation.
            // Note: This works perfectly in ModelSim emulation, but for actual FPGA 
            // synthesis, you would need to pipeline this or use a custom dual-port BRAM.
            for (int c = 0; c < (1<<COLWIDTH); c++) begin
                memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= memory_array[{src_row, c[COLWIDTH-1:0]}];
            end
        end

        else if (rd_o_wr) begin
            memory_array[addr] <= i_data;
        end
        else begin
            o_data <= memory_array[addr];
        end
    end
endmodule