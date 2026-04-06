# Delete existing waves
delete wave *

# Global Settings
configure wave -signalnamewidth 1

# Top Level Signals
add wave -noupdate -label "clk" /testbnch_Bank/clk
add wave -noupdate -label "rd_o_wr" /testbnch_Bank/rd_o_wr
add wave -noupdate -label "row" -radix unsigned /testbnch_Bank/row
add wave -noupdate -label "column" -radix unsigned /testbnch_Bank/column
add wave -noupdate -label "dqin" /testbnch_Bank/dqin
add wave -noupdate -label "dqout" /testbnch_Bank/dqout

# Divider: dut_Bank
add wave -noupdate -divider "dut_Bank"

# DUT Signals
add wave -noupdate -label "clk" /testbnch_Bank/dut/clk
add wave -noupdate -label "rd_o_wr" /testbnch_Bank/dut/rd_o_wr
add wave -noupdate -label "row" -radix unsigned /testbnch_Bank/dut/row
add wave -noupdate -label "column" -radix unsigned /testbnch_Bank/dut/column
add wave -noupdate -label "dqin" /testbnch_Bank/dut/dqin
add wave -noupdate -label "dqout" /testbnch_Bank/dut/dqout

# Group: array
add wave -noupdate -group "array" -label "addr" /testbnch_Bank/dut/arrayi/addr
add wave -noupdate -group "array" -label "rd_o_wr" /testbnch_Bank/dut/arrayi/rd_o_wr
add wave -noupdate -group "array" -label "i_data" /testbnch_Bank/dut/arrayi/i_data
add wave -noupdate -group "array" -label "o_data" /testbnch_Bank/dut/arrayi/o_data

# Zoom to full
wave zoom full
