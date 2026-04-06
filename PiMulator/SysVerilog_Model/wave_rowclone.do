# Delete existing waves
delete wave *

# Global Settings
configure wave -signalnamewidth 1

# Divider: DUT Top Level
add wave -noupdate -divider "DUT Top Level"
add wave -noupdate -label "clk" /testbnch_TimingFSM/dut/clk
add wave -noupdate -label "reset_n" /testbnch_TimingFSM/dut/reset_n
add wave -noupdate -label "bg" /testbnch_TimingFSM/dut/bg
add wave -noupdate -label "ba" /testbnch_TimingFSM/dut/ba
add wave -noupdate -label "ACT" /testbnch_TimingFSM/dut/ACT
add wave -noupdate -label "WR" /testbnch_TimingFSM/dut/WR
add wave -noupdate -label "WRA" /testbnch_TimingFSM/dut/WRA
add wave -noupdate -label "RD" /testbnch_TimingFSM/dut/RD
add wave -noupdate -label "RDA" /testbnch_TimingFSM/dut/RDA
add wave -noupdate -label "PR" /testbnch_TimingFSM/dut/PR
add wave -noupdate -label "REF" /testbnch_TimingFSM/dut/REF

# Divider: BankFSM Array
add wave -noupdate -divider "BankFSM Output"
add wave -noupdate -label "BankFSM" /testbnch_TimingFSM/BankFSM

# Divider: Bank 1, Group 1 State Machine (MTi)
add wave -noupdate -divider "BG[1].MT[1] FSM"
add wave -noupdate -label "clk" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/clk
add wave -noupdate -label "rst" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/rst
add wave -noupdate -label "state" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/state
add wave -noupdate -label "nextstate" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/nextstate
add wave -noupdate -radix unsigned -label "tRCDct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/tRCDct
add wave -noupdate -radix unsigned -label "tCLct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/tCLct
add wave -noupdate -radix unsigned -label "BSTct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/BSTct
add wave -noupdate -radix unsigned -label "tRPct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/tRPct
add wave -noupdate -radix unsigned -label "tRFCct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/tRFCct
add wave -noupdate -radix unsigned -label "tWRct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/tWRct
add wave -noupdate -label "tABAct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/tABAct
add wave -noupdate -radix unsigned -label "tABARct" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/tABARct
add wave -noupdate -label "T_CL" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/T_CL
add wave -noupdate -label "T_RCD" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/T_RCD
add wave -noupdate -label "T_RP" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/T_RP
add wave -noupdate -label "T_RFC" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/T_RFC
add wave -noupdate -label "BL" /testbnch_TimingFSM/dut/BG[1]/MT[1]/MTi/BL

# Zoom to full
wave zoom full