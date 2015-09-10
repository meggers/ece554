module cpu_tb();

wire [15:0] pc;
wire hlt;
reg clk, rst_n;

top_level uuu(
  .clk(clk),
  .rst(rst_n),
  .txd(transmitData),
  .rxd(recieveData),
  .br_cfg(cfg));

wire cfg;
wire recieveData;
wire transmitData;


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
  $dumpvars(0, cpu_tb);
end

initial begin
  #7500;
  $finish;
end

endmodule