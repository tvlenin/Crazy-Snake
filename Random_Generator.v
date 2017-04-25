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
		if (pulse[14] ==  0)begin
			randomX = (xValues[1:0] + pulse[0]) * yValues[2:0];
			randomY = yValues[1:0]  * (xValues[2:0]+ pulse[0]);
		end 
		else begin
			randomX = (xValues[1:0] ) * (yValues[2:0]+ pulse[0]);
			randomY = (yValues[1:0]+ pulse[0])  * (xValues[2:0]);
		end
	

end//always
assign randNumX = (randomX*25)+2;
assign randNumY = (randomY*25)+2;
endmodule
