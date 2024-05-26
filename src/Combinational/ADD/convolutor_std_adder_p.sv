///////////////////////////////////////////////////////////////
// Module:        <module_name>
// Author:        <author_name>
// Date:          <date>
// Description:   <Simple adder. C = A + B operation. >
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

module convolutor_std_adder_p #(
  parameter INPUT_WORD_SIZE = 8, 
  parameter OUTPUT_WORD_SIZE = (INPUT_WORD_SIZE+1)
  ) (
  input logic [INPUT_WORD_SIZE-1:0] word_a_i, 
  input logic [INPUT_WORD_SIZE-1:0] word_b_i, 
  output logic [OUTPUT_WORD_SIZE-1:0] word_c_o
);


  always_comb begin 
    word_c_o = word_a_i + word_b_i;
  end

endmodule : convolutor_std_adder_p