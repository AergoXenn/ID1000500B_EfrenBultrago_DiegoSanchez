///////////////////////////////////////////////////////////////
// Module:        <convolutor_tb>
// Author:        <Alejandro Kelly>
// Date:          <May 23rd 2024>
// Description:   <Testbench for convolution coprocessor>
// 
//
///////////////////////////////////////////////////////////////


module convolutor_tb ();

  localparam ADDR_WIDTH = 5;
  localparam DATA_WIDTH = 8;

  int i;
  logic clk; 
  logic rst_n; 							
	logic start_i;
  logic busy; 
  logic zwr; 
  logic done;
  logic [15:0] z_dout; 
  logic [DATA_WIDTH-1:0] y_data;
  logic [2*DATA_WIDTH-1:0] z_data; 
  logic [ADDR_WIDTH-1:0] y_addr;
  logic [ADDR_WIDTH:0] z_addr; 		

  convolutor conv_top (
    .clk      (clk),
    .rst_n    (rst_n),
    .start    (start_i),
    .dataY    (y_data),
    .sizeY    (5'd10),
    .memY_addr(y_addr),
    .dataZ    (z_data),
    .memZ_addr(z_addr),
    .busy     (busy),
    .done     (done),
    .writeZ   (zwr)
    );

  convolutor_ram_dual_port # (
    .DATA_WIDTH(DATA_WIDTH), 
    .DEPTH(32),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MEMFILE   ("./Sequential/RAM/MEMY.mem")
    ) Y_RAM (
    .clk            (clk),
    .read_address_i (y_addr),
    .data_output_o  (y_data),
    .write_enable_i (1'b0),
    .write_address_i(5'b0),
    .write_data_i   (8'b0)
    );

  convolutor_ram_dual_port # (
    .DATA_WIDTH(16), 
    .DEPTH(64),
    .ADDR_WIDTH(6),
    .MEMFILE   ("./Sequential/RAM/MEMZ.mem")
    ) Z_RAM (
    .clk            (clk),
    .read_address_i (6'b0),
    .data_output_o  (z_dout),
    .write_enable_i (zwr),
    .write_address_i(z_addr),
    .write_data_i   (z_data)
    );

  always begin
    clk = ~clk; 
    #5;
  end

  initial begin
    start_i = 0;
    clk = 1'b0;
    rst_n = 1'b0;
    #1; 
    rst_n = 1'b1;
    start_i = 1'b1;  

    #6000;
    $finish;         
  end

endmodule : convolutor_tb