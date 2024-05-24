///////////////////////////////////////////////////////////////
// Module:        Convolutor 
// Author:        <Alex Kelly>
// Date:          <May 23rd 2024>
// Description:   <Top level of convolution coprocessor>
// 
// Parameters:
//   - <ADDR_WIDTH>: <Width of the input address buses> [default: <5>]
//   - <DATA_WIDTH>: <Width of the input data buses > [default: <8>] 
//
// Clocks:
//   - <clk>: <Main clock>
//
// Inputs:
//   - <rst_n>: <Asynchronous module reset.>
//   - <start>: <input_description> 
//   - <dataY>: <input_description> 
//   - <sizeY>: <input_description> 
// Outputs:
//   - <memY_addr>: <Address of Y memory>
//   - <dataZ>: <Z memory data output>
//   - <memZ_addr>: <Address of Z memory> 
//   - <busy>: <Busy status flag> 
//   - <done>: <Done status flag> 
//   - <writeZ>: <Z memory write enable> 
//
///////////////////////////////////////////////////////////////

module convolutor #(
  parameter ADDR_WIDTH = 5, 
  parameter DATA_WIDTH = 8 
  ) (
  input logic clk,
  input logic rst_n,
  input logic start, 
  input logic [DATA_WIDTH-1:0] dataY, 
  input logic [ADDR_WIDTH-1:0] sizeY, 
  output logic [ADDR_WIDTH-1:0] memY_addr,
  output logic [2*DATA_WIDTH-1:0] dataZ, 
  output logic [ADDR_WIDTH:0] memZ_addr,  
  output logic busy, 
  output logic done,				
	output logic writeZ
);

/* *************************** SIGNALS BEGIN ******************************** */

  /* FSM SIGNALS BEGIN */
  logic calculation_complete_flag; 
  logic half_loop_flag; 
  logic bounds_valid_flag; 

  logic load_registers_state_flag;
  logic get_size_state_flag; 
  logic read_mem_state_flag;
  logic half_loop_load_enable_flag; 
  logic get_product_state_flag;
  logic add_product_state_flag; 
  logic iteration_count_state_flag;
  logic diagonal_count_state_flag; 

  localparam ROM_DEPTH = 32;
  logic [DATA_WIDTH-1:0] x_data; 
  logic [ADDR_WIDTH-1:0] x_size; 
  logic [ADDR_WIDTH-1:0] x_addr; 

  logic [5:0] total_diagonals_temp; 
  logic [5:0] total_diagonals; 
  logic [5:0] size_reg;

  logic [5:0] current_diagonal; 

  logic [DATA_WIDTH-1:0] x_temp_data; 
  logic [DATA_WIDTH-1:0] y_temp_data; 

  logic [ADDR_WIDTH-1:0] x_addr_load; 
  logic [ADDR_WIDTH-1:0] x_zero_load; 
  logic [ADDR_WIDTH-1:0] x_current_diag_load; 

  logic [ADDR_WIDTH-1:0] y_addr_load; 
  logic [ADDR_WIDTH-1:0] y_y_size_load; 
  logic [ADDR_WIDTH-1:0] y_current_diag_load; 

  logic x_addr_overflow;
  logic y_addr_underflow;

  logic x_size_compare; 
  logic y_size_compare_bigger; 
  logic y_size_compare_equal; 
  logic y_size_compare;

  logic [2*DATA_WIDTH-1:0] x_y_product_temp; 

  logic [2*DATA_WIDTH-1:0] x_y_product; 

  logic [2*DATA_WIDTH-1:0] product_adder_out;

  logic [2*DATA_WIDTH-1:0] product_accumulator_temp;

  logic [2*DATA_WIDTH-1:0] z_data_reg;

  logic [1+ADDR_WIDTH-1:0] z_address;
  logic z_address_overflow; //SHOULD NEVER HAPPEN  

/* *************************** SIGNALS END ********************************** */


/* *************************** FSM BEGIN ******************************** */  

  convolutor_fsm control (
    .clk                        (clk),
    .rst_n                      (rst_n),
    .start_i                    (start),
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
    .z_write_o                  (writeZ),
    .busy_flag_o                (busy),
    .done_flag_o                (done)
    );

/* *************************** FSM END ********************************** */   
  

