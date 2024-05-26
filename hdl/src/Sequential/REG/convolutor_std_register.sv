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

module convolutor_std_register # (
  parameter DATA_WIDTH = 8
  ) (
  input logic clk,
  input logic rst_n,
  input logic clr_h,
  input logic enable_h,
  input logic [DATA_WIDTH-1:0] data_i,
  output logic [DATA_WIDTH-1:0] data_o
);

  always_ff @(posedge clk or negedge rst_n) begin : proc_data_o
    if(~rst_n) begin
      data_o <= 0;
    end 
    else if (clr_h) begin
      data_o <= 0;
    end
    else if (enable_h) begin
      data_o <= data_i;
    end
    else begin
      data_o <= data_o;
    end
  end

endmodule : convolutor_std_register