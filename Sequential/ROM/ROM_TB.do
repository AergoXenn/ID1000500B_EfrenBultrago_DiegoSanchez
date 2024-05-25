onerror { resume }
transcript off
add wave -noreg -logic {/convolutor_simple_rom_p_tb/clk_tb}
add wave -noreg -hexadecimal -literal {/convolutor_simple_rom_p_tb/address_tb}
add wave -noreg -hexadecimal -literal {/convolutor_simple_rom_p_tb/data_tb}
add wave -noreg -hexadecimal -literal {/convolutor_simple_rom_p_tb/DUT_rom/rom}
cursor "Cursor 1" 190.9ns  
transcript on
