`timescale 1ns / 1ps

module Buttons_Control(
	input clk,
	input b_Up,b_Dw,b_Lf,b_Rg,
	output [1:0] moveState
);

parameter UP = 0,DOWN = 1,LEFT = 2,RIGHT = 3;

reg [1:0] moveState_reg;

always @(posedge clk)begin
	if(b_Up == 1 && moveState_reg != DOWN)
		moveState_reg <= UP;
	else if(b_Dw == 1 && moveState_reg != UP)
		moveState_reg <= DOWN;
	else if(b_Lf == 1 && moveState_reg != RIGHT)
		moveState_reg <= LEFT;
	else if(b_Rg == 1 && moveState_reg != LEFT)
		moveState_reg <= RIGHT;
	
end

assign moveState = moveState_reg;

endmodule
