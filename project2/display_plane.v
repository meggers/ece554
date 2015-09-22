`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:31 02/10/2014 
// Design Name: 
// Module Name:    draw_logic 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module display_plane(
	input clk,
	input rst,
	input [9:0] pixel_x,
	input [9:0] pixel_y,
	
	output reg [7:0] pixel_r,
	output reg [7:0] pixel_g,
	output reg [7:0] pixel_b
	);
	 
	wire [11:0] rom_addr;
	wire [23:0] rom_color;
	 
	assign rom_addr = {3'b000, pixel_y[9:3]} * 80 + {3'b000, pixel_x[9:3]};
	 
    rom rom1(clk, rom_addr, rom_color);

    always@(*) begin
		pixel_r = 8'h00;
		pixel_g = 8'h00;
		pixel_b = 8'h00;
		if(~rst) begin
			if (pixel_x > 10'd659 || pixel_y > 10'd539) begin
				pixel_r = 8'b0;
				pixel_g = 8'b0;
				pixel_b = 8'b0;
			end else begin
				pixel_r = rom_color[23:16];
				pixel_g = rom_color[15:8];
				pixel_b = rom_color[7:0];
			end
		end
	 end
	 
endmodule
