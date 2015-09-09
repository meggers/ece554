module busInterface(
    input rda,
    input tbr,
    input iocs,
    input iorw,
    input [7:0] rxBuffer,
    input [1:0] ioaddr,

    inout [7:0] databus,

    output [7:0] data
    );

    reg [7:0] internalDataBus;
    always @(ioaddr) begin
        if (iocs) begin
            case(ioaddr)
                2'b00: begin
                    if (iorw) begin
                        internalDataBus = rxBuffer;
                    end else begin
                        internalDataBus = databus;
                    end
                end

                2'b01: begin
                    internalDataBus = {6'b0, tbr, rda};
                end

                2'b10: begin
                    internalDataBus = databus;
                end

                2'b11: begin
                    internalDataBus = databus;
                end
        end else begin
            internalDataBus = 8'bz;
        end
    end

    assign databus = iorw ? internalDataBus : 8'bz;
    assign data = internalDataBus;

endmodule
