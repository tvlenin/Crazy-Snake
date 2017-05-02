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
	input isPaused,
	input [1:0] currentScreen,currentSelect,difficulty
);



//Señales de Texto Menu Principal
wire [7:0] rom_addr;
wire [6:0] char_addr;
wire [3:0] row_addr ;
wire [2:0] bit_addr;
wire [7:0] font_word;
wire font_bit ,text_bit_on;
reg [7:0] rom_addr_reg;
assign rom_addr = rom_addr_reg;

//Límites de Letras Menu Principal
localparam initXLetters = 200;
localparam initYLetters = 124;
localparam initYLetters2 = 162;
localparam initYLetters3 = 194;
localparam initYLetters4 = 226;

wire zN,zU,zE,zV,zO,zJ,zU2,zE2,zG,zO2;		//Nuevo Juego
wire zC,zA,zR,zG2,zA2,zJ2,zU3,zE3,zG3,zO3;//Carga Juego
wire zD,zI,zF,zI2,zC2,zU4,zL,zT,zA3,zD2;	//Dificultad
wire zC3,zR2,zE4,zD3,zI3,zT2,zO4,zS;		//Creditos

wire [2:0] lsbx;
wire [3:0] lsby;
assign lsbx = ~pix_x[2:0] ;
assign lsby = pix_y[3:0];

