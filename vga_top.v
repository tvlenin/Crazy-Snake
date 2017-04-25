`timescale 1ns / 1ps

module vga_top(
	input ClkPort, 
	input b_Up,b_Down,b_Left,b_Right,
	output vga_h_sync, vga_v_sync, 
	output wire [2:0] rgb,
	output [3:0] seg_selector,
	output [7:0] sevenseg
);
	wire [9:0] headX_wire;
	wire [9:0] headY_wire;
	wire [9:0] randX_wire;
	wire [9:0] randY_wire;
	
	wire [9:0] pix_x;
	wire [9:0] pix_y;
	wire video_on;
	wire [1:0] wMoveState;
	wire [7:0] wRandomX;
	wire [7:0] wRandomY;
	wire [3:0] wScore1,wScore2,wScore3,wScore4;
	
	/*  LOCAL SIGNALS */
	wire	Reset, ClkPort, board_clk, sys_clk;
	
	BUF BUF1 (board_clk, ClkPort); 
	
	reg [27:0]	DIV_CLK;
	always @ (posedge board_clk, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			begin
				DIV_CLK <= 0;
			end
      else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	
	
	hvsync_generator syncgen(
		.clk(DIV_CLK[1]), 
		.reset(BtnR),
		.vga_h_sync(vga_h_sync), 
		.vga_v_sync(vga_v_sync), 
		.inDisplayArea(video_on), 
		.CounterX(pix_x), 
		.CounterY(pix_y)
	);
	
	VGA_Graph vga_unitB(
		.clk(DIV_CLK[1]),
		.video_on(video_on),
		.pix_x(pix_x),
		.pix_y(pix_y),
		.graph_rgb(rgb),
		.moveState(wMoveState),
		.randomX(wRandomX),
		.randomY(wRandomY),
		.score1(wScore1),
		.score2(wScore2),
		.score3(wScore3),
		.score4(wScore4),
		.headX(headX_wire),//output
		.headY(headY_wire),
		.randX(randX_wire),
		.randY(randY_wire)
	);
		
	Buttons_Control buttons_unit(
		.clk(DIV_CLK[1]),
		.b_Up(b_Up),
		.b_Dw(b_Down),
		.b_Lf(b_Left),
		.b_Rg(b_Right),
		.moveState(wMoveState)
	);
	
	Segments_Controller segments_unit(
		.clk(ClkPort),
		.score1(wScore1),
		.score2(wScore2),
		.score3(wScore3),
		.score4(wScore4),
		.seg_selector(seg_selector), 
		.segments(sevenseg)
	);
	
	Random_Generator instance_Random (
    .clock(ClkPort), 
    .yValues(headY_wire), 
    .xValues(headX_wire), 
    .randNumX(randX_wire), 
    .randNumY(randY_wire)
    );



	
endmodule
