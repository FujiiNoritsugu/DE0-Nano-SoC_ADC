module Test20160617
#(parameter array_length = 2)
(
input logic clk,
input logic rst,
output logic [31:0] output_data,
output logic led,
output logic convst,
output logic sck,
output logic sdi,
input logic sdo
);

logic adc_clk;

// for ADC Clock
adc50to40 adc_ref(
	.refclk(clk),
	.rst(rst),
	.outclk_0(adc_clk)
);

// ADC reader
ADC_Reader  adc_read
(
 .convst(convst),
 .sck(sck),
 .sdi(sdi),
 .sdo(sdo),
 .clk(adc_clk),
 .rst(rst),
 .debug_convst(),
 .debug_sck(),
 .debug_sdi(),
 .debug_mb(),
 .debug_sdo1(input_data_array[0]),
 .debug_sdo2(input_data_array[1])
);

logic [7:0] index_data_array[1:0];
logic [11:0] input_data_array[1:0];
logic [11:0] output_data_array[1:0];
logic we;
logic endLED_array[1:0];

// calc data
// 2センサの積和演算を同時に2インスタンスで実行する
genvar i;
generate
	for(i = 0; i < array_length; i = i + 1) begin : parallelcalc
		Test20160516 test20160516(
			.clk(clk),
			.rst(rst),
			.index_data(index_data_array[i]),
			.input_data(input_data_array[i]),
			.output_data(output_data_array[i]),
			.we(we),
			.endLED(endLED_array[i])
		);
	end
endgenerate

// 両方の積和演算が終了するとLEDを光らせる
always_ff @(posedge clk) begin
	if(endLED_array[0] && endLED_array[1]) begin
		output_data <= output_data_array[0] + output_data_array[1];
		led <= 1'b1;
	end
	else begin
		led <= 1'b0;
	end
end

// convstの立ち上がりが10回ごとにデータを入力モードから演算モードに変更する
logic [3:0] mode_counter;
always_ff @(posedge convst) begin
	if(mode_counter > 4'ha) begin
		we <= ~we;
		mode_counter <= 4'h0;
	end
	else begin
		mode_counter <= mode_counter + 4'h1;
	end
end

endmodule
