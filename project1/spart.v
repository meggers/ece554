`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name:    spart
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
module spart(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );

    wire [7:0] data, rxBuffer;
    wire rxenable, txenable, rda, tbr;

    baudRateGenerator brg0(
        .clk(clk),
        .rst(rst),
        .data(data),
        .ioaddr(ioaddr),

        .rxenable(rxenable),
        .txenable(txenable)
    );

    busInterface bi0(
        .rst(rst),
        .rda(rda),
        .tbr(tbr),
        .iocs(iocs),
        .iorw(iorw),
        .ioaddr(ioaddr),
        .rxBuffer(rxBuffer),

        .databus(databus),

        .data(data),
    );

    transmit tx0(
        .clk(clk),
        .rst(rst),
        .data(data),
        .enable(txenable),
    );

    receive rx0(
        .clk(clk),
        .rst(rst),
        .enable(rxenable),
    );

endmodule

module baudRateGenerator(
    input clk,
    input rst,
    input [7:0] data,
    input [1:0] ioaddr,

    output rxenable,
    output txenable
    );

endmodule

module busInterface(
    input rst,
    input rda,
    input tbr,
    input iocs,
    input iorw,
    input [7:0] rxBuffer,
    input [1:0] ioaddr,
    inout [7:0] databus,

    output [7:0] data
    );

endmodule

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