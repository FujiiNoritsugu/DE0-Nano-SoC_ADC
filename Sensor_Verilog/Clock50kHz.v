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
