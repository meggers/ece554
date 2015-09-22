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
module main_logic(
	input clk_100mhz,
	input clk_25mhz,
	input rst,
	input [9:0] pixel_x,
	input [9:0] pixel_y,
	
	output [7:0] pixel_r,
	output [7:0] pixel_g,
	output [7:0] pixel_b
	);
	
	wire fifo_full;
	wire fifo_empty;
	wire [23:0] fifo_din;
	wire [23:0] fifo_dout;
	reg fifo_wr_en;
	
	wire [7:0] dp_r;
	wire [7:0] dp_g;
	wire [7:0] dp_b;
	
	reg [9:0] curr_x;
	reg [9:0] curr_y;
	wire [9:0] next_x;
	wire [9:0] next_y;
	
	
	assign next_x = (curr_x == 10'd640) ? (10'd0) : (curr_x + 10'd1);
	assign next_y = (curr_x == 10'd640) ? (
						(curr_y == 10'd480) ? (10'd0) : (curr_y + 10'd1)
					):(
						curr_y
					);
	
	 
	display_plane draw1(
		clk_100mhz,
		rst,
		curr_x,
		curr_y,
		// outputs
		dp_r,
		dp_g,
		dp_b
	);
	
	assign fifo_din = {dp_r, dp_g, dp_b}; // in from display plane
	assign {pixel_r, pixel_g, pixel_b} = fifo_dout; // out of module
	
	xclk_fifo xclk_fifo1(
		.wr_clk(clk_100mhz),
		.rd_clk(clk_25mhz),
		.din(fifo_din),
		.rst(rst),
		.full(fifo_full),
		.empty(fifo_empty),
		.dout(fifo_dout),
		.wr_en(fifo_wr_en),
		.rd_en(1'b1)
	);
	
	always @(posedge clk_100mhz) begin
		if(rst) begin
			curr_x <= 10'd0; // maybe set to pixel_x/pixel_y here???
			curr_y <= 10'd0;
			fifo_wr_en <= 1'b1; // write on next cycle
		end else begin
			if(~fifo_wr_en || fifo_full) begin
				// idle
				curr_x <= curr_x;
				curr_y <= curr_y;
				
				// might miss a clock cycle here, but it might not matter
				fifo_wr_en <= fifo_empty; // do not enable until empty
			end else begin
				// writing
				curr_x <= next_x;
				curr_y <= next_y;
				fifo_wr_en <= fifo_wr_en;
			end
		end
		
	end
	
endmodule
