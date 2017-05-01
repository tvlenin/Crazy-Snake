`timescale 1ns / 1ps

module Buttons_Control(
	input clk,
	input b_Up,b_Dw,b_Lf,b_Rg,b_Pause,
	input b_PauseType,
	output [1:0] moveState,
	output [1:0] currentScreen,
	output [1:0] currentSelect,
	output [1:0] difficulty,
	output isPaused
);

parameter UP = 0,DOWN = 1,LEFT = 2,RIGHT = 3;

reg [1:0] moveState_reg;
reg [23:0] pause_count = 0;
reg [1:0] currentScreen_reg = 0;
reg [1:0] currentSelect_reg = 0;
reg [1:0] difficulty_reg = 0;
reg pause_reg;

always @(posedge clk)begin
	if(currentScreen_reg == 0)begin
		if(b_Up)begin
			if(pause_count >= 24'b001111111111111111111111)begin
				currentSelect_reg = currentSelect_reg - 1;
				pause_count = 0;
			end
			else
				pause_count = pause_count + 1;
		end
		else if(b_Dw)begin
			if(pause_count >= 24'b001111111111111111111111)begin
				currentSelect_reg = currentSelect_reg + 1;
				pause_count = 0;
			end
			else
				pause_count = pause_count + 1;
		end
		else if(b_Pause)begin
			if(pause_count >= 24'b001111111111111111111111)begin
				case(currentSelect_reg)
					2'b00: begin currentSelect_reg = 1; currentScreen_reg = 3; end
					2'b01: currentScreen_reg = 2;
					2'b10: difficulty_reg = difficulty_reg + 1;
					2'b11: currentScreen_reg = 0;
				endcase
				pause_count = 0;
			end
			else
				pause_count = pause_count + 1;
		end
		
	end
	else if(currentScreen_reg == 3 || currentScreen_reg == 2)begin
		if(b_Pause)begin
			if(b_PauseType)
				currentScreen_reg = 0;
			else begin
				if(pause_count >= 24'b001111111111111111111111)begin
					pause_reg = ~pause_reg;
					pause_count = 0;
				end
				else
					pause_count = pause_count + 1;
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
end

assign currentScreen = currentScreen_reg;
assign currentSelect = currentSelect_reg;
assign difficulty = difficulty_reg;
assign moveState = moveState_reg;
assign isPaused = pause_reg;

endmodule
