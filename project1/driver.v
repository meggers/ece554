`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name:    driver
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
module driver(
    input clk,
    input rst,
    input [1:0] br_cfg,
    input rda,
    input tbr,

    inout [7:0] databus

    output iocs,
    output iorw,
    output [1:0] ioaddr,
    );

    localparam divisor0 = 16'd1301;
    localparam divisor1 = 16'd650;
    localparam divisor2 = 16'd325;
    localparam divisor3 = 16'd162;

    reg [1:0] currentState;
    reg [1:0] nextState;

    wire [15:0] divisor;
    assign divisor = br_cfg == 2'b00 ? divisor0 :
                     br_cfg == 2'b01 ? divisor1 :
                     br_cfg == 2'b10 ? divisor2 : divisor3;

    always @(posedge clk) begin
        if (rst)
            begin
                currentState = 2'b10;
                nextState = 2'b11;

                ioaddr = 2'b10;
                databus = 8'b0;
                iocs = 1'b0;
                iorw = 1'b0;
            end
        else
            begin
                ioaddr = currentState;
                case (currentState)
                    2'b00 : begin

                    end

                    2'b01 : begin

                    end

                    2'b10 : begin
                        databus = divisor[7:0];
                    end

                    2'b11 : begin
                        databus = divisor[15:8];
                    end
                endcase

                currentState = nextState;
            end
    end

endmodule
