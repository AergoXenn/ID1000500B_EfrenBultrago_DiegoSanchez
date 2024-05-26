onerror { resume }
transcript off
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/clk}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/rst_n}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/rsts_n}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/trig_i}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/trigger_q}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/trigger_edge}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/load_enable_i}
add wave -noreg -hexadecimal -literal {/convolutor_upcounter_cmp_reg_tb/DUT_counter/preload_i}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/mod_load_enable_i}
add wave -noreg -hexadecimal -literal {/convolutor_upcounter_cmp_reg_tb/DUT_counter/modulus_i}
add wave -noreg -hexadecimal -literal {/convolutor_upcounter_cmp_reg_tb/DUT_counter/cnt_o}
add wave -noreg -hexadecimal -literal {/convolutor_upcounter_cmp_reg_tb/DUT_counter/cnt}
add wave -noreg -logic {/convolutor_upcounter_cmp_reg_tb/DUT_counter/overflow_o}
add wave -noreg -hexadecimal -literal {/convolutor_upcounter_cmp_reg_tb/DUT_counter/modulus}
cursor "Cursor 1" 15ns  
transcript on
