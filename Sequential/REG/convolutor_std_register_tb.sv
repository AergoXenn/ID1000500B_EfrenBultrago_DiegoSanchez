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

module convolutor_std_register_tb ();

  localparam DATA_WIDTH = 8;


  integer i; 
  logic clk; 
  logic rst_n; 
  logic clr_h;
  logic enable_h;
  logic [DATA_WIDTH-1:0] data_i; 
  logic [DATA_WIDTH-1:0] data_o; 


  convolutor_std_register DUT_register (
    .clk     (clk),
    .rst_n   (rst_n),
    .clr_h   (clr_h),
    .enable_h(enable_h),
    .data_i  (data_i),
    .data_o  (data_o)
    );

task load_reg;
  input [DATA_WIDTH-1:0] data; 

  begin
    enable_h = 1'b1;
    data_i = data; 
    @(posedge clk); 
    enable_h = 1'b0;  
    @(posedge clk);
  end
endtask : load_reg

  always begin
    clk = ~clk; 
    #5;
  end

  initial begin
    i = 0; 
    data_i = 'b0;
    clk = 1'b0;
    rst_n = 1'b0; 
    clr_h = 1'b0;
    enable_h = 1'b0;
    #1;
    rst_n = 1'b1;
    #1;

    for (i = 0; i < 2**DATA_WIDTH; i++) begin
      load_reg($urandom_range(i)); 
    end
    $finish;
  end

endmodule : convolutor_std_register_tb