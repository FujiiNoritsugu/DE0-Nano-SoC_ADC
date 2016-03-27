module ADC_Reader
(convst,
sck,
sdi,
sdo,
clk,
rst,
debug_convst,
debug_sck,
debug_sdi,
debug_mb,
debug_sdo1,
debug_sdo2
);

output convst;
output sck;
output sdi;
input sdo;
input clk;
input rst;

//デバッグ用ポート
output debug_convst;
output debug_sck;
output debug_sdi;
output debug_mb;
output [11:0] debug_sdo1;
output [11:0] debug_sdo2;

//convstスタートビット送出用2000ns(100Hz)計時用カウンタ
reg [23:0] t_cyc;
parameter TCYC = 24'hfa0;
wire over2000ns = (t_cyc == TCYC - 1);

always @(posedge clk or posedge rst) begin
 if(rst) 
    t_cyc <= 7'h00;
 else if(over2000ns)
    t_cyc <= 7'h00;
 else
    t_cyc <= t_cyc + 7'h1;
end

//convstをスタートビットが立てば1にし、かつカウンタが2になれば０にする、それ以外は１
reg conv_reg;
reg conv_counter;
assign convst = conv_reg;
assign debug_convst = conv_reg;
reg [11:0] sdo_reg1;
assign debug_sdo1 = sdo_reg1;
reg[11:0] sdo_reg2;
assign debug_sdo2 = sdo_reg2;
reg ch_type;

always  @(posedge clk or posedge rst) begin
    if(rst) begin
		  conv_reg <= 1'b0;
		  conv_counter <= 1'b0;
	 end
	 else if(over2000ns) begin
        conv_reg <= 1'b1;
        conv_counter <= 1'b1;
		  //convstの立ち上がり時にシフトレジスタの値を入れる
		  //ch_type revert
		  ch_type = ~ch_type;
		  if(ch_type)
		  sdo_reg1 <= data_reg;
		  else
		  sdo_reg2 <= data_reg;
    end
    else if(conv_counter) begin
        conv_reg <= 1'b1;
        conv_counter <= 1'b0;
    end
    else
    conv_reg <= 1'b0;
end

//MB11信号の確認
assign debug_mb = sdo;
// convstの立下りの検出
// sckの立下りの検出
reg [2:0] sreg;
wire clkfall;
always @(posedge clk or posedge rst) begin
    if(rst) begin
		sreg <= 3'b000;
	 end
    else begin
      sreg <= {sreg[1:0],conv_reg};
	 end
end

assign clkfall = sreg[2] & ~sreg[1];

// sckの出力
reg sck_clk;
reg [4:0] sck_clk_counter;
assign sck = sck_clk;
assign debug_sck = sck_clk;
reg sdi_reg;
assign sdi = sdi_reg;
assign debug_sdi = sdi_reg;
reg [6:0] sck_width_counter;
// sckの立下りごとにsdoをレジスタにいれる
reg [11:0] data_reg;

always @(posedge clk or posedge rst) begin
    if(rst) begin
		  sck_clk <= 1'b0;
		  sck_clk_counter <= 1'b0;
		  sdi_reg <= 1'b0;
		  sck_width_counter <= 1'b0;
		  data_reg <= 12'h0;
	 end
	 else if(clkfall) begin
        sck_clk <= 1'b1;
        //sck_clk <= 1'b0;
        sck_clk_counter <= 1'b1;
        //sck_clk_counter <= 1'b0;
		  sck_width_counter <= 1'b1;
		  //data_reg <= 12'h0;
    end
    else if(sck_clk_counter < 5'b11010) begin
		  if(sck_width_counter == 7'h50) begin
            sck_clk <= ~sck_clk;
				//sck_clkの立下りにsdoの値をシフトレジスタに入れる
				if(sck_clk == 1'b0)
	              data_reg <= {data_reg[10:0], sdo};
				sck_width_counter <= 7'h0;
            sck_clk_counter <= sck_clk_counter + 1'b1;
				
				if(sck_clk_counter == 5'b10 || sck_clk_counter == 5'b1010)
					sdi_reg <= 1'b1;
				else if(ch_type && sck_clk_counter == 5'b100)
				   sdi_reg <= 1'b1;
				else
					sdi_reg <= 1'b0;
			  //if(sck_clk_counter == 5'b11001)
			  //   sdo_reg <= data_reg;
		  end
		  else
		     sck_width_counter <= sck_width_counter + 1'b1;
    end
    else begin
        sck_clk <= 1'b0;
		  sdi_reg <= 1'b0;
	end
end

endmodule
