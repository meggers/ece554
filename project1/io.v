module transmit(
    input clk,
    input rst,
    input iocs,
    input iorw,
    input enable,
    input [1:0] ioaddr,
    input [7:0] data,

    output out,
    output tbr
    );

endmodule

module receive(
    input in,
    input clk,
    input rst,
    input iocs,
    input iorw,
    input enable,
    input [1:0] ioaddr,

    output rda,
    output [7:0] data
    );

endmodule