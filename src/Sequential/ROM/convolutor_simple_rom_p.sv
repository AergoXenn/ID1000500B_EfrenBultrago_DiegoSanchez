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

module convolutor_simple_rom_p 
	# ( 
		parameter WIDTH = 8, 
		parameter DEPTH = 16, 
		parameter ADDRW = $clog2(DEPTH), 
		parameter MEMFILE = "ROM_DATA.txt"
		) (
		input logic clk, 
		input logic [ADDRW-1:0] read_address_i, 
		output logic [WIDTH-1:0] read_data_o
		);

	logic [WIDTH-1:0] rom [DEPTH-1:0];

	initial begin 
		$readmemh(MEMFILE, rom);
	end 

	/* Synchronous read block */
	always_ff @(posedge clk) begin : rom_read
		read_data_o <= rom[read_address_i];
	end : rom_read

endmodule : convolutor_simple_rom_p