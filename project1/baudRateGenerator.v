module baudRateGenerator(
    input clk,
    input rst,
    input [7:0] data,
    input [1:0] ioaddr,

    output rxenable,
    output txenable
    );

	reg enable;

	wire [15:0] divisor;
	wire loadCounter;
	wire [15:0] count;

	baudRateDivisorBuffer db0(
		// in
		.clk(clk),
		.rst(rst),
		.ioaddr(ioaddr)
		.data(data)
		// out
		.divisor(divisor)
	);

	baudRateDownCounter dc0(
		// in
		.clk(clk),
		.rst(rst),
		.divisor(divisor),
		.load(loadCounter),
		// out
		.count(count)
	);


	baudRateDecoder dec0(
		//in
		.count(count),
		// out
		.zero(loadCounter)
	);



	always @(posedge clk) begin
		if(rst) begin
			enable = 0;
		else begin

			case (ioaddr)
				2b'00: begin // transmit buffer
					enable = loadCounter;
				end
				2b'01: begin // status register

				end
				2b'10: begin // low divisor
					divisor[7:0] <= data;
				end
				2b'11: begin // high divisor
					divisor[15:8] <= data;
				end

			endcase

		end

	end

	assign rxenable = enable;
	assign txenable = enable;

endmodule


module baudRateDivisorBuffer(
	input clk,
	input rst,
	input [1:0] ioaddr,
	input [7:0] data,

	output reg [15:0] divisor
	);

	always @(posedge clk) begin
		if(rst) begin
			divisor <= 0;
		else begin
			if(ioaddr == 2b'10)
				divisor[7:0] <= data;
			else if(ioaddr == 2b'11)
				divisor[15:8] <= data;
		end

	end


endmodule



module baudRateDownCounter(
	input clk,
	input rst,
	input [15:0] divisor,
	input load,

	output [15:0] count
	);

	reg [15:0] tmpCount;

	always @(posedge clk) begin
		if(rst)
			tmpCount = 0;
		else
			tmpCount = load ? divisor : tmpCount - 1;
		end
	end

	assign count = tmpCount;

endmodule


module baudRateDecoder(
	input [15:0] count,

	output zero
	);

	assign zero = count == 0;

endmodule




