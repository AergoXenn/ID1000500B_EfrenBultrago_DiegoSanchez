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

module convolutor_ram_dual_port_tb ();

  localparam DATA_WIDTH = 8;
  localparam ADDR_WIDTH = 5;

  integer i;
  logic clk;
  logic write_enable_i; 
  logic [ADDR_WIDTH-1:0] write_address_i;
  logic [DATA_WIDTH-1:0] write_data_i;  
  logic [ADDR_WIDTH-1:0] read_address_i;
  logic [DATA_WIDTH-1:0] data_output_o;

  convolutor_ram_dual_port # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
    ) DUT_ram (
    .clk            (clk),
    .write_enable_i (write_enable_i),
    .write_address_i(write_address_i),
    .write_data_i   (write_data_i),
    .read_address_i (read_address_i),
    .data_output_o  (data_output_o)
    );

  always begin
    clk = ~clk; 
    #5;
  end


task ram_write_data; 
  input [DATA_WIDTH-1:0] data; 
  input [ADDR_WIDTH-1:0] addr; 

  begin
    write_enable_i = 1'b1;
    write_data_i = data;
    write_address_i = addr; 
    @(posedge clk);
    write_enable_i = 1'b0;
  end
endtask : ram_write_data

task ram_read_data; 
  input [ADDR_WIDTH-1:0] addr; 

  begin
    read_address_i = addr;
    @(negedge clk);
  end
endtask : ram_read_data

  initial begin
    clk = 1'b0;
    read_address_i = 'h1A;

    for (i = 0; i < 2**ADDR_WIDTH; i++) begin
      ram_write_data($urandom_range(255, 0), i);
      ram_read_data(i);
    end

    $finish;
  end

endmodule : convolutor_ram_dual_port_tb