onerror { resume }
transcript off
add wave -noreg -logic {/convolutor_ram_dual_port_tb/DUT_ram/clk}
add wave -noreg -logic {/convolutor_ram_dual_port_tb/DUT_ram/write_enable_i}
add wave -noreg -hexadecimal -literal {/convolutor_ram_dual_port_tb/DUT_ram/write_address_i}
add wave -noreg -hexadecimal -literal {/convolutor_ram_dual_port_tb/DUT_ram/write_data_i}
add wave -noreg -hexadecimal -literal {/convolutor_ram_dual_port_tb/DUT_ram/read_address_i}
add wave -noreg -hexadecimal -literal {/convolutor_ram_dual_port_tb/DUT_ram/data_output_o}
add wave -noreg -hexadecimal -literal {/convolutor_ram_dual_port_tb/DUT_ram/ram}
cursor "Cursor 1" 15ns  
transcript on
