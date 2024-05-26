onerror { resume }
transcript off
add wave -noreg -hexadecimal -literal {/convolutor_std_comparator_p_tb/word_A}
add wave -noreg -hexadecimal -literal {/convolutor_std_comparator_p_tb/word_B}
add wave -noreg -logic {/convolutor_std_comparator_p_tb/equal}
add wave -noreg -logic {/convolutor_std_comparator_p_tb/greater_than}
add wave -noreg -logic {/convolutor_std_comparator_p_tb/less_than}
cursor "Cursor 1" 0ps  
transcript on
