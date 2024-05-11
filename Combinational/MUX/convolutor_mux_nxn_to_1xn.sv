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

module convolutor_mux_nxn_to_1xn # (
  parameter DATA_WIDTH = 8, 
  parameter SEL_WIDTH = 3
  ) (
  input logic [2**SEL_WIDTH-1:0][DATA_WIDTH-1:0] mux_port_i, 
  input logic [SEL_WIDTH-1:0] mux_select_i, 
  output logic [DATA_WIDTH-1:0] mux_out_o
  );

  assign mux_out_o = mux_port_i[mux_select_i];

endmodule : convolutor_mux_nxn_to_1xn