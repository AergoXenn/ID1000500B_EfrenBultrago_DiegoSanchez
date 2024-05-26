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
		_INIT = 					5'b00000,
		REGISTER_LOAD, //Controls master initialization enable
		GET_DIAG_SIZE, //Controls get size enable
		PRELOAD, 
		LOAD_HALF_L, 
		LOAD_HALF_H, 
		LOADED, 
		READ_MEMORY, //Controls X & Y temp enable
		GET_PRODUCT, //Controls product enable
		PRODUCT_STABLE, 
		ADD_PRODUCT, //Controls accumulator enable
		ITERATION_COUNT, //Controls Up-down counter enable
		Z_SET_DATA, 
		DIAGONAL_COUNT, 
		BUSY_LOW,
		DONE_H,
		DONE_L, 
		XXX = 5'bxxxxx
	} fsm_state_t;

	fsm_state_t current_state; 
	fsm_state_t next_state; 

	/* State keeping block */
	always_ff @(posedge clk or negedge rst_n) begin : fsm_state
		if (~rst_n) begin
			current_state <= _INIT;
		end 
		else begin 
			current_state = next_state;
		end
	end : fsm_state
	
/* Next state logic */
always_comb begin : fsm_next
    next_state = XXX;
    case (current_state)
        _INIT: begin
            if (start_i)
                next_state = REGISTER_LOAD;
        end
        
        REGISTER_LOAD: begin
            next_state = GET_DIAG_SIZE;
        end

        GET_DIAG_SIZE: begin
            next_state = PRELOAD;
        end

        PRELOAD: begin
            if (calculation_complete_flag_i)
              next_state = BUSY_LOW;
            else if (half_loop_flag_i)
               next_state = LOAD_HALF_H;
            else if (~half_loop_flag_i)
              next_state = LOAD_HALF_L;
        end

        LOAD_HALF_L: begin
            next_state = LOADED;
        end

        LOAD_HALF_H: begin
            next_state = LOADED;
        end

        LOADED: begin
        	if (bounds_valid_flag_i)
        		next_state = READ_MEMORY;
        	else 
        		next_state = Z_SET_DATA;
        end
          
        READ_MEMORY: begin
            next_state = GET_PRODUCT;
        end

        GET_PRODUCT: begin
          next_state = PRODUCT_STABLE;
        end

        PRODUCT_STABLE: begin
        	next_state = ADD_PRODUCT;
        end

        ADD_PRODUCT: begin
            next_state = ITERATION_COUNT;
        end

        ITERATION_COUNT: begin
            next_state = LOADED;
        end

        Z_SET_DATA: begin
            next_state = DIAGONAL_COUNT;
        end

        DIAGONAL_COUNT: begin
        	next_state = PRELOAD;
        end

        BUSY_LOW: begin
            next_state = DONE_H;
        end

        DONE_H: begin
            next_state = DONE_L;
        end

        DONE_L: begin
            if (~start_i)
                next_state = _INIT;
            else  
            	next_state = DONE_L;
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
			_INIT: begin
				busy_flag_o = 1'b0; 
				done_flag_o = 1'b0;
			end

			REGISTER_LOAD: begin
				busy_flag_o = 1'b1;
				register_load_flag_o = 1'b1; 
			end

			GET_DIAG_SIZE: begin
				busy_flag_o = 1'b1;
				diag_size_flag_o = 1'b1;
			end 

			PRELOAD: begin
				busy_flag_o = 1'b1;
			end 

			LOAD_HALF_H: begin 
				busy_flag_o = 1'b1;
				half_loop_load_en_o = 1'b1;
			end 

			LOAD_HALF_L: begin
				busy_flag_o = 1'b1;
				half_loop_load_en_o = 1'b1;
			end 

			LOADED: begin
				busy_flag_o = 1'b1;
			end 

			READ_MEMORY: begin 
				busy_flag_o = 1'b1;
				read_memory_flag_o = 1'b1; 
			end 

			GET_PRODUCT: begin 
				busy_flag_o = 1'b1;
				get_product_flag_o = 1'b1; 
			end 

			PRODUCT_STABLE: begin
				busy_flag_o = 1'b1;
			end 

			ADD_PRODUCT: begin 
				busy_flag_o = 1'b1;
				add_product_flag_o = 1'b1; 
			end 

			ITERATION_COUNT: begin 
				busy_flag_o = 1'b1;
				iteration_count_flag_o = 1'b1; 
			end 

			Z_SET_DATA: begin 
				busy_flag_o = 1'b1;
				z_write_o = 1'b1;
			end 

			DIAGONAL_COUNT: begin 
				busy_flag_o = 1'b1;
				diagonal_count_flag_o = 1'b1;
			end 

			BUSY_LOW: begin 
				busy_flag_o = 1'b0; 		
			end 

			DONE_H: begin
				busy_flag_o = 1'b0;
				done_flag_o = 1'b1; 
			end 

			DONE_L: begin 
				busy_flag_o = 1'b0;
				done_flag_o = 1'b0;   
			end
		endcase
	end : fsm_outputs

endmodule: convolutor_fsm
