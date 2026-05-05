# Delete existing waves
delete wave *

# Global Settings
configure wave -signalnamewidth 1

# Group: IO -> clk_ct
add wave -noupdate -group "IO" -group "clk_ct" -label "ck_tp" /testbnch_DIMM/dut/ck_tp
add wave -noupdate -group "IO" -group "clk_ct" -label "ck_cn" /testbnch_DIMM/dut/ck_cn
add wave -noupdate -group "IO" -group "clk_ct" -label "ck2x" /testbnch_DIMM/dut/ck2x
add wave -noupdate -group "IO" -group "clk_ct" -label "cke" /testbnch_DIMM/dut/cke
add wave -noupdate -group "IO" -group "clk_ct" -label "reset_n" /testbnch_DIMM/dut/reset_n

# Group: IO -> Base Signals
add wave -noupdate -group "IO" -label "clk" /testbnch_DIMM/dut/clk
add wave -noupdate -group "IO" -label "act_n" /testbnch_DIMM/dut/act_n
add wave -noupdate -group "IO" -label "A" /testbnch_DIMM/dut/A
add wave -noupdate -group "IO" -label "bg" /testbnch_DIMM/dut/bg
add wave -noupdate -group "IO" -label "ba" /testbnch_DIMM/dut/ba
add wave -noupdate -group "IO" -label "cs_n" /testbnch_DIMM/dut/cs_n
add wave -noupdate -group "IO" -label "sync" /testbnch_DIMM/dut/sync
add wave -noupdate -group "IO" -radix hex -label "dq" /testbnch_DIMM/dut/dq
add wave -noupdate -group "IO" -radix hex -label "dqs_cn" /testbnch_DIMM/dut/dqs_cn
add wave -noupdate -group "IO" -radix hex -label "dqs_tp" /testbnch_DIMM/dut/dqs_tp

# Group: memtiming11 -> commandsT
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/ACT
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/BST
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/CFG
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/CKEH
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/CKEL
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/DPD
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/DPDX
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/MRR
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/MRW
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/PD
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/PDX
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/PR
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/PRA
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/RD
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/RDA
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/REF
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/SRF
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/WR
add wave -noupdate -group "memtiming11" -group "commandsT" /testbnch_DIMM/dut/TimingFSMi/WRA

# Group: memtiming11 -> timers
add wave -noupdate -group "memtiming11" -label "state" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/state
add wave -noupdate -group "memtiming11" -radix unsigned -label "tRASct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tRASct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tRCDct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tRCDct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tCLct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tCLct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tCWLct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tCWLct
add wave -noupdate -group "memtiming11" -radix unsigned -label "BSTct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/BSTct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tABAct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tABAct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tWRct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tWRct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tRFCct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tRFCct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tRPct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tRPct
add wave -noupdate -group "memtiming11" -radix unsigned -label "tRTPct" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/tRTPct

# Group: MEMSync11
add wave -noupdate -group "MEMSync11" -label "state" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/state
add wave -noupdate -group "MEMSync11" -label "tag_tbl" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/tag_tbl
add wave -noupdate -group "MEMSync11" -label "sync" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/sync
add wave -noupdate -group "MEMSync11" -label "WR" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/WR
add wave -noupdate -group "MEMSync11" -label "RD" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/RD
add wave -noupdate -group "MEMSync11" -label "dirty" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/dirty
add wave -noupdate -group "MEMSync11" -label "hit" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/hit
add wave -noupdate -group "MEMSync11" -label "nRowId" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/nRowId
add wave -noupdate -group "MEMSync11" -label "cRowId" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/cRowId
add wave -noupdate -group "MEMSync11" -label "ready" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/ready
add wave -noupdate -group "MEMSync11" -label "stall" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/stall
add wave -noupdate -group "MEMSync11" -label "RowId" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/RowId

# Group: CMDs -> commands
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/ACT
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/BST
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/CFG
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/CKEH
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/CKEL
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/DPD
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/DPDX
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/MRR
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/MRW
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/PD
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/PDX
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/PR
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/PRA
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/RD
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/RDA
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/REF
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/SRF
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/WR
add wave -noupdate -group "CMDs" -group "commands" /testbnch_DIMM/dut/CMDi/WRA

# Group: CMDs -> Array signals
add wave -noupdate -group "CMDs" -label "RowId" /testbnch_DIMM/dut/CMDi/RowId
add wave -noupdate -group "CMDs" -label "Burst" /testbnch_DIMM/dut/CMDi/Burst
add wave -noupdate -group "CMDs" -label "ColId" /testbnch_DIMM/dut/CMDi/ColId
add wave -noupdate -group "CMDs" -label "rd_o_wr" /testbnch_DIMM/dut/CMDi/rd_o_wr
add wave -noupdate -group "CMDs" -label "RDENs" /testbnch_DIMM/dut/RDENs
add wave -noupdate -group "CMDs" -label "RDEN" /testbnch_DIMM/dut/RDEN

# Top-level arrays
add wave -noupdate -label "cRowId" /testbnch_DIMM/dut/cRowId
add wave -noupdate -label "BankFSM" /testbnch_DIMM/dut/BankFSM

