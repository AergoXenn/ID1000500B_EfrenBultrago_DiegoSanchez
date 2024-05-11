onerror { resume }
transcript off
add wave -noreg -logic {/convolutor_std_register_tb/clk}
add wave -noreg -logic {/convolutor_std_register_tb/rst_n}
add wave -noreg -logic {/convolutor_std_register_tb/clr_h}
add wave -noreg -logic {/convolutor_std_register_tb/enable_h}
add wave -noreg -decimal -literal -signed2 {/convolutor_std_register_tb/i}
add wave -noreg -decimal -literal {/convolutor_std_register_tb/data_i}
add wave -noreg -hexadecimal -literal {/convolutor_std_register_tb/data_o}
cursor "Cursor 1" 852.9ns  
transcript on
