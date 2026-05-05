`timescale 1ns / 1ps

`define DDR4
// `define DDR3

// references: www.systemverilog.io

// The native DIMM channel interface signals (addressing and controls) are passed to this
// module to be decoded into memory commands. Additionally, RAS and CAS controls are implemented.
module CMD
    #(parameter ADDRWIDTH = 17,
    parameter COLWIDTH = 10,
    parameter BGWIDTH = 2,
    parameter BANKGROUPS = 2**BGWIDTH,
    parameter BAWIDTH = 2,
    parameter BL = 8, // Burst Length
    
    localparam BANKSPERGROUP = 2**BAWIDTH
    )
    (
    input logic cke, // Clock Enable; HIGH activates internal clock signals and device input buffers and output drivers
    input logic cs_n, // Chip select; The memory looks at all the other inputs only if this is LOW todo: scale to more than 1 rank
    input logic clk,
    input logic ambit_NOT_OP,
    `ifdef DDR4
    input logic act_n,
    `endif
    `ifdef DDR3
    input logic ras_n,
    input logic cas_n,
    input logic we_n,
    `endif
    input logic [BGWIDTH-1:0] bg,
    input logic [BAWIDTH-1:0] ba,
    input logic [ADDRWIDTH-1:0] A,
    output logic [ADDRWIDTH-1:0] RowId [BANKGROUPS-1:0][BANKSPERGROUP-1:0],
    output logic [ADDRWIDTH-1:0] SrcRowId [BANKGROUPS-1:0][BANKSPERGROUP-1:0], // NEW
    output logic [ADDRWIDTH-1:0] AmbitOp1RowId [BANKGROUPS-1:0][BANKSPERGROUP-1:0], // NEW
    output logic [ADDRWIDTH-1:0] AmbitOp2RowId [BANKGROUPS-1:0][BANKSPERGROUP-1:0], // NEW
    output logic [ADDRWIDTH-1:0] AmbitOp3RowId [BANKGROUPS-1:0][BANKSPERGROUP-1:0], // NEW
    output logic [1:0] should_enable_ambit [BANKGROUPS-1:0][BANKSPERGROUP-1:0], // 0: Not an ambit operation, 1: AND/OR operation, 2: NOT operation
    output logic [COLWIDTH-1:0] ColId [BANKGROUPS-1:0][BANKSPERGROUP-1:0],
    output logic rd_o_wr [BANKGROUPS-1:0][BANKSPERGROUP-1:0],
    output logic [18:0] commands
    );
    
    enum {T0 = 1008, T1, T2, T3, DCC0, n_DCC0, DCC1, n_DCC1, n_DCC0_T0, n_DCC1_T1, T2_T3, T0_T3, T0_T1_T2=66, T1_T2_T3, DCC0_T1_T2, DCC1_T0_T3} BITWISE_GROUP;
    // ras_n -> A16, cas_n -> A15, we_n -> A14
    // Dual function inputs:
    // - when act_n & cs_n are LOW, these are interpreted as *Row* Address Bits (RAS Row Address Strobe)
    // - when act_n is HIGH, these are interpreted as command pins to indicate READ, WRITE or other commands
    // - - and CAS - Column Address Strobe (A0-A9 used for column at this times)
    // A10 which is an unused bit during CAS is overloaded to indicate Auto-Precharge
    logic A16, A15, A14, A10;
    logic A11;
    assign A16 = A[ADDRWIDTH-1]; // RAS_n
    assign A15 = A[ADDRWIDTH-2]; // CAS_n
    assign A14 = A[ADDRWIDTH-3]; // WE_n
    assign A10 = A[ADDRWIDTH-4]; // AP
    assign A11 = A[ADDRWIDTH-5]; // Usually unused. Now acts as RPM_en for LISA
    
    logic ACT, BST, CFG, CKEH, CKEL, DPD, DPDX, MRR, MRW, PD, PDX, PR, PRA, RD, RDA, REF, SRF, WR, WRA;
    // logic RBM;
    
    // implement ddr command decoding logic using truth table // todo: implement all commands not just a few
    assign ACT  = (!cs_n && !act_n); // entire A is the Row Address at this time
    assign BST  = 0; //(act_n && A[ADDRWIDTH-2]); // todo:
    assign CFG  = 0;
    assign CKEH = 0; //cke;
    assign CKEL = 0; //!cke;
    assign DPD  = 0;
    assign DPDX = 0;
    assign MRR  = 0;
    assign MRW  = 0;
    assign PD   = 0;
    assign PDX  = 0;
    assign PR   = (!cs_n && act_n && !A16 &&  A15 && !A14 && !A10); // PRE
    // assign RBM  = (!cs_n && act_n && !A16 &&  A15 && !A14 && !A10 &&  A11); // NEW LISA RBM Command (Precharge pattern + A11 HIGH)
    assign PRA  = (!cs_n && act_n && !A16 &&  A15 && !A14 &&  A10); // PREA Precharge all Banks
    assign RD   = (!cs_n && act_n &&  A16 && !A15 &&  A14 && !A10);
    assign RDA  = (!cs_n && act_n &&  A16 && !A15 &&  A14 &&  A10);
    assign REF  = (!cs_n && act_n && !A16 && !A15 &&  A14         &&  cke);
    assign SRF  = (!cs_n && act_n && !A16 && !A15 &&  A14         && !cke); // SRE
    assign WR   = (!cs_n && act_n &&  A16 && !A15 && !A14 && !A10);
    assign WRA  = (!cs_n && act_n &&  A16 && !A15 && !A14 &&  A10);
    
    assign commands = {ACT, BST, CFG, CKEH, CKEL, DPD, DPDX, MRR, MRW, PD, PDX, PR, PRA, RD, RDA, REF, SRF, WR, WRA};
    // assign commands = {RBM, ACT, BST, CFG, CKEH, CKEL, DPD, DPDX, MRR, MRW, PD, PDX, PR, PRA, RD, RDA, REF, SRF, WR, WRA};
    
    // RAS = Row Address Strobe;
    // the idea here is to store the address A during an activate command
    // thus keep track of which row is active at each Bank
    always@(posedge clk)
    begin
        if(ACT) begin 
            // keep track of active row two activations ago
            // AmbitOp1RowId[bg][ba] <= SrcRowId[bg][ba];

            // NEW: Keep track of the previously active row as the source
            SrcRowId[bg][ba] <= RowId[bg][ba];
            // Update the current active row to the destination
            // TODO: This is where it should be determined if this is a simple row activation or tripple row activation (AMBIT operation if address is in B_12:B15)
            // TODO: Based on that determination, an AMBIT_en signal should be enabled
            case (RowId[bg][ba])
                    T0_T1_T2:    begin
                        AmbitOp1RowId[bg][ba] <= T0;
                        AmbitOp2RowId[bg][ba] <= T1;
                        AmbitOp3RowId[bg][ba] <= T2;
                        $display("CMD recieved TO_T1_T2 so enabling should_enable_ambit");
                        should_enable_ambit[bg][ba] <= 2'b1;
                    end

                    T1_T2_T3:    begin
                        AmbitOp1RowId[bg][ba] <= T1;
                        AmbitOp2RowId[bg][ba] <= T2;
                        AmbitOp3RowId[bg][ba] <= T3;
                        $display("CMD recieved T1_T2_T3 so enabling should_enable_ambit");
                        should_enable_ambit[bg][ba] <= 2'b1;
                    end

                    DCC0_T1_T2:    begin
                        AmbitOp1RowId[bg][ba] <= DCC0;
                        AmbitOp2RowId[bg][ba] <= T1;
                        AmbitOp3RowId[bg][ba] <= T2;
                        $display("CMD recieved DCC0_T1_T2 so enabling should_enable_ambit");
                        should_enable_ambit[bg][ba] <= 2'b1;
                    end

                    DCC1_T0_T3:    begin
                        AmbitOp1RowId[bg][ba] <= DCC1;
                        AmbitOp2RowId[bg][ba] <= T0;
                        AmbitOp3RowId[bg][ba] <= T3;
                        $display("CMD recieved DCC1_T0_T3 so enabling should_enable_ambit");
                        should_enable_ambit[bg][ba] <= 2'b1;
                    end

                    // n_DCC0: begin
                    //     if (ambit_NOT_OP == 1'b1) begin
                    //         AmbitOp1RowId[bg][ba] <= n_DCC0;
                    //         AmbitOp2RowId[bg][ba] <= 0;
                    //         AmbitOp3RowId[bg][ba] <= 0;
                    //         should_enable_ambit[bg][ba] <= 2'd2;
                    //     end else begin
                    //         AmbitOp1RowId[bg][ba] <= 0;
                    //         AmbitOp2RowId[bg][ba] <= 0;
                    //         AmbitOp3RowId[bg][ba] <= 0;
                    //         should_enable_ambit[bg][ba] <= 0;
                    //     end
                    // end

                    default: begin
                        if (ambit_NOT_OP == 1'b1 && A == n_DCC0) begin
                            AmbitOp1RowId[bg][ba] <= n_DCC0; // Pass the destination down to be cached
                            AmbitOp2RowId[bg][ba] <= 0;
                            AmbitOp3RowId[bg][ba] <= 0;
                            should_enable_ambit[bg][ba] <= 2'd2;
                            $display("CMD received n_DCC0 as destination, enabling NOT operation");
                        end else begin
                            AmbitOp1RowId[bg][ba] <= 0;
                            AmbitOp2RowId[bg][ba] <= 0;
                            AmbitOp3RowId[bg][ba] <= 0;
                            should_enable_ambit[bg][ba] <= 0;
                        end
                    end
                endcase

            RowId[bg][ba] <= A;                
        end
    end
    
    logic Burst [BANKGROUPS-1:0][BANKSPERGROUP-1:0];
    // CAS = Column Address Strobe;
    // similarly, here we store the first column and iterate to implement a burst count
    always@(posedge clk)
    begin
        // CONDITION 1: A new Read or Write command arrives
        if(WR || WRA || RD || RDA) begin
            ColId[bg][ba] <= A[COLWIDTH-1:0]; // Save the starting column
            Burst[bg][ba] <= 1;               // Turn the auto-increment flag ON
        end
        // CONDITION 2: A Precharge command arrives
        else if (PR) begin
            Burst[bg][ba] <= 0;               // Turn the auto-increment flag OFF
        end
        // CONDITION 3: No new command (Idle/Continuing)
        else begin
            for (int i = 0; i < BANKGROUPS; i++) begin
                for (int j = 0; j < BANKSPERGROUP; j++) begin
                    if(Burst[i][j]) 
                        ColId[i][j] <= ColId[i][j] + 1; // Auto-increment!
                end
            end
        end
    end
    
    // Write Enable bit
    // will determine the read or write (in or out state of the inout data pins)
    always@(posedge clk)
    begin
        if(WR || WRA) rd_o_wr[bg][ba] <= 1;
        else if (PR || RD || RDA) rd_o_wr[bg][ba] <= 0;
        // else rd_o_wr[bg][ba] <= 0;
    end
    
    `ifndef SYNTHESIS
    // initialize RowId, Column, Burst to values 0 for simulation runs
    initial
    begin
        for (integer i=0;i<=BANKGROUPS;i=i+1) begin
            for (integer j=0;j<=BANKSPERGROUP;j=j+1) begin
                RowId[i][j] = {ADDRWIDTH{1'b0}};
                ColId[i][j] = {COLWIDTH{1'b0}};
                Burst[i][j] = 0;
                rd_o_wr[i][j] = 0;
            end
        end
    end
    `endif
    
endmodule
