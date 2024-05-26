onerror { resume }
transcript off
add wave -noreg -decimal -literal {/convolutor_tb/DUT_convolutor/size_calc_01/word_a_i}
add wave -noreg -decimal -literal {/convolutor_tb/DUT_convolutor/size_calc_01/word_b_i}
add wave -noreg -decimal -literal {/convolutor_tb/DUT_convolutor/size_calc_01/word_c_o}
add wave -named_row "Second Adder"
add wave -noreg -decimal -literal {/convolutor_tb/DUT_convolutor/size_calc_02/word_a_i}
add wave -noreg -decimal -literal -signed2 {/convolutor_tb/DUT_convolutor/size_calc_02/word_b_i}
add wave -noreg -decimal -literal -magnitude {/convolutor_tb/DUT_convolutor/size_calc_02/word_c_o}
add wave -named_row "Register"
add wave -noreg -logic {/convolutor_tb/DUT_convolutor/size_register/clk}
add wave -noreg -logic {/convolutor_tb/DUT_convolutor/size_register/rst_n}
add wave -noreg -logic {/convolutor_tb/DUT_convolutor/size_register/clr_h}
add wave -noreg -logic {/convolutor_tb/DUT_convolutor/size_register/enable_h}
add wave -noreg -decimal -literal {/convolutor_tb/DUT_convolutor/size_register/data_i}
add wave -noreg -decimal -literal {/convolutor_tb/DUT_convolutor/size_register/data_o}
cursor "Cursor 1" 131ns  
transcript on
