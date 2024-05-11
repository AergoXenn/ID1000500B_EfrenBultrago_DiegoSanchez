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

module convolutor #(
  parameter ADDR_WIDTH = 5, 
  parameter DATA_WIDTH = 8 
  ) (
  input logic clk,
  input logic rst_n,
  input logic start_i, 
  input logic [DATA_WIDTH-1:0] y_data_i, 
  input logic [ADDR_WIDTH-1:0] y_size_i, 
  output logic [ADDR_WIDTH-1:0] y_addr_o,
  output logic [2*DATA_WIDTH-1:0] z_data_o, 
  output logic [ADDR_WIDTH:0] z_addr_o,  
  output logic p_busy_o, 
  output logic p_done_o,				
	output logic z_write_en
);


/* *************************** FSM BEGIN ******************************** */  

  /* INPUTS */ 
  logic calculation_complete_flag; 
  logic half_loop_flag; 
  logic bounds_valid_flag; 

  /* OUTPUTS */ 
  logic load_registers_state_flag;
  logic get_size_state_flag; 
  logic read_mem_state_flag;
  logic half_loop_load_enable_flag; 
  logic get_product_state_flag;
  logic add_product_state_flag; 
  logic iteration_count_state_flag;
  logic diagonal_count_state_flag; 

  convolutor_fsm control (
    .clk                        (clk),
    .rst_n                      (rst_n),
    .start_i                    (start_i),
    .calculation_complete_flag_i(calculation_complete_flag),
    .half_loop_flag_i           (half_loop_flag),
    .bounds_valid_flag_i        (bounds_valid_flag),
    .register_load_flag_o       (load_registers_state_flag),
    .diag_size_flag_o           (get_size_state_flag), 
    .half_loop_load_en_o        (half_loop_load_enable_flag),
    .read_memory_flag_o         (read_mem_state_flag),
    .get_product_flag_o         (get_product_state_flag),
    .add_product_flag_o         (add_product_state_flag), 
    .iteration_count_flag_o     (iteration_count_state_flag), 
    .diagonal_count_flag_o      (diagonal_count_state_flag),
    .z_write_o                  (z_write_en),
    .busy_flag_o                (p_busy_o),
    .done_flag_o                (p_done_o)
    );

/* *************************** FSM END ********************************** */   
  


/* *************************** ROM BEGIN ******************************** */  

  localparam ROM_DEPTH = 32;

  logic [DATA_WIDTH-1:0] x_data; 
  logic [ADDR_WIDTH-1:0] x_size; 
  logic [ADDR_WIDTH-1:0] x_addr; 
  assign x_size = 'd5;

  convolutor_simple_rom_p # (
    .WIDTH  (DATA_WIDTH),
    .DEPTH  (ROM_DEPTH),
    .ADDRW  ($clog2(ROM_DEPTH)),
    .MEMFILE("./Sequential/ROM/MEMX.mem")
    ) conv_rom (
    .clk           (clk),
    .read_address_i(x_addr),
    .read_data_o   (x_data)
    );

/* *************************** ROM END ********************************** */ 