# Group: BankStates
add wave -noupdate -group "BankStates" -label "state00" /testbnch_DIMM/dut/TimingFSMi/BG[0]/MT[0]/MTi/state
add wave -noupdate -group "BankStates" -label "state01" /testbnch_DIMM/dut/TimingFSMi/BG[0]/MT[1]/MTi/state
add wave -noupdate -group "BankStates" -label "state02" /testbnch_DIMM/dut/TimingFSMi/BG[0]/MT[2]/MTi/state
add wave -noupdate -group "BankStates" -label "state03" /testbnch_DIMM/dut/TimingFSMi/BG[0]/MT[3]/MTi/state
add wave -noupdate -group "BankStates" -label "state10" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[0]/MTi/state
add wave -noupdate -group "BankStates" -label "state11" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[1]/MTi/state
add wave -noupdate -group "BankStates" -label "state12" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[2]/MTi/state
add wave -noupdate -group "BankStates" -label "state13" /testbnch_DIMM/dut/TimingFSMi/BG[1]/MT[3]/MTi/state
add wave -noupdate -group "BankStates" -label "state20" /testbnch_DIMM/dut/TimingFSMi/BG[2]/MT[0]/MTi/state
add wave -noupdate -group "BankStates" -label "state21" /testbnch_DIMM/dut/TimingFSMi/BG[2]/MT[1]/MTi/state
add wave -noupdate -group "BankStates" -label "state22" /testbnch_DIMM/dut/TimingFSMi/BG[2]/MT[2]/MTi/state
add wave -noupdate -group "BankStates" -label "state23" /testbnch_DIMM/dut/TimingFSMi/BG[2]/MT[3]/MTi/state
add wave -noupdate -group "BankStates" -label "state30" /testbnch_DIMM/dut/TimingFSMi/BG[3]/MT[0]/MTi/state
add wave -noupdate -group "BankStates" -label "state31" /testbnch_DIMM/dut/TimingFSMi/BG[3]/MT[1]/MTi/state
add wave -noupdate -group "BankStates" -label "state32" /testbnch_DIMM/dut/TimingFSMi/BG[3]/MT[2]/MTi/state
add wave -noupdate -group "BankStates" -label "state33" /testbnch_DIMM/dut/TimingFSMi/BG[3]/MT[3]/MTi/state

# Group: MEMSyncStates
add wave -noupdate -group "MEMSyncStates" -label "state00" /testbnch_DIMM/dut/MEMSyncTopi/BG[0]/B[0]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state01" /testbnch_DIMM/dut/MEMSyncTopi/BG[0]/B[1]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state02" /testbnch_DIMM/dut/MEMSyncTopi/BG[0]/B[2]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state03" /testbnch_DIMM/dut/MEMSyncTopi/BG[0]/B[3]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state10" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[0]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state11" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[1]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state12" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[2]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state13" /testbnch_DIMM/dut/MEMSyncTopi/BG[1]/B[3]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state20" /testbnch_DIMM/dut/MEMSyncTopi/BG[2]/B[0]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state21" /testbnch_DIMM/dut/MEMSyncTopi/BG[2]/B[1]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state22" /testbnch_DIMM/dut/MEMSyncTopi/BG[2]/B[2]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state23" /testbnch_DIMM/dut/MEMSyncTopi/BG[2]/B[3]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state30" /testbnch_DIMM/dut/MEMSyncTopi/BG[3]/B[0]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state31" /testbnch_DIMM/dut/MEMSyncTopi/BG[3]/B[1]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state32" /testbnch_DIMM/dut/MEMSyncTopi/BG[3]/B[2]/Mi/state
add wave -noupdate -group "MEMSyncStates" -label "state33" /testbnch_DIMM/dut/MEMSyncTopi/BG[3]/B[3]/Mi/state

# Group: DataSignals
add wave -noupdate -group "DataSignals" -label "dqo" /testbnch_DIMM/dut/dqo
add wave -noupdate -group "DataSignals" -label "dqi" /testbnch_DIMM/dut/dqi
add wave -noupdate -group "DataSignals" -label "chipdqi" /testbnch_DIMM/dut/chipdqi
add wave -noupdate -group "DataSignals" -label "chipdqo" /testbnch_DIMM/dut/chipdqo

# Group: ChipBank
add wave -noupdate -group "ChipBank" -label "rd_o_wr" /testbnch_DIMM/dut/R[0]/C[0]/Ci/rd_o_wr
add wave -noupdate -group "ChipBank" -label "dqin" /testbnch_DIMM/dut/R[0]/C[0]/Ci/dqin
add wave -noupdate -group "ChipBank" -label "dqout" /testbnch_DIMM/dut/R[0]/C[0]/Ci/dqout
add wave -noupdate -group "ChipBank" -label "row" /testbnch_DIMM/dut/R[0]/C[0]/Ci/row
add wave -noupdate -group "ChipBank" -radix unsigned -label "column" /testbnch_DIMM/dut/R[0]/C[0]/Ci/column

# Raw Array
add wave -noupdate -label "memory_array" /testbnch_DIMM/dut/R[0]/C[0]/Ci/BG[1]/BGi/B[1]/Bi/BA[0]/arrayi/memory_array

# Timing analysis
add wave -noupdate -group "TimingAnalysis" -radix unsigned -label "ideal_total_cycles" /testbnch_DIMM/dut/ideal_total_cycles
add wave -noupdate -group "TimingAnalysis" -radix unsigned -label "ideal_rowclone_cycles" /testbnch_DIMM/dut/ideal_rowclone_cycles
add wave -noupdate -group "TimingAnalysis" -radix unsigned -label "ideal_lisa_cycles" /testbnch_DIMM/dut/ideal_lisa_cycles

# Zoom to full
wave zoom full