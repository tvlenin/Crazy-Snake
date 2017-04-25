`timescale 1ns / 1ps

module Segments_Controller(
	input clk,
	input [3:0] score1,score2,score3,score4,
	output [3:0] seg_selector,
	output [7:0] segments
);

	reg [7:0] out_reg;
	reg [3:0] sel_reg;
	// 11 0000 1010 1111
	initial begin
		sel_reg = 4'b1110;
		segData=0;//Ojo antes no estaba
	end
	
	localparam N = 18;
	reg [N-1:0]count;
	reg [3:0]segData;
	
	always @ (posedge clk)
		count <= count + 1'd1;
		always @ (*)begin
			case(count[N-1:N-2])
				2'b00:begin
					segData <= score1;
					sel_reg = 4'b1110;
				end
				2'b01:begin
					segData <= score2;
					sel_reg = 4'b1101;
				end
				2'b10:begin
					segData <= score3;
					sel_reg = 4'b1011;
				end
				2'b11:begin
					segData <= score4;
					sel_reg = 4'b0111;
				end
			endcase
	end
	
	
	always @ (*)
	begin
	case (segData)		//abcdefg.
		0 : out_reg = 8'b00000011; //0
		1 : out_reg = 8'b10011111; //1
		2 : out_reg = 8'b00100101; //2
		3 : out_reg = 8'b00001101; //3
		4 : out_reg = 8'b10011001; //4
		5 : out_reg = 8'b01001001; //5
		6 : out_reg = 8'b01000001; //6
		7 : out_reg = 8'b00011111; //7
		8 : out_reg = 8'b00000001; //8
		9 : out_reg = 8'b00011001; //9
		default : out_reg = 8'b11111111;
	endcase
	end
	
	assign segments = out_reg;
	assign seg_selector = sel_reg;

endmodule
