`timescale 1ns/100ps
///////////////////////////////////////////////////////////////
// Module:        convolutor_simple_rom_p_tb.sv
// Author:        Alejandro Kelly
// Date:          01-05-2024
// Description:   Single-port synchronous read ROM testbench.
// 
// Revision history:
//   - <1> (<01/05/2024>): <Created file.>
//
///////////////////////////////////////////////////////////////

module convolutor_simple_rom_p_tb ();

	localparam WIDTH = 8; 
	localparam DEPTH = 32; 
	localparam ADDRW = $clog2(DEPTH);
	localparam MEMFILE = "./ROM/MEM32.mem"; 

	integer i;
	logic clk_tb;
	logic [ADDRW-1:0] address_tb; 
	logic [WIDTH-1:0] data_tb; 

	convolutor_simple_rom_p # (
	.WIDTH(WIDTH), 
	.DEPTH(DEPTH),
	.MEMFILE(MEMFILE)
		) DUT_rom ( 
		.clk(clk_tb), 
		.read_address_i(address_tb), 
		.read_data_o(data_tb)
		);

	always begin
		clk_tb = ~clk_tb; 
		#5;
	end

	initial begin 
		clk_tb = 'b0;

		for (i = 0; i < DEPTH; i++) begin
			address_tb = i;																		 
			#10;
			$strobe("ADDR: %d, DATA: %d", address_tb, data_tb);			
		end	
		#10;
		$finish;
	end 

endmodule : convolutor_simple_rom_p_tb