`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:06 02/10/2014 
// Design Name: 
// Module Name:    main_logic 
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
module main_logic(clk, rst, pixel_x, pixel_y, pixel_r, pixel_g, pixel_b);

    input clk;
    input rst;
    input [9:0] pixel_x;
    input [9:0] pixel_y;
	 
    output [7:0] pixel_r;
    output [7:0] pixel_g;
    output [7:0] pixel_b;
	 
	 display_plane draw1(clk, rst, pixel_x, pixel_y, pixel_r, pixel_g, pixel_b);

endmodule