assign zN =(initXLetters<=pix_x) && (pix_x<=(initXLetters+7)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zU =((initXLetters+16)<=pix_x) && (pix_x<=(initXLetters+23)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zE =((initXLetters+32)<=pix_x) && (pix_x<=(initXLetters+39)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zV =((initXLetters+48)<=pix_x) && (pix_x<=(initXLetters+56)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zO =((initXLetters+62)<=pix_x) && (pix_x<=(initXLetters+73)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));

assign zJ =((initXLetters+89)<=pix_x) && (pix_x<=(initXLetters+96)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zU2 =((initXLetters+102)<=pix_x) && (pix_x<=(initXLetters+112)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zE2 =((initXLetters+121)<=pix_x) && (pix_x<=(initXLetters+128)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zG =((initXLetters+135)<=pix_x) && (pix_x<=(initXLetters+144)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));
assign zO2 =((initXLetters+151)<=pix_x) && (pix_x<=(initXLetters+160)) && 
				(initYLetters<=pix_y) && (pix_y<=(initYLetters+15));

assign zC =(initXLetters<=pix_x) && (pix_x<=(initXLetters+7)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zA =((initXLetters+16)<=pix_x) && (pix_x<=(initXLetters+23)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zR =((initXLetters+32)<=pix_x) && (pix_x<=(initXLetters+39)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zG2 =((initXLetters+48)<=pix_x) && (pix_x<=(initXLetters+56)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zA2 =((initXLetters+62)<=pix_x) && (pix_x<=(initXLetters+73)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));

assign zJ2 =((initXLetters+89)<=pix_x) && (pix_x<=(initXLetters+96)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zU3 =((initXLetters+102)<=pix_x) && (pix_x<=(initXLetters+112)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zE3 =((initXLetters+121)<=pix_x) && (pix_x<=(initXLetters+128)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zG3 =((initXLetters+135)<=pix_x) && (pix_x<=(initXLetters+144)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));
assign zO3 =((initXLetters+151)<=pix_x) && (pix_x<=(initXLetters+160)) && 
				(initYLetters2<=pix_y) && (pix_y<=(initYLetters2+15));

assign zD =(initXLetters<=pix_x) && (pix_x<=(initXLetters+7)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zI =((initXLetters+16)<=pix_x) && (pix_x<=(initXLetters+23)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zF =((initXLetters+32)<=pix_x) && (pix_x<=(initXLetters+39)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zI2 =((initXLetters+48)<=pix_x) && (pix_x<=(initXLetters+56)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zC2 =((initXLetters+62)<=pix_x) && (pix_x<=(initXLetters+73)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zU4 =((initXLetters+78)<=pix_x) && (pix_x<=(initXLetters+87)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zL =((initXLetters+95)<=pix_x) && (pix_x<=(initXLetters+104)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zT =((initXLetters+111)<=pix_x) && (pix_x<=(initXLetters+120)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zA3 =((initXLetters+127)<=pix_x) && (pix_x<=(initXLetters+136)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));
assign zD2 =((initXLetters+143)<=pix_x) && (pix_x<=(initXLetters+151)) && 
				(initYLetters3<=pix_y) && (pix_y<=(initYLetters3+15));

assign zC3 =(initXLetters<=pix_x) && (pix_x<=(initXLetters+7)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));
assign zR2 =((initXLetters+16)<=pix_x) && (pix_x<=(initXLetters+23)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));
assign zE4 =((initXLetters+32)<=pix_x) && (pix_x<=(initXLetters+39)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));
assign zD3 =((initXLetters+48)<=pix_x) && (pix_x<=(initXLetters+56)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));
assign zI3 =((initXLetters+62)<=pix_x) && (pix_x<=(initXLetters+73)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));
assign zT2 =((initXLetters+80)<=pix_x) && (pix_x<=(initXLetters+89)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));
assign zO4 =((initXLetters+95)<=pix_x) && (pix_x<=(initXLetters+104)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));
assign zS =((initXLetters+111)<=pix_x) && (pix_x<=(initXLetters+120)) && 
				(initYLetters4<=pix_y) && (pix_y<=(initYLetters4+15));

font_rom font_unit(
	.clk(clk),
	.as(rom_addr),
	.lsby(lsby),
	.data(font_word)
);


localparam maxSnakeScale = 25;
localparam maxSnakeSegments = 25;
localparam wall_Left_X1 = 0;
localparam wall_Left_X2 = 2;
localparam wall_Right_X1 = 602;
localparam wall_Right_X2 = 604;
localparam wall_Top_Y1 = 0;
localparam wall_Top_Y2 = 2;
localparam wall_Bottom_Y1 = 477;
localparam wall_Bottom_Y2 = 479;


wire wallLeft,wallRight,wallTop,wallBottom;
wire snake,fruit,box,difficultyBox;

reg wSnakeBody[maxSnakeSegments:0];
//reg wSnakeBody;

reg [3:0] score_reg1 = 0;
reg [3:0] score_reg2 = 0;
reg [3:0] score_reg3 = 0;
reg [3:0] score_reg4 = 0;
reg [3:0] score_factor = 4'd5;
reg firstInit=0;

wire [2:0] wallRGB,snakeRGB,fruitRGB;
reg [2:0] textRGB = 3'b110;
reg [2:0] boxRGB = 3'b010;
reg [2:0] difficultyRGB = 3'b110;
reg [2:0] rgb_reg;
reg [9:0] randNumX = 0;
reg [9:0] randNumY = 0;


reg [22:0] difficulty_speed = 8000000;
reg [24:0] gameover_counter = 0;
reg [64:0] counter = 0;
reg [64:0] fruit_counter = 0;
reg [64:0] snake_counter = 0;
reg [11:0] snakeSize = 0;
reg gameover = 0;

reg [5:0]snakeBody [maxSnakeSegments:0][4:0];

reg [9:0]initX1 = 2+(maxSnakeScale*3);
reg [9:0]initX2 = 2+(maxSnakeScale*3)+maxSnakeScale;
reg [9:0]initY1 = 2+(maxSnakeScale*3);
reg [9:0]initY2 = 2+(maxSnakeScale*3)+maxSnakeScale;

reg [9:0]fruitX1 = 2+(maxSnakeScale*9);
reg [9:0]fruitX2 = 2+(maxSnakeScale*9)+maxSnakeScale;
reg [9:0]fruitY1 = 2+(maxSnakeScale*2);
reg [9:0]fruitY2 = 2+(maxSnakeScale*2)+maxSnakeScale;

reg [9:0]boxX1 = initXLetters - 25;
reg [9:0]boxY1 = initYLetters + 5 ;
reg [9:0]difficultyBoxX1 = 360;
reg [9:0]difficultyBoxX2 = 370;
reg [9:0]difficultyBoxY1 = 195;

assign wallLeft = (wall_Left_X1 <= pix_x) && (pix_x <= wall_Left_X2);
assign wallRight = (wall_Right_X1 <= pix_x) && (pix_x <= wall_Right_X2);
assign wallTop = (wall_Top_Y1 <= pix_y) && (pix_y <= wall_Top_Y2);
assign wallBottom = (wall_Bottom_Y1 <= pix_y) && (pix_y <= wall_Bottom_Y2);

assign snake = (initX1 <= pix_x) && (pix_x <= initX2) &&
					(initY1 <= pix_y) && (pix_y <= initY2);

assign fruit = (fruitX1 <= pix_x) && (pix_x <= fruitX2) &&
					(fruitY1 <= pix_y) && (pix_y <= fruitY2);

assign box = (boxX1 <= pix_x) && (pix_x <= boxX1+10) &&
				 (boxY1 <= pix_y) && (pix_y <= boxY1+10);

assign difficultyBox = (difficultyBoxX1 <= pix_x) && (pix_x <= difficultyBoxX2) &&
							  (difficultyBoxY1 <= pix_y) && (pix_y <= difficultyBoxY1+10);

assign score1 = score_reg1;
assign score2 = score_reg2;
assign score3 = score_reg3;
assign score4 = score_reg4;

assign wallRGB = 3'b111; 
assign snakeRGB = 3'b010;
assign fruitRGB = 3'b100;
reg pixelbit;

integer z;
initial begin
	for(z=0; z < maxSnakeSegments; z=z+1)begin
		snakeBody[z][4]=0;
		snakeBody[z][3]=0;
		snakeBody[z][2]=0;
		snakeBody[z][1]=0;
		snakeBody[z][0]=0;
	end
end


always @(posedge clk)begin
	if(currentScreen == 0)begin
		if(difficulty == 0)begin
			difficultyBoxX2 = 370;
			difficultyRGB = 3'b110;
			difficulty_speed = 7000000;
		end
		else if(difficulty == 1)begin
			difficultyBoxX2 = 380;
			difficultyRGB = 3'b010;
			difficulty_speed = 4500000;
		end
		else if(difficulty == 2)begin
			difficultyBoxX2 = 390;
			difficultyRGB = 3'b001;
			difficulty_speed = 2500000;
		end
		else begin
			difficultyBoxX2 = 400;
			difficultyRGB = 3'b100;
			difficulty_speed = 1500000;
		end
	end
end

always @* begin
	if(currentScreen == 0)begin
		if (zN)
			rom_addr_reg <= 8'h14;
		else if (zU||zU2||zU3||zU4)
			rom_addr_reg <= 8'h21;
		else if (zE||zE2||zE3||zE4)
			rom_addr_reg <= 8'h05;
		else if (zV)
			rom_addr_reg <= 8'h22;
		else if (zO||zO2||zO3||zO4)
			rom_addr_reg <= 8'h15;
		else if (zJ||zJ2)
			rom_addr_reg <= 8'h10;
		else if (zG||zG2||zG3)
			rom_addr_reg <= 8'h07;
		else if (zA||zA2||zA3)
			rom_addr_reg <= 8'h01;
		else if (zC||zC2||zC3)
			rom_addr_reg <= 8'h03;
		else if (zR||zR2)
			rom_addr_reg <= 8'h18;
		else if (zD||zD2||zD3)
			rom_addr_reg <= 8'h04;
		else if (zI||zI2||zI3)
			rom_addr_reg <= 8'h09;
		else if (zF)
			rom_addr_reg <= 8'h06;
		else if (zL)
			rom_addr_reg <= 8'h12;
		else if (zT||zT2)
			rom_addr_reg <= 8'h20;
		else if (zS)
			rom_addr_reg <= 8'h19;
		else
			rom_addr_reg <= 8'h00;   
	end
end

always @(posedge clk)
	case (lsbx)
		3'h0: pixelbit <= font_word[0];
		3'h1: pixelbit <= font_word[1];
		3'h2: pixelbit <= font_word[2];
		3'h3: pixelbit <= font_word[3];
		3'h4: pixelbit <= font_word[4];
		3'h5: pixelbit <= font_word[5];
		3'h6: pixelbit <= font_word[6];
		3'h7: pixelbit <= font_word[7];
	endcase
	
always @(posedge clk)
	if(currentScreen == 0)begin
	  if (pixelbit)
			textRGB <= 3'b110;
	  else
			textRGB <= 3'b000;
	end



integer is;
always @(posedge clk)begin
	
	if(~video_on)
		rgb_reg = 3'b111;
	else
		if(currentScreen == 0)begin
			if (wallLeft || wallRight || wallTop || wallBottom)
				rgb_reg = wallRGB;
			else if (zN|zU|zE|zV|zO|zJ|zU2|zE2|zG|zO2|
						zC|zA|zR|zG2|zA2|zJ2|zU3|zE3|zG3|zO3|
						zD|zI|zF|zI2|zC2|zU4|zL|zT|zA3|zD2|
						zC3|zR2|zE4|zD3|zI3|zT2|zO4|zS)
				rgb_reg = textRGB;
			else if(difficultyBox)
				rgb_reg = difficultyRGB;
			else if(box)
				rgb_reg = boxRGB;
			else
				rgb_reg = 3'b000;
		end
		else if(currentScreen == 3 ||currentScreen == 2)begin
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
						(2+(maxSnakeScale*snakeBody[is][3]) <= pix_x) && 
						(pix_x <= 2+(maxSnakeScale*snakeBody[is][2])) &&
						(2+(maxSnakeScale*snakeBody[is][1]) <= pix_y) && 
						(pix_y <= 2+(maxSnakeScale*snakeBody[is][0])) )
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
end
assign graph_rgb =(video_on) ? rgb_reg : 3'b0;

	
integer ix;
integer ifruit;
always @(posedge clk)begin
	if(currentScreen == 0)begin
		firstInit = 0;
		case(currentSelect)
			2'b00: begin
				boxY1 = initYLetters + 5 ;
			end
			2'b01: begin
				boxY1 = initYLetters + 38 ;
			end
			2'b10: begin
				boxY1 = initYLetters + 70 ;
			end
			2'b11: begin
				boxY1 = initYLetters + 103 ;
			end
		endcase
	end
	else if(currentScreen == 2 || currentScreen == 3)begin
		if(currentScreen == 3 && firstInit == 0)begin
			firstInit = 1;
			initX1 = 2+(maxSnakeScale*3);
			initX2 = 2+(maxSnakeScale*3)+maxSnakeScale;
			initY1 = 2+(maxSnakeScale*3);
			initY2 = 2+(maxSnakeScale*3)+maxSnakeScale;
			fruitX1 = 2+(maxSnakeScale*9);
			fruitX2 = 2+(maxSnakeScale*9)+maxSnakeScale;
			fruitY1 = 2+(maxSnakeScale*2);
			fruitY2 = 2+(maxSnakeScale*2)+maxSnakeScale;
			snakeSize = 0;
			score_reg1 <= 0;
			score_reg2 <= 0;
			score_reg3 <= 0;
			score_reg4 <= 0;
			gameover = 0;
			for(z=0; z < maxSnakeSegments; z=z+1)begin
				snakeBody[z][4]<=0;
				snakeBody[z][3]<=0;
				snakeBody[z][2]<=0;
				snakeBody[z][1]<=0;
				snakeBody[z][0]<=0;
			end
		end
		if(initX1 == fruitX1 && initX2 == fruitX2 && 
			initY1 == fruitY1 && initY2 == fruitY2)begin
			
			//Verifica si la fruta cae en la serpiente
			randNumX = snakeBody[0][3];
			randNumY = snakeBody[0][1];
			for(ifruit = 0; ifruit<maxSnakeSegments; ifruit=ifruit+1)begin
				if(snakeBody[ifruit][3] == randX && snakeBody[ifruit][1] == randY)begin
					randNumX = randNumX + 125;
					randNumY = randNumY + 150;
					//ifruit = 0;
				end;
			end
			
			fruitX1=randX;
			fruitX2=randX+25;
			fruitY1=randY;
			fruitY2=randY+25;
			
			snakeBody[snakeSize][4] <= 5;
			snakeSize = snakeSize + 1;
			
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
		end
			
		if(counter == difficulty_speed)begin
			if(gameover && isPaused)begin
				initX1 = 2+(maxSnakeScale*3);
				initX2 = 2+(maxSnakeScale*3)+maxSnakeScale;
				initY1 = 2+(maxSnakeScale*3);
				initY2 = 2+(maxSnakeScale*3)+maxSnakeScale;
				fruitX1 = 2+(maxSnakeScale*9);
				fruitX2 = 2+(maxSnakeScale*9)+maxSnakeScale;
				fruitY1 = 2+(maxSnakeScale*2);
				fruitY2 = 2+(maxSnakeScale*2)+maxSnakeScale;
				snakeSize = 0;
				score_reg1 <= 0;
				score_reg2 <= 0;
				score_reg3 <= 0;
				score_reg4 <= 0;
				gameover = 0;
				for(z=0; z < maxSnakeSegments; z=z+1)begin
					snakeBody[z][4]<=0;
					snakeBody[z][3]<=0;
					snakeBody[z][2]<=0;
					snakeBody[z][1]<=0;
					snakeBody[z][0]<=0;
				end
			end
		
			else if(~isPaused && ~gameover)begin
				for(ix=0; ix < maxSnakeSegments; ix=ix+1)begin
					if(snakeBody[ix][4]===5)begin
						if(initX1/maxSnakeScale == snakeBody[ix][3] && 
							initX2/maxSnakeScale == snakeBody[ix][2] &&
							initY1/maxSnakeScale == snakeBody[ix][1] && 
							initY2/maxSnakeScale == snakeBody[ix][0] )begin
							//score_reg1 <= score_reg1 - 1;
							gameover = 1;
						end
					end
					if(ix==0)begin
						if(snakeBody[0][4] == 5)begin
							snakeBody[ix][3] <= (initX1)/maxSnakeScale;
							snakeBody[ix][2] <= (initX2)/maxSnakeScale;
							snakeBody[ix][1] <= (initY1)/maxSnakeScale;
							snakeBody[ix][0] <= (initY2)/maxSnakeScale;
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
						if(difficulty == 2 || difficulty == 3)
							gameover = 1;
						else begin
							initY1 = 477-maxSnakeScale;
							initY2 = 10'd477;
						end
					end
					else begin
						initY1 = initY1 - maxSnakeScale;
						initY2 = initY2 - maxSnakeScale;
					end
				end
				else if(moveState == 1)begin
					if(initY2 == 477)begin
						if(difficulty == 2 || difficulty == 3)
							gameover = 1;
						else begin
							initY1 = 10'd2;
							initY2 = 2+maxSnakeScale;
						end
					end
					else begin
						initY1 = initY1 + maxSnakeScale;
						initY2 = initY2 + maxSnakeScale;
					end
					
				end
				else if(moveState == 2)begin
					if(initX1 == 2)begin
						if(difficulty == 2 || difficulty == 3)
							gameover = 1;
						else begin
							initX1 = 602-maxSnakeScale;
							initX2 = 10'd602;
						end
					end
					else begin
						initX1 = initX1 - maxSnakeScale;
						initX2 = initX2 - maxSnakeScale;
					end
				end
				else if(moveState == 3)begin
					if(initX2 == 602)begin
						if(difficulty == 2 || difficulty == 3)
							gameover = 1;
						else begin
							initX1 = 10'd2;
							initX2 = 2+maxSnakeScale;
						end
					end
					else begin
						initX1 = initX1 + maxSnakeScale;
						initX2 = initX2 + maxSnakeScale;
					end
				end
			end
			counter = 0;
		end
		else
			counter = counter + 1'b1;
	end
end

assign headX = randNumX;
assign headY = randNumY;

endmodule