/* ******************************* SIZE ADDER BEGIN ********************* */  

  logic [ADDR_WIDTH:0] total_diagonals_temp; 
  logic [ADDR_WIDTH+1:0] total_diagonals; 
  logic [ADDR_WIDTH+1:0] size_reg;

  /* Diagonal size calculation: Step 1 - Absolute Size */ 
  convolutor_std_adder_p # (
    .INPUT_WORD_SIZE (ADDR_WIDTH),
    .OUTPUT_WORD_SIZE(ADDR_WIDTH+1)
    ) size_calc_01 (
    .word_a_i(x_size),
    .word_b_i(y_size_i), 
    .word_c_o(total_diagonals_temp)
    );

  /* Diagonal size calculation: Step 2 - Remove Size */   
  assign total_diagonals = $signed(total_diagonals_temp) - $signed(1);

  /* Diagonal size register : total_diagonals */
  convolutor_std_register # (
    .DATA_WIDTH(ADDR_WIDTH+2) //Why +2???
    ) size_register (
    .clk     (clk),
    .rst_n   (rst_n),
    .clr_h   (1'b0), //NOT IMPLEMENTED 
    .enable_h(get_size_state_flag), 
    .data_i  (total_diagonals),
    .data_o  (size_reg)
    );

/* ******************************* SIZE ADDER END ****************************** */  


/* *************************** DIAGONAL COUNTER BEGIN ************************** */  

  logic [DATA_WIDTH-1:0] current_diagonal; 

  /* Current diagonal register + counter */ 
  convolutor_upcounter_cmp_reg # (
    .DATA_WIDTH(DATA_WIDTH)
    ) current_diagonal_counter (
    .clk              (clk),
    .rst_n            (rst_n),
    .clr_h            (1'b0), //NOT IMPLEMENTED
    .trig_i           (diagonal_count_state_flag), //PENDING
    .load_enable_i    (1'b0), //NOT IMPLEMENTED 
    .mod_enable_i     (get_size_state_flag), //PENDING
    .preload_i        (8'b0),
    .modulus_i        ({3'b000, y_size_i}),
    .cnt_o            (current_diagonal),
    .overflow_o       (half_loop_flag)
    );

  /* Current diagonal comparator */ 
  convolutor_std_comparator_p # (
    .WORD_SIZE(DATA_WIDTH), 
    .TYPE     (0)
    ) diagonal_comparator (
    .word_a_i(current_diagonal), 
    .word_b_i(size_reg),
    .status_o(calculation_complete_flag)  
    );

/* *************************** DIAGONAL COUNTER END ************************** */  
 

/* ****************** X/Y DATA TEMPORARY REGISTER BEGIN ********************** */  

  logic [DATA_WIDTH-1:0] x_temp_data; 
  logic [DATA_WIDTH-1:0] y_temp_data; 

  convolutor_std_register # (
    .DATA_WIDTH(DATA_WIDTH)
    ) x_temporary_register  (
    .clk     (clk),
    .rst_n   (rst_n), 
    .clr_h   (1'b0), //MIGHT BE USEFUL LATER 
    .enable_h(read_mem_state_flag), 
    .data_i  (x_data),
    .data_o  (x_temp_data)
    ); 

  convolutor_std_register # (
    .DATA_WIDTH(DATA_WIDTH)
    ) y_temporary_register  (
    .clk     (clk),
    .rst_n   (rst_n), 
    .clr_h   (1'b0), //MIGHT BE USEFUL LATER 
    .enable_h(read_mem_state_flag), 
    .data_i  (y_data_i),
    .data_o  (y_temp_data)
    ); 

/* ****************** X/Y DATA TEMPORARY REGISTER END *********************** */ 

/* *************************** X_ADDRESS LOAD BEGIN ******************************** */

  localparam X_ADDR_SELECT_WIDTH = 1;
  logic [ADDR_WIDTH-1:0] x_addr_load; 
  logic [ADDR_WIDTH-1:0] x_zero_load; 
  logic [ADDR_WIDTH-1:0] x_current_diag_load; 

  assign x_zero_load = 'b0;
  assign x_current_diag_load = current_diagonal - y_size_i + 1;

  convolutor_mux_nxn_to_1xn # (
    .DATA_WIDTH(ADDR_WIDTH),
    .SEL_WIDTH (X_ADDR_SELECT_WIDTH)
    ) x_addr_load_mux (
    .mux_port_i  ({x_current_diag_load, x_zero_load}), //PENDING
    .mux_out_o   (x_addr_load), 
    .mux_select_i(half_loop_flag)
    );

/* *************************** X_ADDRESS LOAD END ********************************** */ 

/* *************************** Y_ADDRESS LOAD BEGIN ******************************** */

  localparam Y_ADDR_SELECT_WIDTH = 1;
  logic [ADDR_WIDTH-1:0] y_addr_load; 
  logic [ADDR_WIDTH-1:0] y_y_size_load; 
  logic [ADDR_WIDTH-1:0] y_current_diag_load; 

  assign y_y_size_load = y_size_i - 1;
  assign y_current_diag_load = current_diagonal;

  convolutor_mux_nxn_to_1xn # (
    .DATA_WIDTH(ADDR_WIDTH),
    .SEL_WIDTH (Y_ADDR_SELECT_WIDTH)
    ) y_addr_load_mux (
    .mux_port_i  ({y_y_size_load, y_current_diag_load}), //PENDING
    .mux_out_o   (y_addr_load), 
    .mux_select_i(half_loop_flag)
    );

/* *************************** Y_ADDRESS LOAD END ********************************** */

/* ************** X & Y ADDRESS MANAGEMENT BEGIN ******************************** */
  
  logic x_addr_overflow;
  logic y_addr_underflow;

  convolutor_upcounter_cmp_reg # (
    .DATA_WIDTH(ADDR_WIDTH)
    ) x_addr_count (
    .clk          (clk),
    .rst_n        (rst_n),
    .clr_h        (1'b0), //NOT IMPLEMENTED 
    .load_enable_i(half_loop_load_enable_flag),
    .mod_enable_i (1'b0),
    .preload_i    (x_addr_load),
    .modulus_i    (5'b0),
    .trig_i       (iteration_count_state_flag),
    .cnt_o        (x_addr),
    .overflow_o   (x_addr_overflow)
    );

    convolutor_downcounter_cmp_reg # (
    .DATA_WIDTH(ADDR_WIDTH)
    ) y_addr_count (
    .clk          (clk),
    .rst_n        (rst_n),
    .clr_h        (1'b0), //NOT IMPLEMENTED 
    .load_enable_i(half_loop_load_enable_flag),
    .mod_enable_i (1'b0),
    .preload_i    (y_addr_load),
    .modulus_i    (5'b0),
    .trig_i       (iteration_count_state_flag),
    .cnt_o        (y_addr_o),
    .underflow_o  (y_addr_underflow)
    );


/* ************** X & Y ADDRESS MANAGEMENT END ********************************** */ 


/* *************************** X & Y ADDR COMPARE BEGIN ************************* */  
  
  logic x_size_compare; 
  logic y_size_compare_bigger; 
  logic y_size_compare_equal; 
  logic y_size_compare;

  convolutor_std_comparator_p # (
    .WORD_SIZE(ADDR_WIDTH),
    .TYPE     (2) //Less-than comparator
    ) x_addr_cmp (
    .word_a_i(x_addr), 
    .word_b_i(x_size),
    .status_o(x_size_compare)
    );

  convolutor_std_comparator_p # (
    .WORD_SIZE(ADDR_WIDTH),
    .TYPE     (1) //Greater-than comparator
    ) y_addr_cmp_bigger (
    .word_a_i(y_addr_o), 
    .word_b_i(5'b0),
    .status_o(y_size_compare_bigger)
    );

  convolutor_std_comparator_p # (
    .WORD_SIZE(ADDR_WIDTH),
    .TYPE     (0)
    ) y_addr_cmp_equal (
    .word_a_i(y_addr_o), 
    .word_b_i(5'b0),
    .status_o(y_size_compare_equal)
    );

  assign y_size_compare = y_size_compare_bigger | y_size_compare_equal;
  assign bounds_valid_flag = y_size_compare & x_size_compare;


/* *************************** X & Y ADDR COMPARE END *********************** */ 


/* *************************** MULTIPLIER BEGIN ***************************** */  

  logic [2*DATA_WIDTH-1:0] x_y_product_temp; 

  convolutor_std_multiplier # (
    .INPUT_WORD_SIZE (DATA_WIDTH), 
    .OUTPUT_WORD_SIZE(2*DATA_WIDTH)
    ) x_y_multiplier (
    .word_a_i(x_temp_data),
    .word_b_i(y_temp_data),
    .word_c_o(x_y_product_temp)
    );

/* *************************** MULTIPLIER END ******************************** */ 


/* *************************** PRODUCT REGISTER BEGIN ************************ */  
  
  logic [2*DATA_WIDTH-1:0] x_y_product; 

  convolutor_std_register # (
    .DATA_WIDTH(2*DATA_WIDTH)
    ) product_register (
    .clk     (clk),
    .rst_n   (rst_n),
    .clr_h   (1'b0), //MIGHT BE USEFUL LATER 
    .enable_h(get_product_state_flag),
    .data_i  (x_y_product_temp), 
    .data_o  (x_y_product)
    ); 

/* *************************** PRODUCT REGISTER END ************************** */ 


/* *************************** PRODUCT ADDER BEGIN *************************** */ 

  logic [2*DATA_WIDTH-1:0] product_adder_out;

  convolutor_std_adder_p # (
    .INPUT_WORD_SIZE (2*DATA_WIDTH), 
    .OUTPUT_WORD_SIZE(2*DATA_WIDTH+1)
    ) x_y_product_adder (
    .word_a_i(x_y_product), 
    .word_b_i(product_accumulator_temp), 
    .word_c_o(product_adder_out)
    );

/* *************************** PRODUCT ADDER END ***************************** */ 


/* *************************** ACCUMULATOR BEGIN ***************************** */  

  logic [2*DATA_WIDTH-1:0] product_accumulator_temp;

  convolutor_std_register # (
    .DATA_WIDTH(2*DATA_WIDTH)
    ) x_y_product_accumulator (
    .clk     (clk),
    .rst_n   (rst_n),
    .clr_h   (diagonal_count_state_flag),  //NOT IMPLEMENTED 
    .enable_h(add_product_state_flag),
    .data_i  (product_adder_out),
    .data_o  (product_accumulator_temp)
    ); 

/* *************************** ACCUMULATOR END ******************************* */ 

/* *************************** Z_OUT BEGIN ***************************** */  

  logic [2*DATA_WIDTH-1:0] z_data_reg;
  assign z_data_o = z_data_reg;

  convolutor_std_register # (
    .DATA_WIDTH(2*DATA_WIDTH)
    ) z_data_reg_temp (
    .clk     (clk),
    .rst_n   (rst_n),
    .clr_h   (1'b0),  //NOT IMPLEMENTED 
    .enable_h(z_write_en),
    .data_i  (product_accumulator_temp),
    .data_o  (z_data_reg)
    ); 

/* *************************** Z_OUT END ******************************* */ 

/* *************************** Z ADDRESS COUNTER BEGIN *********************** */  

  logic [ADDR_WIDTH-1:0] z_address;
  logic z_address_overflow; //SHOULD NEVER HAPPEN  
  assign z_addr_o = z_address;

  convolutor_upcounter_cmp_reg # (
    .DATA_WIDTH(ADDR_WIDTH+1)
    ) z_address_counter (
    .clk          (clk),
    .rst_n        (rst_n),
    .clr_h        (1'b0), //NOT IMPLEMENTED
    .trig_i       (diagonal_count_state_flag),
    .load_enable_i(1'b0), //NOT IMPLEMENTED 
    .mod_enable_i (1'b0), //NOT IMPLEMENTED 
    .preload_i    (6'b0), //NOT IMPLEMENTED 
    .modulus_i    (6'b0), //NOT IMPLEMENTED 
    .cnt_o        (z_address),
    .overflow_o   (z_address_overflow)
    );

/* *************************** Z ADDRESS COUNTER END ************************* */ 



endmodule : convolutor