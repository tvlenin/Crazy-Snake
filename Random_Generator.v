`timescale 1ns / 1ps

module Random_Generator(
	input clock,
	input [9:0] yValues,
	input [9:0] xValues,
	output [9:0] randNumX,
	output [9:0] randNumY
);
reg [28:0]pulse;
reg [3:0]sec;
reg [9:0] randomX;
reg [9:0] randomY;
initial begin
	pulse = 0;
	sec = 0;
	randomX = 27;
	randomY = 27;
end// initial

always@(posedge clock)begin
		pulse = pulse +1;
		randomX = (xValues[1:0] ) * (yValues[3:1]+ pulse[0]);
		randomY = (yValues[5:4]+ pulse[0])  * (xValues[2:0]);
		if (randomX > 20)
			randomX = randomX - yValues[3:1]; 
		else if (randomY > 19)
			randomY = 18;
		else if (randomX == 0 && randomY == 0)begin
			randomY = (yValues[6:5]+ pulse[0])  * (xValues[5:3]);
			randomX = (xValues[3:2] ) * (yValues[5:2]+ pulse[23]);
		end
		else begin
			randomY = (yValues[5:4]+ pulse[0])  * (xValues[2:0]);
			randomX = (xValues[1:0] ) * (yValues[3:1]+ pulse[0]);
		end
end//always
assign randNumX = (randomX*25)+2;
assign randNumY = (randomY*25)+2;
endmodule
