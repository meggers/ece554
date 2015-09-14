module baudRateGenerator(
    input clk,
    input rst,
    input [7:0] data,
    input [1:0] ioaddr,

    output rxenable,
    output txenable
    );

	reg enable;
	reg [15:0] divisor;

	reg setCounter;
	wire loadCounter;
	wire counterZero;
	wire [15:0] count;
	
	assign loadCounter = setCounter | counterZero;

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
		.zero(counterZero)
	);

	always @(posedge clk) begin
		if(rst) begin
			enable <= 0;
			setCounter <= 0;
		end else begin
			setCounter <= 1;
			
			case (ioaddr)
				2'b00: begin // transmit buffer
					enable <= counterZero;
					setCounter <= 0;
				end
				2'b01: begin // status register
					enable <= 0;
					setCounter <= 0;
				end
				2'b10: begin // low divisor
					divisor[7:0] <= data;
					enable <= 0;
					setCounter <= 0;
				end
				2'b11: begin // high divisor
					divisor[15:8] <= data;
					enable <= 0;
					setCounter <= 1;
				end

			endcase

		end

	end

	assign rxenable = enable;
	assign txenable = enable;

endmodule

module baudRateDownCounter(
	input clk,
	input rst,
	input [15:0] divisor,
	input load,

	output reg [15:0] count
	);

	always @(posedge clk) begin
		if(rst)
			count <= 16'b0000000000000000;
		else
			count <= load ? divisor : count - 1;
	end

endmodule


module baudRateDecoder(
	input [15:0] count,

	output zero
	);

	assign zero = count == 0;

endmodule


module t_baudRateGenerator();
	
	reg clk, rst;
	reg [7:0] data;
	reg [1:0] ioaddr;
	wire rxenable;
	wire txenable;
	
	baudRateGenerator brg(
		.clk(clk),
		.rst(rst),
		.data(data),
		.ioaddr(ioaddr),

		.rxenable(rxenable),
		.txenable(txenable)
    );
	
	reg [15:0] divisor;
	wire [15:0] count;
	reg loadCounter;
	
	baudRateDownCounter brc(
		.clk(clk),
		.rst(rst),
		.load(loadCounter),
		.divisor(divisor),
		.count(count)
    );
	
	
	initial begin
	
		clk = 0;
		rst = 1;
		#10;
		rst = 0;
		
		loadCounter = 1;
		divisor = 8;
		ioaddr = 2'b10;
		data = 8'b00000111;
		#10;
		loadCounter = 0;
		ioaddr = 2'b11;
		data = 8'b00000000;
		#10;
		$display("divisor %d", brc.count);
		$display("counter %b", brc.count);
		ioaddr = 2'b00;
		
		repeat(50) begin
			$display("counter %b", brg.dc0.count);
			#10;
		end
		
		
		$finish();
	
	end
	
	
	always @(posedge rxenable or negedge rxenable) begin
		$display("enable: %d", rxenable);
	end
	
	always begin
		#5 clk = !clk;
	end

endmodule




