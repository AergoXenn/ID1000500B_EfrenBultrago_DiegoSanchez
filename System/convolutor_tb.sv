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


module convolutor_tb ();

  localparam ADDR_WIDTH = 5;
  localparam DATA_WIDTH = 8;

  int i;
  logic clk; 
  logic rst_n; 							
	logic start_i;
  logic busy; 
  logic zwr; 
  logic done;
  logic z_dout; 
  logic [DATA_WIDTH-1:0] y_data;
  logic [2*DATA_WIDTH-1:0] z_data; 
  logic [ADDR_WIDTH-1:0] y_addr;
  logic [ADDR_WIDTH:0] z_addr; 		

  convolutor conv_top (
    .clk       (clk), 
    .rst_n     (rst_n),
    .start_i   (start_i),
    .y_data_i  (y_data),
    .y_addr_o  (y_addr),
    .y_size_i  (5'd5),
    .z_data_o  (z_data), 
    .z_addr_o  (z_addr),
    .p_busy_o  (busy),
    .p_done_o  (done),
    .z_write_en(zwr)
    ); 

  convolutor_ram_dual_port # (
    .DATA_WIDTH(DATA_WIDTH), 
    .DEPTH(32),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MEMFILE   ("./Sequential/RAM/MEMY.mem")
    ) Y_RAM (
    .clk            (clk),
    .read_address_i (y_addr),
    .data_output_o  (y_data),
    .write_enable_i (1'b0),
    .write_address_i(5'b0),
    .write_data_i   (8'b0)
    );

  convolutor_ram_dual_port # (
    .DATA_WIDTH(16), 
    .DEPTH(64),
    .ADDR_WIDTH(6),
    .MEMFILE   ("./Sequential/RAM/MEMZ.mem")
    ) Z_RAM (
    .clk            (clk),
    .read_address_i (6'b0),
    .data_output_o  (z_dout),
    .write_enable_i (zwr),
    .write_address_i(z_addr),
    .write_data_i   (z_data)
    );

  always begin
    clk = ~clk; 
    #5;
  end

  initial begin
    start_i = 0;
    clk = 1'b0;
    rst_n = 1'b0;
    #1; 
    rst_n = 1'b1;
    start_i = 1'b1;  

    #3000;       
    $finish;         
  end

endmodule : convolutor_tb