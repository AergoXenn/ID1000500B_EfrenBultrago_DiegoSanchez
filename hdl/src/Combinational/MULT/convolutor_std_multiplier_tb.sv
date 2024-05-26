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

module convolutor_std_multiplier_tb ();

  localparam INPUT_WORD_SIZE = 8;
  localparam OUTPUT_WORD_SIZE = 2*INPUT_WORD_SIZE; 

  integer i;
  logic [INPUT_WORD_SIZE-1:0] word_a_i;
  logic [INPUT_WORD_SIZE-1:0] word_b_i;
  logic [OUTPUT_WORD_SIZE-1:0] word_c_o;

  convolutor_std_multiplier # (
    .INPUT_WORD_SIZE (INPUT_WORD_SIZE),
    .OUTPUT_WORD_SIZE(OUTPUT_WORD_SIZE)
    ) DUT_multiplier (
    .word_a_i(word_a_i),
    .word_b_i(word_b_i),
    .word_c_o(word_c_o)
    );

task multiply; 
  input [INPUT_WORD_SIZE-1:0] a;
  input [INPUT_WORD_SIZE-1:0] b;

  begin
    word_a_i = a; 
    word_b_i = b; 
    #1;
    $strobe("%d * %d = %d", word_a_i, word_b_i, word_c_o); 
  end

endtask : multiply

  initial begin
    for (i = 0; i < 2**INPUT_WORD_SIZE; i++) begin
      multiply($urandom_range(i), $urandom_range(i));
    end
    $finish;
  end

endmodule : convolutor_std_multiplier_tb