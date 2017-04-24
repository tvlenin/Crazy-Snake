`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// VGA verilog template
// Author:  Da Cheng
//////////////////////////////////////////////////////////////////////////////////
module vga_top(
	input ClkPort, 
	input b_Up,b_Down,b_Left,b_Right,
	output vga_h_sync, vga_v_sync, 
	output wire [2:0] rgb
);
	
	
	wire [9:0] pix_x;
	wire [9:0] pix_y;
	wire video_on;
	wire [1:0] wMoveState;
	wire [7:0] wRandomX;
	wire [7:0] wRandomY;
	
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

	assign 	{St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};
	
	
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
		.randomY(wRandomY)
	);
		
	Buttons_Control buttons_unit(
		.clk(DIV_CLK[1]),
		.b_Up(b_Up),
		.b_Dw(b_Down),
		.b_Lf(b_Left),
		.b_Rg(b_Right),
		.moveState(wMoveState)
	);
	
	
endmodule
