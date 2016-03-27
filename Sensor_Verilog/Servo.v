module Servo(
    clkin,
    rstn,
    cntin,
    pwmout
    );
    
    input clkin;
     input rstn;
     input [7:0]cntin;
     output reg pwmout;
     reg [11:0]counter;
	  //reg [7:0] cntin_intern;
	  //wire [7:0] cntin_wire = cntin;
	  //assign cntin_wire = cntin_intern;
	  
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
