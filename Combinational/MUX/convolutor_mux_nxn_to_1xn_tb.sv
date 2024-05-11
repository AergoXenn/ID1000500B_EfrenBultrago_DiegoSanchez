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

module convolutor_mux_nxn_to_1xn_tb (); 

  localparam DATA_WIDTH = 8; 
  localparam SEL_WIDTH = 1; 

  logic [2**SEL_WIDTH-1:0][DATA_WIDTH-1:0] data_i; 
  logic [DATA_WIDTH-1:0] data_o;
  logic sel; 

  convolutor_mux_nxn_to_1xn # (
    .DATA_WIDTH (DATA_WIDTH), 
    .SEL_WIDTH (SEL_WIDTH)
    ) DUT_mux (
    .mux_port_i  (data_i),
    .mux_select_i(sel),
    .mux_out_o   (data_o)
    );

    initial begin
      data_i[0] = 8'h01; 
      data_i[1] = 8'h02;
      sel = 0; 
      #10; 
      sel = 1; 
      #10;
      $finish;
    end

endmodule : convolutor_mux_nxn_to_1xn_tb