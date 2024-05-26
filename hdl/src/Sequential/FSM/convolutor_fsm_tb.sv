																																																				 ///////////////////////////////////////////////////////////////
// Module:        convolutor_simple_rom_p.sv
// Author:        Alejandro Kelly
// Date:          01-05-2024
// Description:   Single-port synchronous read ROM.
// 
// Parameters:
//   - <WIDTH>: <Word size in bits> [default: <8>]
//   - <DEPTH>: <No. of words in bits. Must be a power of 2.> [default: <16>] 
//   - <ADDRW>: <Width of address in bits. Depends on DEPTH> [default: <4>] 
//
// Clocks:
//   - <clk>: <Active high main clock>
//
// Inputs:
//   - <read_address_i>: <Read address>
//
// Outputs:
//   - <read_data_o>: <Read Data>
//
// Revision history:
//   - <1> (<01/05/2024>): <Created file.>
//
///////////////////////////////////////////////////////////////

module convolutor_fsm_tb();

	logic clk;
	logic rst_n; 
	logic start_h; 
	logic half_loop_load; 
	logic loop_bound_valid_h;
	logic load_enable_h;
	logic size_enable_h; 
	logic ram_read_enable_h;
	logic mult_enable_h;
	logic addr_diag_count_h;
	logic p_busy_o; 
	logic p_zwrite_o;
	logic p_done_o;

	always begin
		clk = ~clk;
		#5;
	end

	initial begin  
		clk = 1'b0;		
		start_h = 1'b0;
		half_loop_load = 1'b0;
		loop_bound_valid_h = 1'b0;
		rst_n = 1'b0;
		#10; 
		rst_n = 1'b1;

		start_h = 1'b1;		 
		$finish;
	end 


endmodule : convolutor_fsm_tb