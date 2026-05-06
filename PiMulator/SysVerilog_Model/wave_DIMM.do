# Delete existing waves
delete wave *

# Global Settings
configure wave -signalnamewidth 1


# Top-level arrays
add wave -noupdate -label "cRowId" /testbnch_DIMM/dut/cRowId

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

add wave -noupdate -group "CMDs" -label "RowId" /testbnch_DIMM/dut/CMDi/RowId
add wave -noupdate -group "CMDs" -label "Burst" /testbnch_DIMM/dut/CMDi/Burst
add wave -noupdate -group "CMDs" -label "ColId" /testbnch_DIMM/dut/CMDi/ColId
add wave -noupdate -group "CMDs" -label "rd_o_wr" /testbnch_DIMM/dut/CMDi/rd_o_wr
add wave -noupdate -group "CMDs" -label "should_enable_ambit" /testbnch_DIMM/dut/CMDi/should_enable_ambit

# Raw Array
add wave -noupdate -label "memory_array" /testbnch_DIMM/dut/R[0]/C[0]/Ci/BG[0]/BGi/B[1]/Bi/BA[0]/arrayi/memory_array

# Timing analysis
add wave -noupdate -group "TimingAnalysis" -radix unsigned -label "ideal_total_cycles" /testbnch_DIMM/dut/ideal_total_cycles
add wave -noupdate -group "TimingAnalysis" -radix unsigned -label "ideal_rowclone_cycles" /testbnch_DIMM/dut/ideal_rowclone_cycles
add wave -noupdate -group "TimingAnalysis" -radix unsigned -label "ideal_lisa_cycles" /testbnch_DIMM/dut/ideal_lisa_cycles

add wave marker 2845ns -name "Start_of_XOR_Operation"


# Zoom to full
wave zoom full