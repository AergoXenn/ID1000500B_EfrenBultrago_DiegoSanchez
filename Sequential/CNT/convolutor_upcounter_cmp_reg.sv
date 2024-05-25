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

module convolutor_upcounter_cmp_reg # (
  parameter DATA_WIDTH = 8
  ) (
  input logic clk,    // Clock
  input logic rst_n,  // Asynchronous reset active low
  input logic clr_h, // Synchronous reset active low 
  input logic trig_i, // Count trigger 
  input logic load_enable_i, 
  input logic mod_enable_i, 
  input logic [DATA_WIDTH-1:0] preload_i, //Counter preload value
  input logic [DATA_WIDTH-1:0] modulus_i, //Modulus of counter
  output logic [DATA_WIDTH-1:0] cnt_o, //Count output
  output logic overflow_o //overflow indicator
);

  logic trigger_edge;
  logic trigger_q; 

  logic [DATA_WIDTH-1:0] cnt;
  logic [DATA_WIDTH-1:0] modulus; 

  /* Modulus */ 
  always_ff @(posedge clk or negedge rst_n) begin : proc_modulus
    if(~rst_n) begin
      modulus <= 0;
    end 
    else if (clr_h) begin
      modulus <= 0;
    end

    if (mod_enable_i) begin
      modulus <= modulus_i;
      overflow_o <= 1'b0;
    end

    if (cnt >= modulus && cnt != 0) begin
      overflow_o <= 1'b1;
    end
    else begin
      overflow_o <= 1'b0;
    end
  end

  /* Counter & modulus */ 
  assign cnt_o = cnt; 
  always_ff @(posedge clk or negedge rst_n) begin : proc_cnt
    if(~rst_n) begin //Asynchronous reset
      cnt <= 0;
    end 
    else if (clr_h) begin
      cnt <= 0;
    end
    
    if (load_enable_i) begin
      cnt <= preload_i; 
    end

    if (trig_i) begin //Count 
      cnt <= cnt + 1;
    end
  end

endmodule : convolutor_upcounter_cmp_reg