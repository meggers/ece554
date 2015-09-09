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
        .iocs(iocs),
        .iorw(iorw),
        .enable(txenable),
        .ioaddr(ioaddr),
        .data(data),

        .out(txd),
        .tbr(tbr)
    );

    receive rx0(
        .in(data),
        .clk(clk),
        .rst(rst),
        .iocs(iocs),
        .iorw(iorw),
        .enable(rxenable),
        .ioaddr(ioaddr),

        .rda(rda),
        .data(rxBuffer)
    );

endmodule