/* *************************** ROM BEGIN ******************************** */  

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

  /* Diagonal size calculation: Step 1 - Absolute Size */ 
  convolutor_std_adder_p # (
    .INPUT_WORD_SIZE (5),
    .OUTPUT_WORD_SIZE(6)
    ) size_calc_01 (
    .word_a_i(x_size),
    .word_b_i(sizeY), 
    .word_c_o(total_diagonals_temp)
    );

  /* Diagonal size calculation: Step 2 - Remove Size */   
  assign total_diagonals = $signed(total_diagonals_temp) - $signed(1);

  /* Diagonal size register : total_diagonals */
  convolutor_std_register # (
    .DATA_WIDTH(6) //Why +2???
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

  /* Current diagonal register + counter */ 
  convolutor_upcounter_cmp_reg # (
    .DATA_WIDTH(6)
    ) current_diagonal_counter (
    .clk              (clk),
    .rst_n            (rst_n),
    .clr_h            (1'b0), //NOT IMPLEMENTED
    .trig_i           (diagonal_count_state_flag), //PENDING
    .load_enable_i    (1'b0), //NOT IMPLEMENTED 
    .mod_enable_i     (get_size_state_flag), //PENDING
    .preload_i        (6'b0),
    .modulus_i        ({1'b0, sizeY}),
    .cnt_o            (current_diagonal),
    .overflow_o       (half_loop_flag)
    );

  /* Current diagonal comparator */ 
  convolutor_std_comparator_p # (
    .WORD_SIZE(6), 
    .TYPE     (0)
    ) diagonal_comparator (
    .word_a_i(current_diagonal), 
    .word_b_i(size_reg),
    .status_o(calculation_complete_flag)  
    );

/* *************************** DIAGONAL COUNTER END ************************** */  
 

/* ****************** X/Y DATA TEMPORARY REGISTER BEGIN ********************** */  

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
    .data_i  (dataY),
    .data_o  (y_temp_data)
    ); 

/* ****************** X/Y DATA TEMPORARY REGISTER END *********************** */ 


/* *************************** X_ADDRESS LOAD BEGIN ******************************** */

  localparam X_ADDR_SELECT_WIDTH = 1;

  assign x_zero_load = 'b0;
  assign x_current_diag_load = current_diagonal - sizeY + 1;

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

  assign y_y_size_load = sizeY - 1;
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
    .cnt_o        (memY_addr),
    .underflow_o  (y_addr_underflow)
    );

/* ************** X & Y ADDRESS MANAGEMENT END ********************************** */ 


/* *************************** X & Y ADDR COMPARE BEGIN ************************* */  

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
    .word_a_i(memY_addr), 
    .word_b_i(5'b0),
    .status_o(y_size_compare_bigger)
    );

  convolutor_std_comparator_p # (
    .WORD_SIZE(ADDR_WIDTH),
    .TYPE     (0)
    ) y_addr_cmp_equal (
    .word_a_i(memY_addr), 
    .word_b_i(5'b0),
    .status_o(y_size_compare_equal)
    );

  assign y_size_compare = y_size_compare_bigger | y_size_compare_equal;
  assign bounds_valid_flag = y_size_compare & x_size_compare;

/* *************************** X & Y ADDR COMPARE END *********************** */ 


/* *************************** MULTIPLIER BEGIN ***************************** */  

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

  convolutor_std_adder_p # (
    .INPUT_WORD_SIZE (2*DATA_WIDTH), 
    .OUTPUT_WORD_SIZE(2*DATA_WIDTH)
    ) x_y_product_adder (
    .word_a_i(x_y_product), 
    .word_b_i(product_accumulator_temp), 
    .word_c_o(product_adder_out)
    );

/* *************************** PRODUCT ADDER END ***************************** */ 


/* *************************** ACCUMULATOR BEGIN ***************************** */  
	
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

  assign dataZ = z_data_reg;

  convolutor_std_register # (
    .DATA_WIDTH(2*DATA_WIDTH)
    ) z_data_reg_temp (
    .clk     (clk),
    .rst_n   (rst_n),
    .clr_h   (1'b0),  //NOT IMPLEMENTED 
    .enable_h(writeZ),
    .data_i  (product_accumulator_temp),
    .data_o  (z_data_reg)
    ); 

/* *************************** Z_OUT END ******************************* */ 


/* *************************** Z ADDRESS COUNTER BEGIN *********************** */  

  assign memZ_addr = z_address;

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