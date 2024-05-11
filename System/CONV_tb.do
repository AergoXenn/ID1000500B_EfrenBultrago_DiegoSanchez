onerror { resume }
transcript off
add wave -noreg -logic {/convolutor_tb/conv_top/control/clk}
add wave -noreg -logic {/convolutor_tb/conv_top/control/rst_n}
add wave -noreg -hexadecimal -literal {/convolutor_tb/conv_top/control/current_state}
add wave -noreg -hexadecimal -literal {/convolutor_tb/conv_top/control/next_state}
add wave -noreg -vgroup "Flags"  {/convolutor_tb/conv_top/control/start_i} {/convolutor_tb/conv_top/control/calculation_complete_flag_i} {/convolutor_tb/conv_top/control/half_loop_flag_i} {/convolutor_tb/conv_top/control/bounds_valid_flag_i} {/convolutor_tb/conv_top/control/register_load_flag_o} {/convolutor_tb/conv_top/control/diag_size_flag_o} {/convolutor_tb/conv_top/control/half_loop_load_en_o} {/convolutor_tb/conv_top/control/read_memory_flag_o} {/convolutor_tb/conv_top/control/get_product_flag_o} {/convolutor_tb/conv_top/control/add_product_flag_o} {/convolutor_tb/conv_top/control/iteration_count_flag_o} {/convolutor_tb/conv_top/control/z_write_o} {/convolutor_tb/conv_top/control/diagonal_count_flag_o} {/convolutor_tb/conv_top/control/busy_flag_o} {/convolutor_tb/conv_top/control/done_flag_o}
add wave -noreg -decimal -literal {/convolutor_tb/conv_top/x_addr}
add wave -noreg -decimal -literal {/convolutor_tb/conv_top/x_data}
add wave -noreg -decimal -literal {/convolutor_tb/conv_top/y_addr_o}
add wave -noreg -decimal -literal {/convolutor_tb/conv_top/y_data_i}
add wave -noreg -decimal -literal {/convolutor_tb/conv_top/z_addr_o}
add wave -noreg -decimal -literal {/convolutor_tb/conv_top/z_data_o}
add wave -noreg -decimal -literal {/convolutor_tb/conv_top/current_diagonal}
cursor "Cursor 1" 25001ns  
bookmark add 14.32ns
bookmark add 30.264ns
transcript on
