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

    inout [7:0] databus,

    output reg iocs,
    output reg iorw,
    output reg [1:0] ioaddr
    );

    localparam divisor0 = 16'd1301;
    localparam divisor1 = 16'd650;
    localparam divisor2 = 16'd325;
    localparam divisor3 = 16'd162;

	 reg dataAvailableToRead, dataAvailableToWrite;
    reg [1:0] currentState;
    reg [1:0] nextState;
	 reg [7:0] internalData;
	 reg [7:0] statusRegister;

    wire [15:0] divisor;
    assign divisor = br_cfg == 2'b00 ? divisor0 :
                     br_cfg == 2'b01 ? divisor1 :
                     br_cfg == 2'b10 ? divisor2 : divisor3;

	 assign databus = ~iorw ? internalData : 8'bz;
    always @(posedge clk) begin
        if (rst)
            begin
                ioaddr <= 2'b10;
                currentState <= 2'b10;
                nextState <= 2'b11;

				 	 dataAvailableToRead <= 1'b0;
					 dataAvailableToWrite <= 1'b0;
					 
					 internalData <= 8'b0;
					 statusReg <= 8'b0;

                iocs <= 1'b0;
                iorw <= 1'b0;
            end
        else
            begin
					 iocs <= 1'b1;
                ioaddr <= currentState;
                case (currentState)
                    2'b00 : begin
						  
								// if data was read last cycle it is now available
								if (dataAvailableToRead) begin
									iorw <= 1'b1;
									dataAvailableToRead <= 1'b0;
									dataAvailableToWrite <= 1'b1;
									
									internalData <= databus;
								
								// if read data is available
								end else if (rda) begin
									iorw <= iorw;
									dataAvailableToRead <= 1'b1;
									dataAvailableToWrite <= dataAvailableToWrite;
									
									internalData <= internalData;
									
								// if write data is available
								end else if (tda & dataAvailableToWrite) begin
									iorw <= 1'b0;
									dataAvailableToRead <= dataAvailableToRead;
									dataAvailableToWrite <= 1'b0;
									
									internalData <= internalData;
								
								// idle? idk
								end else begin
									iorw <= iorw;
									dataAvailableToRead <= dataAvailableToRead;
									dataAvailableToWrite <= dataAvailableToWrite;
									
									internalData <= internalData;
								end
								
								statusReg <= statusReg;
								
								nextState <= 2'b00;
                    end

                    2'b01 : begin
                        iorw <= 1'b1;
								dataAvailableToRead <= dataAvailableToRead;
								dataAvailableToWrite <= dataAvailableToWrite;
								
								statusReg <= databus;
								internalData <= internalData;
								
								nextState <= 2'b00;
                    end

                    2'b10 : begin
                        iorw = 1'b0;
								dataAvailableToRead <= dataAvailableToRead;
								dataAvailableToWrite <= dataAvailableToWrite;
								
								statusReg <= statusReg;
                        internalData <= divisor[7:0];
								
								nextState <= 2'b11;
                    end

                    2'b11 : begin
                        iorw = 1'b0;
								dataAvailableToRead <= dataAvailableToRead;
								dataAvailableToWrite <= dataAvailableToWrite;
								
								statusReg <= statusReg;
                        internalData <= divisor[15:8];
								
								nextState <= 2'b11;
                    end
                endcase

                currentState <= nextState;
            end
    end

endmodule
