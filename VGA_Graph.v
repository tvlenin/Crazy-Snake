`timescale 1ns / 1ps

module VGA_Graph(
	input clk,
	input wire video_on,
	input wire [9:0] pix_x, pix_y,
	output [2:0] graph_rgb,
	input [3:0] moveState,
	input [7:0] randomX,randomY
);

wire wallLeft,wallRight,wallTop,wallBottom;
wire snake,fruit;
reg snakeBody [10:0];

wire [2:0] wallRGB,snakeRGB,fruitRGB;

reg [2:0] rgb_reg;

localparam wall_Left_X1 = 0;
localparam wall_Left_X2 = 2;
localparam wall_Right_X1 = 600;
localparam wall_Right_X2 = 602;
localparam wall_Top_Y1 = 0;
localparam wall_Top_Y2 = 2;
localparam wall_Bottom_Y1 = 477;
localparam wall_Bottom_Y2 = 479;

reg [64:0] counter = 0;
reg [64:0] fruit_counter = 0;
reg [64:0] snakeSize = 65'd3;

reg [7:0] rndX_reg,rndY_reg;

reg [9:0]initX1 = 9'd260;
reg [9:0]initX2 = 9'd270;
reg [9:0]initY1 = 9'd200;
reg [9:0]initY2 = 9'd210;

reg [9:0]bodyX1 = 9'd250;
reg [9:0]bodyX2 = 9'd260;
reg [9:0]bodyY1 = 9'd200;
reg [9:0]bodyY2 = 9'd210;

reg [9:0]fruitX1 = 9'd50;
reg [9:0]fruitX2 = 9'd60;
reg [9:0]fruitY1 = 9'd50;
reg [9:0]fruitY2 = 9'd60;



assign wallLeft = (wall_Left_X1 <= pix_x) && (pix_x <= wall_Left_X2);
assign wallRight = (wall_Right_X1 <= pix_x) && (pix_x <= wall_Right_X2);
assign wallTop = (wall_Top_Y1 <= pix_y) && (pix_y <= wall_Top_Y2);
assign wallBottom = (wall_Bottom_Y1 <= pix_y) && (pix_y <= wall_Bottom_Y2);

assign snake = (initX1 <= pix_x) && (pix_x <= initX2) &&
					(initY1 <= pix_y) && (pix_y <= initY2);

assign fruit = (fruitX1 <= pix_x) && (pix_x <= fruitX2) &&
					(fruitY1 <= pix_y) && (pix_y <= fruitY2);

assign wallRGB = 3'b111; 
assign snakeRGB = 3'b110;
assign fruitRGB = 3'b101;

integer n;
always @(*)
	if(~video_on)
		rgb_reg = 3'b111;
	else 
		if (wallLeft || wallRight || wallTop || wallBottom)
			rgb_reg = wallRGB;
		else if(snake)begin
			rgb_reg = snakeRGB;
		end
		else if(fruit)
			rgb_reg = fruitRGB;
		else 
			rgb_reg = 3'b000;

assign graph_rgb =(video_on) ? rgb_reg : 3'b0;

/*
always @(posedge clk)
	if(fruit_counter == 25000000)begin
		rndX_reg = randomX;
		rndY_reg = randomY;
		
		fruitX1 = (rndX_reg*10);
		fruitX2 = (rndX_reg*10)+10;
		fruitY1 = (rndY_reg*10);
		fruitY2 = (rndY_reg*10)+10;
		
		fruit_counter = 0;
	end
	else
		fruit_counter = fruit_counter + 1'b1;*/
	

always @(posedge clk)
	//if(counter == 25000000)begin //AVANZA CADA SEGUNDO
	if(counter == 10000000)begin
		if(moveState == 0)begin
			initY1 = initY1 - 10;
			initY2 = initY2 - 10;
		end
		else if(moveState == 1)begin
			initY1 = initY1 + 10;
			initY2 = initY2 + 10;
		end
		else if(moveState == 2)begin
			initX1 = initX1 - 10;
			initX2 = initX2 - 10;
		end
		else begin
			initX1 = initX1 + 10;
			initX2 = initX2 + 10;
		end
		counter = 0;
	end
	else
		counter = counter + 1'b1;

endmodule