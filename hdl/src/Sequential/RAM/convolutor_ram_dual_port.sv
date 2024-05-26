///////////////////////////////////////////////////////////////
// Module:        <module_name>
// Author:        <author_name>
// Date:          <date>
// Description:   <brief description of the module>
// 
// Parameters:
//   - <parameter_name_1>: <parameter_desciption> [default: <default_value>]
//   - <parameter_name_2>: <parameter_description> [default: <default_value>] 
//r
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

module convolutor_ram_dual_port #(
  parameter DATA_WIDTH = 8, 
  parameter DEPTH = 16, 
  parameter ADDR_WIDTH = $clog2(DEPTH), 
  parameter MEMFILE = "RAM_DATA.txt"
  ) (
  input logic clk, 
  input logic write_enable_i,   
  input logic [ADDR_WIDTH-1:0] write_address_i,
  input logic [DATA_WIDTH-1:0] write_data_i,
  input logic [ADDR_WIDTH-1:0] read_address_i, 
  output logic [DATA_WIDTH-1:0] data_output_o
);

  integer i; 
	logic [DATA_WIDTH-1:0] ram [DEPTH-1:0]; 

  initial begin 
    $readmemh(MEMFILE, ram);
  end 

  always @ (posedge clk) begin
    if (write_enable_i)
      ram[write_address_i] <= write_data_i;

    data_output_o <= ram[read_address_i];
  end

endmodule : convolutor_ram_dual_port