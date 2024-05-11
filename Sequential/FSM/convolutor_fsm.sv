///////////////////////////////////////////////////////////////
// Module:        <convolutor_fsm>
// Author:        <Alejandro Kelly>
// Date:          <01/05/2024>
// Description:   <Finite state machine for convolutor>
//
// Inputs:
//   - <start_h>: <Start condition for computation.>
//   - <half_loop_load>: <Load signal, defines which type of data to load.>
//   - <loop_bound_valid>: <Condition for loop.> 
//   - <input_name_2>: <input_description> 
//   - <input_name_2>: <input_description> 
//   - <input_name_2>: <input_description> 
//
// Outputs:
//   - <load_enable_h>: <Active-high enable for SoC data into internal registers.> 
//   - <size_enable_h>: <Active-high enable for size calculation block.> 
//   - <ram_read_enable_h>: <Active-high enable for ram/rom reading. > 
//   - <mult_enable_h>: <Active-high enable for multiplication block.> 
//   - <addr_diag_count_h>: <Active-high for address loading.> 
//   - <output_name_2>: <output_description> 
//
// Revision history:
//   - <version> (<date>): <changes_made>
//
///////////////////////////////////////////////////////////////

module convolutor_fsm (
	input logic clk, 
	input logic rst_n, 
	input logic start_i, 
	input logic calculation_complete_flag_i, 
	input logic half_loop_flag_i, 
	input logic bounds_valid_flag_i, 
	output logic register_load_flag_o, 
	output logic diag_size_flag_o, 
	output logic half_loop_load_en_o, 
	output logic read_memory_flag_o, 
	output logic get_product_flag_o, 
	output logic add_product_flag_o, 
	output logic iteration_count_flag_o,
	output logic z_write_o, 
	output logic diagonal_count_flag_o, 
	output logic busy_flag_o, 
	output logic done_flag_o 
	); 

	typedef enum logic [4:0] {
		_init = 					5'b00000,
		register_load, //Controls master initialization enable
		get_diag_size, //Controls get size enable
		preload, 
		load_half_l, 
		load_half_h, 
		loaded, 
		read_mem, //Controls X & Y temp enable
		get_product, //Controls product enable
		product_stable, 
		add_product, //Controls accumulator enable
		iteration_count, //Controls Up-down counter enable
		z_write_en, 
		z_set_data, 
		z_write_dis, 
		diagonal_count, 
		p_busy_l,
		p_done_h,
		p_done_l 
	} fsm_state_t;

	fsm_state_t current_state; 
	fsm_state_t next_state; 

	/* State keeping block */
	always_ff @(posedge clk or negedge rst_n) begin : fsm_state
		if (~rst_n) begin
			current_state <= _init;
		end 
		else begin 
			current_state = next_state;
		end
	end : fsm_state
	
/* Next state logic */
always_comb begin : fsm_next
    next_state = current_state;
    case (current_state)
        _init: begin
            if (start_i)
                next_state = register_load;
        end
        
        register_load: begin
            next_state = get_diag_size;
        end

        get_diag_size: begin
            next_state = preload;
        end

        preload: begin
            if (calculation_complete_flag_i)
              next_state = p_busy_l;
            else if (half_loop_flag_i)
               next_state = load_half_h;
            else if (~half_loop_flag_i)
              next_state = load_half_l;
        end

        load_half_l: begin
            next_state = loaded;
        end

        load_half_h: begin
            next_state = loaded;
        end

        loaded: begin
        	if (bounds_valid_flag_i)
        		next_state = read_mem;
        	else 
        		next_state = z_set_data;
        end
          
        read_mem: begin
            next_state = get_product;
        end

        get_product: begin
          next_state = product_stable;
        end

        product_stable: begin
        	next_state = add_product;
        end

        add_product: begin
            next_state = iteration_count;
        end

        iteration_count: begin
            next_state = loaded;
        end

        z_set_data: begin
            next_state = diagonal_count;
        end

        diagonal_count: begin
        	next_state = preload;
        end

        p_busy_l: begin
            next_state = p_done_h;
        end

        p_done_h: begin
            next_state = p_done_l;
        end

        p_done_l: begin
            if (~start_i)
                next_state = _init;
        end
    endcase // current_state
end : fsm_next

	/* Output stage */ 
	always_ff @(posedge clk or negedge rst_n) begin : fsm_outputs

		register_load_flag_o = 1'b0; 
		diag_size_flag_o = 1'b0;
		half_loop_load_en_o = 1'b0;
		read_memory_flag_o = 1'b0;
		get_product_flag_o = 1'b0;
		add_product_flag_o = 1'b0; 
		iteration_count_flag_o = 1'b0;
		diagonal_count_flag_o = 1'b0;
		z_write_o = 1'b0;
		done_flag_o = 1'b0;
		busy_flag_o = 1'b0;

		unique case (next_state) 
			_init: begin
				busy_flag_o = 1'b0; 
				done_flag_o = 1'b0;
			end

			register_load: begin
				busy_flag_o = 1'b1;
				register_load_flag_o = 1'b1; 
			end

			get_diag_size: 
				diag_size_flag_o = 1'b1;

			preload: ;

			load_half_h: 
				half_loop_load_en_o = 1'b1;

			load_half_l: 
				half_loop_load_en_o = 1'b1;

			loaded: ; 

			read_mem: 
				read_memory_flag_o = 1'b1; 

			get_product: 
				get_product_flag_o = 1'b1; 

			product_stable: ;

			add_product: 
				add_product_flag_o = 1'b1; 

			iteration_count: 
				iteration_count_flag_o = 1'b1; 

			z_set_data: 
				z_write_o = 1'b1;

			diagonal_count: 
				diagonal_count_flag_o = 1'b1;

			p_busy_l: 
				busy_flag_o = 1'b0; 

			p_done_h: 
				done_flag_o = 1'b1; 

			p_done_l: 
				done_flag_o = 1'b0;   
		endcase
	end : fsm_outputs

endmodule: convolutor_fsm