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

module convolutor_upcounter_cmp_reg_tb ();

  localparam DATA_WIDTH = 8; 

  logic clk; 
  logic rst_n;
  logic rsts_n; 
  logic trig; 
  logic load_enable;
  logic mod_enable;
  logic ovf;
  logic [DATA_WIDTH-1:0] preload; 
  logic [DATA_WIDTH-1:0] modulus; 
  logic [DATA_WIDTH-1:0] cnt; 

  convolutor_upcounter_cmp_reg # (
    .DATA_WIDTH(DATA_WIDTH)
    ) DUT_counter (
    .clk              (clk),
    .rst_n            (rst_n),
    .clr_h           	(rsts_n),
    .trig_i           (trig),
    .load_enable_i    (load_enable),
    .mod_enable_i			(mod_enable),
    .preload_i        (preload),
    .modulus_i        (modulus),
    .cnt_o            (cnt),
    .overflow_o       (ovf)
    );

task count_to; 
  input [DATA_WIDTH-1:0] ld; 
  input [DATA_WIDTH-1:0] mod;

  begin
    load_enable = 1'b1;
    mod_enable = 1'b1;
    preload = ld;
    modulus = mod; 
    @(posedge clk);
    load_enable = 1'b0;
    mod_enable = 1'b0;    

    while (cnt != mod) begin
      trig = ~trig;
      @(posedge clk); 
    end
    
    #10;
    rst_n <= 1'b0;
    #10;
    rst_n <= 1'b1;
  end
endtask : count_to


    always begin
      clk = ~clk; 
      #5;
    end

    initial begin
      clk = 1'b0;
      rsts_n = 1'b1;
      rst_n = 1'b0;
      trig = 1'b0;
      load_enable = 1'b0;
      mod_enable = 1'b0;
      preload = 'b0;
      modulus = 'b0;
      #1;
      rst_n = 1'b1;

      count_to(0, 10);
      count_to(5, 25);

      $finish;
    end

endmodule : convolutor_upcounter_cmp_reg_tb