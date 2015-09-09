module transmit(
    input clk,
    input rst,
    input iocs,
    input iorw,
    input enable,
    input [1:0] ioaddr,
    input [7:0] data,

    output reg out,
    output reg tbr
    );

    reg [9:0] shiftReg; // two extra bits for start and stop

    always @(posedge clk) begin
        // reset
        if (rst) begin
            tbr <= 1'b1;
            out <= 1'b1;
            shiftReg <= 10'b1;

        // write baud
        end else if (enable) begin

            // if write enable and start write
            if (~iorw & tbr) begin
                shiftReg <= {1'b0, data, 1'b1};
                tbr <= 1'b0;
            end else if (~tbr) begin

                // shift out data
                out <= shiftReg[0];
                shiftReg <= {1'b1, shiftReg[7, 1]};

                // if all data shifted out, signal ready
                if (&shiftReg) begin
                    tbr <= 1'b1;
                end else begin
                    tbr <= tbr;
                end
            end

        // idle
        end else begin
            tbr <= tbr;
            out <= out;
            shiftReg <= shiftReg;
        end
    end

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