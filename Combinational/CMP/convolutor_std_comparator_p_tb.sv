`timescale 1ns/100ps
///////////////////////////////////////////////////////////////
// Module:        <module_name>
// Author:        <author_name>
// Date:          <date>
// Description:   <brief description of the module>
// 
// Parameters:
//   - <parameter_name_1>: <parameter_description> [default: <default_value>]
//   - <parameter_name_2>: <parameter_description> [default: <default_value>] 
//
// Clocks:
//   - <clock_name_1>: <clock_description>
//   - <clock_name_2>: <clock_description> (add more clocks as needed)
//
// Inputs:
//   - <input_name_1>: <input_description>
//   - <input_name_2>: <input_description> (add more inputs as needed)
//
// Outputs:
//   - <output_name_1>: <output_description>
//   - <output_name_2>: <output_description> (add more outputs as needed)
//
// Revision history:
//   - <version> (<date>): <changes_made>
//
///////////////////////////////////////////////////////////////

module convolutor_std_comparator_p_tb (); 

  localparam WORD_SIZE = 8;

  integer i;
  logic [WORD_SIZE-1:0] word_A;
  logic [WORD_SIZE-1:0] word_B;
  logic equal;
  logic greater_than; 
  logic less_than;

  convolutor_std_comparator_p # (
    .WORD_SIZE(WORD_SIZE), 
    .TYPE(0)
    ) DUT_comp_equal (
    .word_a_i (word_A),
    .word_b_i (word_B),
    .status_o (equal)
    );

    convolutor_std_comparator_p # (
    .WORD_SIZE(WORD_SIZE), 
    .TYPE(1)
    ) DUT_comp_greater (
    .word_a_i (word_A),
    .word_b_i (word_B),
    .status_o(greater_than)
    );
		
    convolutor_std_comparator_p # (
    .WORD_SIZE(WORD_SIZE), 
    .TYPE(2)
    ) DUT_comp_less (
    .word_a_i (word_A),
    .word_b_i (word_B),
    .status_o (less_than)
    );

task compare;
  input [WORD_SIZE-1:0] A; 
  input [WORD_SIZE-1:0] B; 

  begin
    word_A = A;
    word_B = B; 
    #1;
  end

endtask : compare

	initial begin 
    for (i = 0; i < 2**WORD_SIZE; i++) begin
      compare($urandom_range(0,i), $urandom_range(0,i));
      $strobe("S: %d, Eq: %d, Ge: %d, Le: %d", i, equal, greater_than, less_than);
    end
  end 

endmodule : convolutor_std_comparator_p_tb