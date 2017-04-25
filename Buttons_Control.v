`timescale 1ns / 1ps

module Buttons_Control(
	input clk,
	input b_Up,b_Dw,b_Lf,b_Rg,b_Pause,
	output [1:0] moveState,
	output isPaused
);

parameter UP = 0,DOWN = 1,LEFT = 2,RIGHT = 3;

reg [1:0] moveState_reg;
reg [3:0] pause_count;
reg pause_reg;

always @(posedge clk)begin
	if(b_Pause)begin
		pause_count = pause_count + 1;
		if(pause_count > 4'b1100)begin
			pause_reg = ~pause_reg;
			pause_count = 0;
		end
	end
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
assign isPaused = pause_reg;

endmodule
