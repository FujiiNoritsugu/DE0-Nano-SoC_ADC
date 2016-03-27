module socket_to_hps(
    input clk,
    input reset,

    input [11:0] value1,
    input [11:0] value2,
 
    input read,
    output [31:0] readdata,
	 
	 output [7:0] range1,
    output [7:0] range2,

    input write,
    input [31:0] writedata
);

reg [31:0] readdata_reg;
assign readdata = readdata_reg;

reg [7:0] range1_intern = 8'b10000000;
reg [7:0] range2_intern = 8'b10000000;

assign range1 = range1_intern;
assign range2 = range2_intern;

always @(posedge clk) begin

if(read) begin
     readdata_reg[11:0] <= value1; 
     readdata_reg[23:12] <= value2 ;
end

if (write) begin
    if (writedata[7:0] != 8'b00000000)
        range1_intern <= writedata[7:0];
    if (writedata[15:8] != 8'b00000000)
        range2_intern <= writedata[15:8];
end

end

endmodule
