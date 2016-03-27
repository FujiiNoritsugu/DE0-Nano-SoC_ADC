module range_ctrl2 (
    input clk,
    input reset,

    output [7:0] range1,
    output [7:0] range2,

    input write,
    input [15:0] writedata
);

reg [7:0] range1_intern = 8'b10000000;
reg [7:0] range2_intern = 8'b10000000;

assign range1 = range1_intern;
assign range2 = range2_intern;

always @(posedge clk) begin
    if (reset) begin
        range1_intern <= 8'b10000000;
        range2_intern <= 8'b10000000;
    end
    else if (write) begin
        if (writedata[7:0] != 8'b00000000)
        range1_intern <= writedata[7:0];
        if (writedata[15:8] != 8'b00000000)
        range2_intern <= writedata[15:8];
    end
end

endmodule
