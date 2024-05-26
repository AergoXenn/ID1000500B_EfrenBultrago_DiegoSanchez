`timescale 1ns/1ps
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

module convolutor_std_adder_tb ();

  localparam INPUT_WORD_SIZE = 8; 
  localparam OUTPUT_WORD_SIZE = 16;

  integer i;
  logic [INPUT_WORD_SIZE-1:0] word_A; 
  logic [INPUT_WORD_SIZE-1:0] word_B; 
  logic [OUTPUT_WORD_SIZE-1:0] word_C; 

  convolutor_std_adder_p # (
    .INPUT_WORD_SIZE(INPUT_WORD_SIZE), 
    .OUTPUT_WORD_SIZE(OUTPUT_WORD_SIZE)
    ) DUT_adder (
    .word_a_i(word_A),
    .word_b_i(word_B),
    .word_c_o(word_C)
    );

task add;
  input [INPUT_WORD_SIZE-1:0] A; 
  input [INPUT_WORD_SIZE-1:0] B; 

  begin
    word_A = A; 
    word_B = B; 
    #1;
  end

endtask : add

  initial begin
    for (i = 0; i < 2**INPUT_WORD_SIZE; i++) begin
      add($urandom_range(0,2**INPUT_WORD_SIZE), $urandom_range(0,2**INPUT_WORD_SIZE));
      $strobe("A: %d, B: %d, C: %d", word_A, word_B, word_C);
    end
  end


endmodule : convolutor_std_adder_tb