module Test20160516
(
input clk,
input rst, // startの有無
input logic [7:0] index_data,
input logic [7:0] input_data,
output logic [7:0] output_data,
output we,
output endLED
);

logic [7:0] k_data;
logic [7:0] r_data;

// 10回ループを回して積和を計算させる
//assign output_data = k_data * input_data + r_data;

// writeイネーブル信号の作成
logic write_enable = 1'b0;
logic [31:0]enable_counter = 32'h0;
assign we = write_enable;

logic [7:0] ram_index = 8'h0;
logic [7:0] sum_data = 8'h0;
logic [7:0] sum_index = 8'h0;

logic end_led = 1'b0;
assign endLED = end_led;

always_ff @(posedge clk) begin
if(rst) begin
	write_enable <= 1'b0;
	if(sum_index > 8'h2) begin
		end_led <= 1'b1;
		output_data <= sum_data;
	end
	else begin
		// １秒ごとに積和計算
       //if(enable_counter > 32'h2faf080) begin
      if(enable_counter > 32'h2faf08) begin
    		 sum_index <= sum_index + 1'h1;
		     ram_index <= sum_index;
	        sum_data <= k_data *  r_data + sum_data;
		     enable_counter <= 32'h0;
			  end
			  else begin
			  		enable_counter <= enable_counter + 1;
	        end
	        end_led <= 1'b0;
    end
end
else begin
	end_led <= 1'b0;
	write_enable <= 1'b1;
	ram_index <= index_data;
end

   // １秒ごとのシグナル
 //  if (enable_counter > 32'h2faf080) begin
//	   sum_index <= sum_index + 1'h1;
//	   write_enable <= ~write_enable;
//		enable_counter <= 32'h0;
//	end
//	else begin
//		enable_counter <= enable_counter + 1;
//	end

end
 
rRAM rram(
	.address(ram_index),
	.clock(clk),
	.data(input_data),
	.wren(write_enable),
	.q(r_data)
);

kROM krom(
	.address(ram_index),
	.clock(clk),
	.q(k_data)
);

endmodule
