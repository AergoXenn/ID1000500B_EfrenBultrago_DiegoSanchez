///////////////////////////////////////////////////////////////
// Module:        <std_comparator_p>
// Author:        <Alejandro Kelly>
// Date:          <03/05/2024>
// Description:   <Parametric single-output comparator.>
// 
// Parameters:
//   - <WORD_SIZE>: <Size of comparands.> [default: <8>]
//   - <TYPE>: <Selects between an equality, greater-than or lesser-than comparator> [default: <0 *(equality)>] 
//
// Inputs:
//   - <word_a_i>: <First comparand.>
//   - <word_b_i>: <Second comparand.> 
//
// Outputs:
//   - <status_o>: <Single output of comparator, depends on type parameter. >
//
// Revision history:
//   - <1> (<03/05/2024>): <Creation.>
//
///////////////////////////////////////////////////////////////

module convolutor_std_comparator_p # (
  parameter WORD_SIZE = 8,
  parameter TYPE = 0
  ) (
  input logic [WORD_SIZE-1:0] word_a_i, 
  input logic [WORD_SIZE-1:0] word_b_i, 
  output logic status_o
);

  generate
    if (TYPE == 0) begin
      always_comb begin
        if (word_a_i == word_b_i)
          status_o = 1'b1;
        else 
          status_o = 1'b0;
      end
    end		
		
    else if (TYPE == 1) begin
      always_comb begin
        if (word_a_i > word_b_i)
          status_o = 1'b1;
        else 
          status_o = 1'b0;
      end
    end	
		
    else if (TYPE == 2) begin
      always_comb begin
        if (word_a_i < word_b_i)
          status_o = 1'b1;
        else 
          status_o = 1'b0;
      end
    end
  endgenerate

endmodule : convolutor_std_comparator_p