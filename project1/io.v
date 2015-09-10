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

            // if we are in the middle of writing
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

            // I don't know what state this is
            end else begin
                tbr <= tbr;
                out <= out;
                shiftReg <= shiftReg;
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

    output reg rda,
    output reg [7:0] data
    );

    reg [9:0] shiftReg; // two extra bits for start and stop

    always @(posedge clk) begin

        // reset
        if (rst) begin
            shiftReg <= 10'b1;
            data <= 8'b0;
            rda <= 1'b0;

        // read operation is occuring
        end else if (iorw) begin
            rda <= 1'b0;
            shiftReg <= 10'b1;
            data <= data;

        // read baud
        end else if (enable) begin

            // we have received a full byte
            if (~shiftReg[0] & shiftReg[9]) begin
                data <= shiftReg;
                shiftReg <= 10'b1;
                rda <= 1'b1;

            // we are still reading
            end else begin
                data <= data;
                rda <= rda;
                shiftReg <= {in, shiftReg[9:1]};
            end

        // idle
        end else begin
            shiftReg <= shiftReg;
            data <= data;
            rda <= rda;
        end

    end

endmodule