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
    input logic ambit_en,             // NEW: Trigger the copy
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
        if (ambit_en) begin
            case (virt_src_row)
                T0_T1_T2: begin 
                    for (int c = 0; c < (1<<COLWIDTH); c++) begin
                        
                        // Check if T2 (AmbitOp3) is initialized to 0 for this specific column
                        if (|memory_array[{AmbitOp3RowId, c[COLWIDTH-1:0]}] == 0) begin
                            if (c == 0) begin
                                $display("BANK ARRAY - OK: AMBITing AND row %d to row address %d into row %d", AmbitOp1RowId, AmbitOp2RowId, addr);
                            end
                            // AND operation
                            memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                                memory_array[{AmbitOp1RowId, c[COLWIDTH-1:0]}] & 
                                memory_array[{AmbitOp2RowId, c[COLWIDTH-1:0]}];
                        end 
                        else begin
                            if (c == 0) begin
                                $display("BANK ARRAY - OK: AMBITing OR row %d to row address %d into row %d", AmbitOp1RowId, AmbitOp2RowId, addr);
                            end
                            // OR operation
                            memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
                                memory_array[{AmbitOp1RowId, c[COLWIDTH-1:0]}] | 
                                memory_array[{AmbitOp2RowId, c[COLWIDTH-1:0]}];
                        end
                        
                    end
                end
                // Add other BITWISE_GROUP cases here...
            endcase
        end else if (rowclone_en) begin
            // NEW: Bulk copy the entire row in simulation.
            // Note: This works perfectly in ModelSim emulation, but for actual FPGA 
            // synthesis, you would need to pipeline this or use a custom dual-port BRAM.
            for (int c = 0; c < (1<<COLWIDTH); c++) begin
                // addr[$clog2(DEPTH)-1:COLWIDTH] extracts the destination row
                
                case (src_row[$clog2(DEPTH)-1 : COLWIDTH])
                    T0_T1_T2:    begin 
                        // if (|memory_array[T2[$clog2(DEPTH)-1 : COLWIDTH]] == 0) begin // all bits are 0 so this is an AND operation
                        // memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= memory_array[{T0[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] & memory_array[{T1[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}];
                        
                        // Debug statement
                        // if (c == 0) begin
                        //     $display("BANK ARRAY - OK: AMBITing AND row %d to row address %d into row %d", T0, T1, addr);
                        // end
                        memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= memory_array[{T0, c[COLWIDTH-1:0]}] & memory_array[{T0, c[COLWIDTH-1:0]}];
                        // end
                    end
                    default:    begin
                        memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= memory_array[{src_row, c[COLWIDTH-1:0]}];
                        
                        // Debug statement
                        // if (c == 0) begin
                        //     $display("BANK ARRAY - OK: rowcloning from row %d to row address %d and column address %d", src_row[$clog2(DEPTH)-1 : COLWIDTH], addr[$clog2(DEPTH)-1 : COLWIDTH], addr[COLWIDTH-1:0]);
                        // end
                    end
                endcase
            end
        end
        //     for (int c = 0; c < (1<<COLWIDTH); c++) begin
        //         if (|memory_array[{T2[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] == 0) begin // all bits are 0 so this is an AND operation
        //             if (c == 0) begin
        //                 $display("BANK ARRAY - OK: AMBITing AND row %d to row address %d into row %d", AmbitOp1RowId, AmbitOp2RowId, addr);
        //             end
        //             memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= memory_array[{AmbitOp1RowId, c[COLWIDTH-1:0]}] & memory_array[{AmbitOp2RowId, c[COLWIDTH-1:0]}];
        //         end
        //         // case (src_row)
        //         //     T0_T1_T2:    begin 
        //         //         if (|memory_array[T2[$clog2(DEPTH)-1 : COLWIDTH]] == 0) begin // all bits are 0 so this is an AND operation
        //         //             memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= memory_array[{T0[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] & memory_array[{T1[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}];
        //         //         end
        //         //     end
                    
        //             // GREEN:  begin light = 3'b001; next_state = YELLOW; end
        //             // YELLOW: begin light = 3'b010; next_state = RED;    end
        //             // default: begin light = 3'b100; next_state = RED;    end // Safety default
        //         // endcase
                    
        //             // addr[$clog2(DEPTH)-1:COLWIDTH] extracts the destination row
        //             // memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] & memory_array[{src_row, c[COLWIDTH-1:0]}];
        //     end
        // end

        // else if (ambit_en) begin
        //     for (int c = 0; c < (1<<COLWIDTH); c++) begin
                
        //         // If T2 is all 0s, perform AND
        //         if (|memory_array[{cT2_RowId, c[COLWIDTH-1:0]}] == 0) begin 
        //             // memory[dest] = memory[T0] & memory[T1]
        //             memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
        //                 memory_array[{cT0_RowId, c[COLWIDTH-1:0]}] & 
        //                 memory_array[{cT1_RowId, c[COLWIDTH-1:0]}];
        //         end
                
        //         // If T2 is all 1s, perform OR
        //         else if (&memory_array[{cT2_RowId, c[COLWIDTH-1:0]}] == 1) begin 
        //             // memory[dest] = memory[T0] | memory[T1]
        //             memory_array[{addr[$clog2(DEPTH)-1 : COLWIDTH], c[COLWIDTH-1:0]}] <= 
        //                 memory_array[{cT0_RowId, c[COLWIDTH-1:0]}] | 
        //                 memory_array[{cT1_RowId, c[COLWIDTH-1:0]}];
        //         end

        //     end
        // end

        else if (rd_o_wr) begin
            memory_array[addr] <= i_data;
        end
        else begin
            o_data <= memory_array[addr];
        end
    end
endmodule