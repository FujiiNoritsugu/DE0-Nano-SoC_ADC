`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/05/25 06:09:40
// Design Name: 
// Module Name: Clock50kHz
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Clock50kHz(
        clockin50mHz,
        clockout
    );

    input clockin50mHz;
    output reg clockout;
    
    reg [9:0] counter;
    
     always @(negedge clockin50mHz)
     begin
         if (counter > 120) begin
             counter <= 0;
             clockout <= ~clockout;
             end
         else begin
             counter <= counter + 1;
             end
    
     end

endmodule
