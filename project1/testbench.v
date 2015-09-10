module testbench();

wire [1:0] cfg;
wire recieveData;
wire transmitData;
reg clk, rst_n;

top_level uut(
  .clk(clk),
  .rst(rst_n),
  .txd(transmitData),
  .rxd(recieveData),
  .br_cfg(cfg)
);

always #5 clk = ~clk;
assign cfg = 2'b00;

initial begin
  clk = 1'b0;
  rst_n = 1'b0;
  #1 rst_n = 1'b1;
  #10 rst_n = 1'b0;
end

initial begin
  $dumpfile("test.vcd");
  $dumpvars(0, uut);
end

initial begin
  #7500;
  $finish;
end

endmodule