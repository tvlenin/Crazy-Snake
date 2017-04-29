`timescale 1ns / 1ps

module VGA_Graph(
	input clk,
	input wire video_on,
	input wire [9:0] pix_x, pix_y,
	output [2:0] graph_rgb,
	input [3:0] moveState,
	output [3:0] score1,score2,score3,score4,
	output [9:0] headX,
	output [9:0] headY,
	input [9:0]	randX,
	input [9:0]	randY,
	input isPaused
);

localparam maxSnakeSegments = 20;
localparam wall_Left_X1 = 0;
localparam wall_Left_X2 = 2;
localparam wall_Right_X1 = 602;
localparam wall_Right_X2 = 604;
localparam wall_Top_Y1 = 0;
localparam wall_Top_Y2 = 2;
localparam wall_Bottom_Y1 = 477;
localparam wall_Bottom_Y2 = 479;




wire wallLeft,wallRight,wallTop,wallBottom;
wire snake,fruit;

reg wSnakeBody[maxSnakeSegments:0];
//reg wSnakeBody;

reg [3:0] score_reg1 = 0;
reg [3:0] score_reg2 = 0;
reg [3:0] score_reg3 = 0;
reg [3:0] score_reg4 = 0;
reg [3:0] score_factor = 4'd5;

wire [2:0] wallRGB,snakeRGB,fruitRGB;
reg [2:0] rgb_reg;



reg [24:0] gameover_counter = 0;
reg [64:0] counter = 0;
reg [64:0] fruit_counter = 0;
reg [64:0] snake_counter = 0;
reg [11:0] snakeSize = 0;
reg gameover = 0;
reg [maxSnakeSegments-1:0] snake_body_i = 0;

reg [9:0]initX1 = 10'd77;
reg [9:0]initX2 = 10'd102;
reg [9:0]initY1 = 10'd77;
reg [9:0]initY2 = 10'd102;

reg [9:0]snakeBody [maxSnakeSegments:0][4:0];


reg [9:0]fruitX1 = 10'd152;
reg [9:0]fruitX2 = 10'd177;
reg [9:0]fruitY1 = 10'd152;
reg [9:0]fruitY2 = 10'd177;

reg [9:0] randNumX = 0;
reg [9:0] randNumY = 0;


assign wallLeft = (wall_Left_X1 <= pix_x) && (pix_x <= wall_Left_X2);
assign wallRight = (wall_Right_X1 <= pix_x) && (pix_x <= wall_Right_X2);
assign wallTop = (wall_Top_Y1 <= pix_y) && (pix_y <= wall_Top_Y2);
assign wallBottom = (wall_Bottom_Y1 <= pix_y) && (pix_y <= wall_Bottom_Y2);

assign snake = (initX1 <= pix_x) && (pix_x <= initX2) &&
					(initY1 <= pix_y) && (pix_y <= initY2);

assign fruit = (fruitX1 <= pix_x) && (pix_x <= fruitX2) &&
					(fruitY1 <= pix_y) && (pix_y <= fruitY2);

assign score1 = score_reg1;
assign score2 = score_reg2;
assign score3 = score_reg3;
assign score4 = score_reg4;

assign wallRGB = 3'b111; 
assign snakeRGB = 3'b010;
assign fruitRGB = 3'b100;

integer z;
initial begin
	for(z=0; z < maxSnakeSegments; z=z+1)begin //X1 = 3,X2=2,Y1=1,Y2=0
		snakeBody[z][4]=0;
		snakeBody[z][3]=0;
		snakeBody[z][2]=0;
		snakeBody[z][1]=0;
		snakeBody[z][0]=0;
	end
end


integer is;
always @(posedge clk)begin
	
	if(~video_on)
		rgb_reg = 3'b111;
	else
		if(gameover == 0)begin
			if (wallLeft || wallRight || wallTop || wallBottom)
				rgb_reg = wallRGB;
			else if(snake)begin
				rgb_reg = snakeRGB;
			end
			else if(fruit)
				rgb_reg = fruitRGB;
			else begin
				rgb_reg = 3'b000;
			end
			
			for(is=0; is < maxSnakeSegments; is=is+1)begin
				if((snakeBody[is][4] == 5) &&
					(snakeBody[is][3] <= pix_x) && 
					(pix_x <= snakeBody[is][2]) &&
					(snakeBody[is][1] <= pix_y) && 
					(pix_y <= snakeBody[is][0]) )
					rgb_reg = snakeRGB;
			end
			
		end
		
		else begin
			if(gameover_counter < 2000000)begin
				if (wallLeft || wallRight || wallTop || wallBottom)
					rgb_reg = wallRGB;
				else if(snake)begin
					rgb_reg = snakeRGB;
				end
				else if(fruit)
					rgb_reg = fruitRGB;
				else begin
					rgb_reg = 3'b000;
				end
				gameover_counter = gameover_counter + 1;
			end
			else if(gameover_counter < 4000000)begin
				rgb_reg = 3'b001;
				gameover_counter = gameover_counter + 1;
			end
			else if(gameover_counter == 4000000)
				gameover_counter = 0;
			else
				gameover_counter = gameover_counter + 1;
		end
end
assign graph_rgb =(video_on) ? rgb_reg : 3'b0;

	
integer ix;
integer ifruit;
always @(posedge clk)begin
	
	if(initX1 == fruitX1 && initX2 == fruitX2 &&
		initY1 == fruitY1 && initY2 == fruitY2)begin
		
		if(score_reg1 == 4'd9) begin
			score_reg1 <= 0;
		   if(score_reg2 == 4'd9)begin
				score_reg2 <= 0;
				if(score_reg3 == 4'd9)begin
					score_reg3 <= 0;
					if(score_reg4 == 4'd9)begin
						score_reg4 <= 0;
					end
					else
					 score_reg4 <= score_reg4 + 1;
				end
				else
				 score_reg3 <= score_reg3 + 1;
			end
			else
			 score_reg2 <= score_reg2 + 1;
		end
		else
			score_reg1 <= score_reg1 + 1;
		
		
		snakeBody[snakeSize][4] <= 5;
		snakeSize = snakeSize + 1;
		
		
		//Verifica si la fruta cae en la serpiente
		randNumX = snakeBody[0][3];
		randNumY = snakeBody[0][1];
		for(ifruit = 0; ifruit<maxSnakeSegments; ifruit=ifruit+1)begin
			if(snakeBody[ifruit][3] == randX && snakeBody[ifruit][1] == randY)begin
				randNumX = randNumX + 25;
				randNumY = randNumY + 50;
				//ifruit = 0;
			end;
		end
		
		fruitX1=randX;
		fruitX2=randX+25;
		fruitY1=randY;
		fruitY2=randY+25;
		
		//fruitX1=fruitX1+25;
		//fruitX2=fruitX2+25;
		
	end
		
	//if(counter == 10000000)begin
	if(counter == 4000000)begin
		/*if(gameover && isPaused)begin
			initX1 = 10'd77;
			initX2 = 10'd102;
			initY1 = 10'd77;
			initY2 = 10'd102;
			fruitX1 = 10'd152;
			fruitX2 = 10'd177;
			fruitY1 = 10'd152;
			fruitY2 = 10'd177;
			snakeSize = 0;
			score_reg1 <= 0;
			score_reg2 <= 0;
			score_reg3 <= 0;
			score_reg4 <= 0;
			gameover = 0;
		end*/
	
		if(~isPaused && ~gameover)begin
			for(ix=0; ix < maxSnakeSegments; ix=ix+1)begin //X1 = 3,X2=2,Y1=1,Y2=0
				if(snakeBody[ix][4]===5)begin
					if(initX1 == snakeBody[ix][3] && initX2 == snakeBody[ix][2]  &&
						initY1 == snakeBody[ix][1] && initY2 == snakeBody[ix][0] )begin
						//score_reg1 <= score_reg1 - 1;
						gameover = 1;
					end
				end
				if(ix==0)begin
					if(snakeBody[0][4] == 5)begin
						snakeBody[ix][3] <= initX1;
						snakeBody[ix][2] <= initX2;
						snakeBody[ix][1] <= initY1;
						snakeBody[ix][0] <= initY2;
					end
				end
				else begin
					if(snakeSize >= 1 && snakeBody[ix][4] == 5)begin
						snakeBody[ix][3] <= snakeBody[ix-1][3];
						snakeBody[ix][2] <= snakeBody[ix-1][2];
						snakeBody[ix][1] <= snakeBody[ix-1][1];
						snakeBody[ix][0] <= snakeBody[ix-1][0];
					end
				end
			end
		
		
			if(moveState == 0)begin
				if(initY1 == 2)begin
					initY1 = 10'd452;
					initY2 = 10'd477;
				end
				else begin
					initY1 = initY1 - 25;
					initY2 = initY2 - 25;
				end
			end
			else if(moveState == 1)begin
				if(initY2 == 477)begin
					initY1 = 10'd2;
					initY2 = 10'd27;
				end
				else begin
					initY1 = initY1 + 25;
					initY2 = initY2 + 25;
				end
				
			end
			else if(moveState == 2)begin
				if(initX1 == 2)begin
					initX1 = 10'd577;
					initX2 = 10'd602;
				end
				else begin
					initX1 = initX1 - 25;
					initX2 = initX2 - 25;
				end
			end
			else if(moveState == 3)begin
				if(initX2 == 602)begin
					initX1 = 10'd2;
					initX2 = 10'd27;
				end
				else begin
					initX1 = initX1 + 25;
					initX2 = initX2 + 25;
				end
			end
		end
		counter = 0;
	end
	else
		counter = counter + 1'b1;
end

assign headX = randNumX;
assign headY = randNumY;

endmodule