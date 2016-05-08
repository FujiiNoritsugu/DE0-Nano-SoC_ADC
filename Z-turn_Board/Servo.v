`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/05/24 17:18:06
// Design Name: 
// Module Name: Servo
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


module Servo(
    clkin,
    rstn,
    cntin,
    pwmout
    );
    
    input clkin;
     input rstn;
     input [11:0]cntin;
     output reg pwmout;
     reg [11:0]counter;

    always@(posedge clkin or posedge rstn)
     begin
         if (rstn == 1'b1) begin
             counter = 11'd0;
             pwmout = 1'b0;
          end
         else begin
             if (counter > 11'd999) begin
                 counter = 11'd0;
                 pwmout = 1'b1;
             end
             else if (counter < cntin)
                 pwmout = 1'b1;
             else
                 pwmout = 1'b0;
             counter = counter + 1'b1;
        end
     end

endmodule
