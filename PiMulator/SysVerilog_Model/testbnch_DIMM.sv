`timescale 1ns / 1ps

`define DDR4
// `define DDR3

`define RowClone

module testbnch_DIMM();
    
    parameter RANKS = 1;
    parameter CHIPS = 16;
    parameter BGWIDTH = 2;
    parameter BANKGROUPS = 2**BGWIDTH;
    parameter BANKARRAYSPERBANK = 1;
    parameter BAWIDTH = 2;
    parameter ADDRWIDTH = 17;
    parameter COLWIDTH = 10;
    parameter DEVICE_WIDTH = 4; // x4, x8, x16 -> DQ width = Device_Width x BankGroups (Chips)
    parameter BL = 8; // Burst Length
    parameter CHWIDTH = 5; // Emulation Memory Cache Width
    
    localparam DQWIDTH = DEVICE_WIDTH*CHIPS; // 64 bits + 8 bits for ECC
    localparam BANKSPERGROUP = 2**BAWIDTH;
    localparam ROWS = 2**ADDRWIDTH;
    localparam COLS = 2**COLWIDTH;
    
    localparam CHIPSIZE = (DEVICE_WIDTH*COLS*(ROWS/1024)*BANKSPERGROUP*BANKGROUPS)/(1024); // Mbit
    localparam DIMMSIZE = (CHIPSIZE*CHIPS)/(1024*8); // GB
    
    localparam tCK = 0.75;
    
    localparam T_CL   = 17;
    localparam T_RCD  = 17;
    localparam T_RP   = 17;
    localparam T_RFC  = 34;
    localparam T_WR   = 14;
    localparam T_RTP  = 7;
    localparam T_CWL  = 10;
    localparam T_ABA  = 24;
    localparam T_ABAR = 24;
    localparam T_RAS  = 32;
    localparam T_REFI = 9360;
    localparam T_RBM = 5;
    
    // AMBIT parameters
    localparam row_address_A = 956;
    localparam row_address_B = 220;
    localparam ambit_result_row = 333;

    logic reset_n;
    logic RBM;
    logic ck2x;
    logic ck_cn;
    logic ck_tp;
    logic cke;
    logic [RANKS-1:0]cs_n;
    `ifdef DDR4
    logic act_n;
    `endif
    `ifdef DDR3
    logic ras_n;
    logic cas_n;
    logic we_n;
    `endif
    logic [ADDRWIDTH-1:0]A;
    logic [BAWIDTH-1:0]ba;
    logic [BGWIDTH-1:0]bg;
    wire [DQWIDTH-1:0]dq;
    logic [DQWIDTH-1:0]dq_reg;
    wire [CHIPS-1:0]dqs_cn;
    logic [CHIPS-1:0]dqs_cn_reg;
    wire [CHIPS-1:0]dqs_tp;
    logic [CHIPS-1:0]dqs_tp_reg;
    logic odt;
    `ifdef DDR4
    logic parity;
    `endif
    
    logic sync [BANKGROUPS-1:0][BANKSPERGROUP-1:0];
    
    logic writing;
    
    assign dq = (writing) ? dq_reg:{DQWIDTH{1'bZ}};
    assign dqs_cn = (writing) ? dqs_cn_reg:{CHIPS{1'bZ}};
    assign dqs_tp = (writing) ? dqs_tp_reg:{CHIPS{1'bZ}};
    
    DIMM #(.RANKS(RANKS),
    .CHIPS(CHIPS),
    .BGWIDTH(BGWIDTH),
    .BANKGROUPS(BANKGROUPS),
    .BANKARRAYSPERBANK(BANKARRAYSPERBANK),
    .BAWIDTH(BAWIDTH),
    .ADDRWIDTH(ADDRWIDTH),
    .COLWIDTH(COLWIDTH),
    .DEVICE_WIDTH(DEVICE_WIDTH),
    .BL(BL),
    .CHWIDTH(CHWIDTH)
    ) dut (
    .reset_n(reset_n),
    .RBM(RBM),
    .ck2x(ck2x),
    .ck_cn(ck_cn),
    .ck_tp(ck_tp),
    .cke(cke),
    .cs_n(cs_n),
    `ifdef DDR4
    .act_n(act_n),
    `endif
    `ifdef DDR3
    .ras_n(ras_n),
    .cas_n(cas_n),
    .we_n(we_n),
    `endif
    .A(A),
    .ba(ba),
    .bg(bg),
    .dq(dq),
    .dqs_cn(dqs_cn),
    .dqs_tp(dqs_tp),
    .odt(odt),
    `ifdef DDR4
    .parity(parity),
    `endif
    .sync(sync),
    .stall()   // FIX: Explicitly ignore the stall output to silence the warning
    );
    
    always #(tCK) ck_tp = ~ck_tp;
    always #(tCK) ck_cn = ~ck_cn;
    always #(tCK*0.5) ck2x = ~ck2x;
    
    enum {C0 = 1006, C1 = 1007} CONTROL_GROUP;
    enum {T0 = 1008, T1, T2, T3, DCC0, n_DCC0, DCC1, n_DCC1, n_DCC0_T0, n_DCC1_T1, T2_T3, T0_T3, T0_T1_T2=66, T1_T2_T3, DCC0_T1_T2, DCC1_T0_T3} BITWISE_GROUP;

    integer i, j; // loop variable
    
    // NEW: Array to store the written data for verification later
    logic [DQWIDTH-1:0] expected_data_A [0:BL-1];
    logic [DQWIDTH-1:0] expected_data_B [0:BL-1];
    logic [DQWIDTH-1:0] expected_data_C [0:BL-1];

    logic [DQWIDTH-1:0] test_data_all_0s [0:BL-1] = {
        64'h0000000000000000,
        64'h0000000000000000,
        64'h0000000000000000,
        64'h0000000000000000,
        64'h0000000000000000,
        64'h0000000000000000,
        64'h0000000000000000,
        64'h0000000000000000
    };

    logic [DQWIDTH-1:0] test_data_all_1s [0:BL-1] = {
        64'h1111111111111111,
        64'h1111111111111111,
        64'h1111111111111111,
        64'h1111111111111111,
        64'h1111111111111111,
        64'h1111111111111111,
        64'h1111111111111111,
        64'h1111111111111111
    };

    logic [DQWIDTH-1:0] operand_A_test_data [0:BL-1] = {
        64'hfbbbbbbbbbbbbbbb,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'hbbbbbbbbbbbbbbbf
    };

    logic [DQWIDTH-1:0] operand_B_test_data [0:BL-1] = {
        64'hfccccccccccccccc,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'haaaaaaaaaaaaaaaa,
        64'hcccccccccccccccf
    };

    logic [DQWIDTH-1:0] operand_A_AND_operand_B_test_result [0:BL-1];
    logic [DQWIDTH-1:0] operand_A_OR_operand_B_test_result [0:BL-1];

    // Bitwise AND operation
    always_comb begin
        foreach (operand_A_AND_operand_B_test_result[i]) begin
            operand_A_AND_operand_B_test_result[i] = operand_A_test_data[i] & operand_B_test_data[i];
        end
    end
    // Bitwise AND operation
    always_comb begin
        foreach (operand_A_OR_operand_B_test_result[i]) begin
            operand_A_OR_operand_B_test_result[i] = operand_A_test_data[i] | operand_B_test_data[i];
        end
    end

    // 1. Activate a Row (Must be act_n = 0)
    task activate_row(input [ADDRWIDTH-1:0] row_address);
        act_n = 0; // MUST be 0 to activate!
        A = row_address;
        ba = 1;
        sync[0][1] = 1; // Tell the cache to allocate
        #tCK;
        act_n = 1; // De-assert command
        A = 17'b0;
        ba = 0;
        sync[0][1] = 0;
        #(tCK*(T_RCD-1)); // Wait for sense amps to latch
        
        #(tCK*T_CL); // FIX: Wait for the FSM's post-activation cooldown timer!
    endtask

    // 2. Precharge a Bank (Close the active row)
    task precharge_bank();
        act_n = 1;
        A = 17'b01000000000000000; // PR Command pattern
        ba = 1;
        #tCK;
        A = 17'b0;
        ba = 0;
        #((T_RP-1)*tCK); // Wait for row to close
    endtask

    // 3. Write Data (Pass the array by reference so we can save it!)
    task write_rand_data(input [ADDRWIDTH-1:0] row_address, output logic [DQWIDTH-1:0] saved_data [0:BL-1]);
        activate_row(row_address);
        
        A = 17'b10000000000000010; // WR Command
        ba = 1;
        writing = 1;
        #tCK;
        
        for (i = 0; i < BL; i = i + 1) begin
            A = 17'b0; // Clear command
            saved_data[i] = {$urandom, $urandom, $urandom, $urandom, $urandom, $urandom, $urandom, $urandom, $urandom };
            dq_reg = saved_data[i];
            
            dqs_tp_reg = {CHIPS{1'b1}};
            dqs_cn_reg = {CHIPS{1'b0}};
            #tCK;
            assert (dut.TimingFSMi.BankFSM[0][1] == 5'h12) $display("OK: writing random data to row address %d[%d]: %h", row_address, i, saved_data[i]); else $display(dut.TimingFSMi.BankFSM[0][1]);
        end
        dq_reg = {DQWIDTH{1'b0}};
        ba = 0;
        writing = 0;
        #(tCK*(T_ABA-BL+4)); // Wait out the burst
    endtask

    // 3.5. Write Data (Pass the array by reference so we can save it!)
    task write_data_to_row(input [ADDRWIDTH-1:0] row_address, input logic [DQWIDTH-1:0] data_to_write [0:BL-1]);
        activate_row(row_address);
        
        A = 17'b10000000000000010; // WR Command
        ba = 1;
        writing = 1;
        #tCK;
        
        for (i = 0; i < BL; i = i + 1) begin
            A = 17'b0; // Clear command
            dq_reg = data_to_write[i];
            
            dqs_tp_reg = {CHIPS{1'b1}};
            dqs_cn_reg = {CHIPS{1'b0}};
            #tCK;
            assert (dut.TimingFSMi.BankFSM[0][1] == 5'h12) $display("OK: writing data to row address %d[%d]: %h", row_address, i, data_to_write[i]); else $display(dut.TimingFSMi.BankFSM[0][1]);
        end
        dq_reg = {DQWIDTH{1'b0}};
        ba = 0;
        writing = 0;
        #(tCK*(T_ABA-BL+4)); // Wait out the burst
    endtask

    // Trigger RowClone
    task trigger_rowclone(input [ADDRWIDTH-1:0] destination_row);
        // We do NOT call activate_row() here, because the source row must ALREADY be open!
        #(tCK*5); 
        act_n = 0;
        ba = 1;
        RBM = 1'b0;
        A = destination_row; // The second back-to-back ACT triggers the clone
        sync[0][1] = 1;
        #tCK;
        act_n = 1;
        A = 17'b0;
        
        // Wait for the physical T_RCD delay so the FSM finishes the copy 
        // and returns to the 'BankActive' state
        #(tCK*(T_RCD + 2)); 
        sync[0][1] = 0;
        
        #(tCK*T_CL); // FIX: Wait for the FSM's post-activation cooldown timer!
    endtask

    // Trigger LISA operation
    task trigger_LISA(input [ADDRWIDTH-1:0] destination_row);
        // We do NOT call activate_row() here, because the source row must ALREADY be open!
        #(tCK*5);
        act_n = 0;
        ba = 1;
        RBM = 1'b1;
        A = destination_row; // The second back-to-back ACT triggers the clone
        sync[0][1] = 1;
        #tCK;
        act_n = 1;
        A = 17'b0;
        
        // Wait for the physical T_RCD delay so the FSM finishes the copy 
        // and returns to the 'BankActive' state
        #(tCK*(T_RCD + 2)); 
        sync[0][1] = 0;
        
        #(tCK*T_CL); // FIX: Wait for the FSM's post-activation cooldown timer!
    endtask

    task read_row_data_and_verify_expected_result(input [ADDRWIDTH-1:0] row_Address_to_read, input logic [DQWIDTH-1:0] expected_value [0:BL-1]);
        precharge_bank(); // MUST CLOSE BEFORE ROWCLONE!
        activate_row(row_Address_to_read);

        // read
        #tCK;
        
        // 1. Issue the RD command
        A = 17'b10100000000000010;
        ba = 1;
        dqs_tp_reg = {CHIPS{1'b0}};
        dqs_cn_reg = {CHIPS{1'b1}};
        #tCK;

        // 2. Clear command, wait exactly 1 cycle for BRAM pipeline latency
        A = 17'b0;
        #tCK;

        // 3. Verify the data EXACTLY as it flows out of the BRAM
        for (i = 0; i < BL; i = i + 1)
        begin
            if (dq === expected_value[i]) begin
                $display("SUCCESS: Word %0d matched! Expected: %h, Got: %h", i, expected_value[i], dq);
            end else begin
                $error("FAILED: Word %0d mismatch! Expected: %h, Got: %h", i, expected_value[i], dq);
            end
            #tCK;
        end

        ba = 0;

        // 4. Wait out the rest of the FSM's read burst time before precharging
        #(tCK*(T_ABAR-BL));
        assert ((dut.TimingFSMi.BankFSM[0][1] == 5'h0b) || (i==0)) $display("OK: reading"); else $display(dut.TimingFSMi.BankFSM[0][1]);
        #(tCK*4); // no actions

        precharge_bank();
    endtask

    task trigger_ambit_operation(input [ADDRWIDTH-1:0] B_GroupAddress, input [ADDRWIDTH-1:0] Data_GroupAddress);
        activate_row(B_GroupAddress);
        trigger_rowclone(Data_GroupAddress);
        precharge_bank();
    endtask

    initial
    begin
        // initialize all inputs
        reset_n = 0; // DRAM is active only when this signal is HIGH
        ck_tp = 1;
        ck_cn = 0;
        ck2x = 1;
        cke = 1;
        cs_n = {RANKS{1'b1}}; // LOW makes rank active
        act_n = 1; // no ACT
        A = {ADDRWIDTH{1'b0}};
        bg = 0;
        ba = 0;
        dq_reg = {DQWIDTH{1'b0}};
        dqs_tp_reg = {CHIPS{1'b0}};
        dqs_cn_reg = {CHIPS{1'b1}};
        odt = 0;
        parity = 0;
        writing = 0;
        for (i = 0; i < BANKGROUPS; i = i + 1)
        begin
            for (j = 0; j < BANKSPERGROUP; j = j + 1)
            begin
                sync[i][j] = 0;
            end
        end
        #(tCK*0.99) // use a propagation delay because of (suspected) bug in Vivado Simulator
        
        // reset high
        reset_n = 1;
        cs_n = 1'b0; // LOW makes rank active
        #tCK;

        // confirm that Memory Controller is in StateTimingIdle
        for (i = 0; i < BANKGROUPS; i = i + 1)
        begin
            for (j = 0; j < BANKSPERGROUP; j = j + 1)
            begin
                assert (dut.TimingFSMi.BankFSM[i][j] == 5'h00) $display("OK: StateTimingIdle"); else $display(dut.TimingFSMi.BankFSM[i][j]);
            end
        end
        #tCK;
        
        // write test
        // ==========================================
        // 1. Write Data A to Row 0
        // ==========================================
        
        write_rand_data(17'd0, expected_data_A);
        precharge_bank(); // MUST CLOSE BEFORE OPENING ROW 8!

        // ==========================================
        // 3. Write Data B to Row 8
        // ==========================================
        write_rand_data(17'd8, expected_data_B);
        precharge_bank(); // MUST CLOSE BEFORE OPENING ROW 32!

        // ==========================================
        // 3. Write Data B to Row 8
        // ==========================================
        write_rand_data(17'd32, expected_data_C);
        precharge_bank(); // MUST CLOSE BEFORE ROWCLONE!

        // ==========================================
        // 4. RowClone Row 0 to Row 4
        // ==========================================
        `ifdef RowClone
        activate_row(17'd0);                 // Step 1: Open the Source
        trigger_rowclone(17'd4);             // Step 2: Open the Dest (Triggers copy!)
        `endif

        precharge_bank(); // CLOSE AFTER  ROWCLONE!
        // At this point, Row 4 is the currently active row. 
        // You can now proceed directly to your `RD` command loop 
        // and check `dq` against `expected_data_A`!
        
        read_row_data_and_verify_expected_result(17'd4, expected_data_A);
        read_row_data_and_verify_expected_result(17'd8, expected_data_B);
        
        
        

        // ==========================================
        // 5. Ambit AND operation test using BITWISE_GROUP T0_T1_T2
        // ==========================================

        // From Ambit paper:
            // to perform a bitwise AND/OR of two rows A and B, and store the result in row R,
            // our mechanism performs the following steps.
            // 1. Copy data of row A to designated row T0
            // 2. Copy data of row B to designated row T1
            // 3. Initialize designated row T2 to 0
            // 4. Activate designated rows T0, T1, and T2 simultaneously
            // 5. Copy data of row T0 to row R

        // 0. Initialize operands into data memory
        write_data_to_row(row_address_A, operand_A_test_data);
        precharge_bank(); // MUST CLOSE BEFORE OPENING row_address_B!

        write_data_to_row(row_address_B, operand_B_test_data);
        precharge_bank(); // MUST CLOSE BEFORE OPENING row_address_B!

        // 0.5 Verify data was coppied to correct row
        read_row_data_and_verify_expected_result(row_address_A, operand_A_test_data);
        read_row_data_and_verify_expected_result(row_address_B, operand_B_test_data);

        // 1. Copy data of row A to designated row T0
        `ifdef RowClone
        activate_row(row_address_A);                 // Step 1: Open the Source
        trigger_rowclone(T0);             // Step 2: Open the Dest (Triggers copy!)
        `endif

        precharge_bank();

        // 2. Copy data of row B to designated row T1
        `ifdef RowClone
        activate_row(row_address_B);                 // Step 1: Open the Source
        trigger_rowclone(T1);             // Step 2: Open the Dest (Triggers copy!)
        `endif

        // 2.5 Verify data was coppied to correct row
        read_row_data_and_verify_expected_result(T0, operand_A_test_data);
        read_row_data_and_verify_expected_result(T1, operand_B_test_data);

        // 3. T2 initialized to all 0s to perform AND operation on T0 and T1
        write_data_to_row(T2, test_data_all_0s);

        precharge_bank();
        // 4. Activate designated rows T0, T1, and T2 simultaneously
        trigger_ambit_operation(T0_T1_T2, ambit_result_row);

        read_row_data_and_verify_expected_result(ambit_result_row, operand_A_AND_operand_B_test_result);

        // ==========================================
        // 6. Ambit OR operation test
        // ==========================================

        // 3. T2 initialized to all 0s to perform AND operation on T0 and T1
        write_data_to_row(T2, test_data_all_1s);

        precharge_bank();
        // 4. Activate designated rows T0, T1, and T2 simultaneously
        trigger_ambit_operation(T0_T1_T2, ambit_result_row);

        read_row_data_and_verify_expected_result(ambit_result_row, operand_A_OR_operand_B_test_result);

        // ==========================================
        // 7. Ambit AND operation test using BITWISE_GROUP T1_T2_T3
        // ==========================================

        // 0. Initialize operands into data memory
        write_data_to_row(row_address_A, operand_A_test_data);
        precharge_bank(); // MUST CLOSE BEFORE OPENING row_address_B!

        write_data_to_row(row_address_B, operand_B_test_data);
        precharge_bank(); // MUST CLOSE BEFORE OPENING row_address_B!

        // 0.5 Verify data was coppied to correct row
        read_row_data_and_verify_expected_result(row_address_A, operand_A_test_data);
        read_row_data_and_verify_expected_result(row_address_B, operand_B_test_data);

        // 1. Copy data of row A to designated row T0
        `ifdef RowClone
        activate_row(row_address_A);                 // Step 1: Open the Source
        trigger_rowclone(T1);             // Step 2: Open the Dest (Triggers copy!)
        `endif

        precharge_bank();

        // 2. Copy data of row B to designated row T1
        `ifdef RowClone
        activate_row(row_address_B);                 // Step 1: Open the Source
        trigger_rowclone(T2);             // Step 2: Open the Dest (Triggers copy!)
        `endif

        // 2.5 Verify data was coppied to correct row
        read_row_data_and_verify_expected_result(T1, operand_A_test_data);
        read_row_data_and_verify_expected_result(T2, operand_B_test_data);

        // 3. T2 initialized to all 0s to perform AND operation on T0 and T1
        write_data_to_row(T3, test_data_all_0s);

        precharge_bank();
        // 4. Activate designated rows T0, T1, and T2 simultaneously
        trigger_ambit_operation(T1_T2_T3, ambit_result_row);

        read_row_data_and_verify_expected_result(ambit_result_row, operand_A_AND_operand_B_test_result);

        // ==========================================
        // 7. LISA Subarray movement test
        // ==========================================
        
        // Write Data A to Row 1
        write_rand_data(17'd1, expected_data_A);
        precharge_bank(); // MUST CLOSE BEFORE OPENING ROW 8!

        // Write Data B to Row 2
        write_rand_data(17'd2, expected_data_B);
        precharge_bank(); // MUST CLOSE BEFORE OPENING ROW 32!

        // Write Data C to Row 88
        write_rand_data(17'd88, expected_data_C);
        precharge_bank(); // MUST CLOSE BEFORE ROWCLONE!

        // RowClone Row 1 to Row 3 (destination in same subarray as source)
        `ifdef RowClone
        activate_row(17'd1);                 // Step 1: Open the Source
        trigger_LISA(17'd3);             // Step 2: Open the Dest (Triggers copy!)
        precharge_bank(); // CLOSE AFTER  ROWCLONE!
        `endif
        
        read_row_data_and_verify_expected_result(17'd1, expected_data_A);
        read_row_data_and_verify_expected_result(17'd3, expected_data_A);

        // precharge and back to idle
        ba = 1;
        A = 17'b01000000000000000;
        #tCK;
        assert ((dut.TimingFSMi.BankFSM[0][1] == 5'h0a) || (i==0)) $display("OK: precharge"); else $display(dut.TimingFSMi.BankFSM[0][1]);
        ba = 0;
        A = 17'b00000000000000000;
        sync[0][1] = 0;
        #((T_RP-1)*tCK);
        assert (dut.TimingFSMi.BankFSM[0][1] == 5'h00) $display("OK: idle"); else $display(dut.TimingFSMi.BankFSM[0][1]);
        #(2*tCK);
        // $finish();
        $stop();
    end;
    
endmodule
