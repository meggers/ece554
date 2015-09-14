module testbench();

wire [1:0] cfg;
wire tx;
reg clk, rst_n, rx;

top_level uut(
  .clk(clk),
  .rst(rst_n),
  .txd(tx),
  .rxd(rx),
  .br_cfg(cfg)
);

always #1 clk = ~clk;
always #1 rx = ~rx;
assign cfg = 2'b00;

initial begin
  rx = 1'b1;
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
  #10000;
  $finish;
end

endmodule