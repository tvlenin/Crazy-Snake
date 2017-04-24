`timescale 1ns / 1ps


module Top(
	 input clk,reset,
	 output hsync,
	 output vsync,
	 output [2:0] rgb,
	 output [7:0]out
);

wire clk, board_clk,sys_clk;
reg [2:0] rgb_reg;
wire video_on;
wire pxw;
wire pyw;

wire wallon;
wire [2:0] wallRGB;

wire [9:0] pix_x;
wire [9:0] pix_y;

localparam wallx1 = 564;
localparam wallx2 = 574;
localparam wally1 = 467;
localparam wally2 = 477;

assign wallon = (wallx1 <= pix_x) && (pix_x <= wallx2 ) &&
					(wally1 <= pix_y) && (pix_y <= wally2 );
assign wallRGB = 3'b010; 






BUF BUF1 (board_clk, clk); 

reg [27:0] DIV_CLK;
always @ (posedge board_clk, posedge reset)
    begin : CLOCK_DIVIDER
	if (reset)begin
	    DIV_CLK <= 0;
	end
	else
	    DIV_CLK <= DIV_CLK + 1'b1;
	end

assign sys_clk = board_clk;

VGA_Controller vga_unit(
	.clk(DIV_CLK[1]),
	.reset(reset),
	.hsync(hsync),
	.vsync(vsync),
	.video_on(video_on),
	.p_tick(),
	.pixel_x(pix_x),
	.pixel_y(pix_y)
);
snake_data instance_Snake (
	 .clk(clk),
    .up(up), 
    .down(down), 
    .right(right), 
    .left(left), 
    .outS(out)
    );




always @(*)
	if(~video_on)
		rgb_reg = 3'b111;
	else 
		if (wallon)
			rgb_reg = wallRGB;
		else 
			rgb_reg = 3'b101;
assign rgb =(video_on) ? rgb_reg : 3'b0;

endmodule
