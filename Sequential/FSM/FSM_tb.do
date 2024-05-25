onerror { resume }
transcript off
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/clk}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/rst_n}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/start_h}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/half_loop_load}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/loop_bound_valid_h}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/load_enable_h}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/size_enable_h}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/ram_read_enable_h}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/mult_enable_h}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/addr_diag_count_h}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/p_busy_o}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/p_zwrite_o}
add wave -noreg -logic {/convolutor_fsm_tb/DUT_fsm/p_done_o}
add wave -noreg -hexadecimal -literal {/convolutor_fsm_tb/DUT_fsm/current_state}
add wave -noreg -hexadecimal -literal {/convolutor_fsm_tb/DUT_fsm/next_state}
cursor "Cursor 1" 0ps  
transcript on
