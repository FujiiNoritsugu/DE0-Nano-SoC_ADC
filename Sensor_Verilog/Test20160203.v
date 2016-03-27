// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus II License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 15.0.1 Build 150 06/03/2015 SJ Web Edition"
// CREATED		"Wed Feb 17 04:40:17 2016"

module Test20160203(
	clk,
	reset,
	sdo,
	convst,
	sck,
	sdi,
	debug_convst,
	debug_sck,
	debug_sdi,
	debug_mb,
	servo1,
	servo2,
 memory_mem_a,         //        memory.mem_a
 memory_mem_ba,        //              .mem_ba
 memory_mem_ck,        //              .mem_ck
 memory_mem_ck_n,      //              .mem_ck_n
 memory_mem_cke,       //              .mem_cke
 memory_mem_cs_n,      //              .mem_cs_n
 memory_mem_ras_n,     //              .mem_ras_n
 memory_mem_cas_n,     //              .mem_cas_n
 memory_mem_we_n,      //              .mem_we_n
 memory_mem_reset_n,   //              .mem_reset_n
 memory_mem_dq,        //              .mem_dq
 memory_mem_dqs,       //              .mem_dqs
 memory_mem_dqs_n,     //              .mem_dqs_n
 memory_mem_odt,       //              .mem_odt
 memory_mem_dm,        //              .mem_dm
 memory_oct_rzqin     //              .oct_rzqin	
);


input wire	clk;
input wire	reset;
input wire	sdo;
output wire	convst;
output wire	sck;
output wire	sdi;
output wire	debug_convst;
output wire	debug_sck;
output wire	debug_sdi;
output wire	debug_mb;
output wire	servo1;
output wire	servo2;
output wire [12:0] memory_mem_a;         //        memory.mem_a
output wire [2:0]  memory_mem_ba;        //              .mem_ba
output wire        memory_mem_ck;        //              .mem_ck
output wire        memory_mem_ck_n;      //              .mem_ck_n
output wire        memory_mem_cke;       //              .mem_cke
output wire        memory_mem_cs_n;      //              .mem_cs_n
output wire        memory_mem_ras_n;     //              .mem_ras_n
output wire        memory_mem_cas_n;     //              .mem_cas_n
output wire        memory_mem_we_n;     //              .mem_we_n
output wire        memory_mem_reset_n;   //              .mem_reset_n
inout  wire [7:0]  memory_mem_dq;        //              .mem_dq
inout  wire        memory_mem_dqs;       //              .mem_dqs
inout  wire        memory_mem_dqs_n;     //              .mem_dqs_n
output wire        memory_mem_odt;       //              .mem_odt
output wire        memory_mem_dm;        //              .mem_dm
input  wire        memory_oct_rzqin;     //              .oct_rzqin

wire	SYNTHESIZED_WIRE_0;
wire	[11:0] SYNTHESIZED_WIRE_1;
wire	[11:0] SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_7;
wire	[7:0] SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_6;





ADC_Reader	b2v_inst(
	.sdo(sdo),
	.clk(SYNTHESIZED_WIRE_0),
	.rst(reset),
	.convst(convst),
	.sck(sck),
	.sdi(sdi),
	.debug_convst(debug_convst),
	.debug_sck(debug_sck),
	.debug_sdi(debug_sdi),
	.debug_mb(debug_mb),
	.debug_sdo1(SYNTHESIZED_WIRE_1),
	.debug_sdo2(SYNTHESIZED_WIRE_2));
	defparam	b2v_inst.TCYC = 24'b000000000000111110100000;


adc_50_to_40	b2v_inst1(
	.refclk(clk),
	.rst(reset),
	.outclk_0(SYNTHESIZED_WIRE_0));


adc_hps	b2v_inst2(
	.clk_clk(clk),
		.memory_mem_a(memory_mem_a),
   .memory_mem_ba(memory_mem_ba),
   .memory_mem_ck(memory_mem_ck),
   .memory_mem_ck_n(memory_mem_ck_n),
   .memory_mem_cke(memory_mem_cke),
   .memory_mem_cs_n(memory_mem_cs_n),
   .memory_mem_ras_n(memory_mem_ras_n),
   .memory_mem_cas_n(memory_mem_cas_n),
   .memory_mem_we_n(memory_mem_we_n),
   .memory_mem_reset_n(memory_mem_reset_n),
   .memory_mem_dq(memory_mem_dq),
   .memory_mem_dqs(memory_mem_dqs),
   .memory_mem_dqs_n(memory_mem_dqs_n),
   .memory_mem_odt(memory_mem_odt),
   .memory_mem_dm(memory_mem_dm),
   .memory_oct_rzqin(memory_oct_rzqin),
	.reset_reset_n(~reset),	
	.socket_to_hps_value1(SYNTHESIZED_WIRE_1),
	.socket_to_hps_value2(SYNTHESIZED_WIRE_2),
	.socket_to_hps_range1(SYNTHESIZED_WIRE_4),
	.socket_to_hps_range2(SYNTHESIZED_WIRE_6));


Servo	b2v_inst4(
	.clkin(SYNTHESIZED_WIRE_7),
	.rstn(reset),
	.cntin(SYNTHESIZED_WIRE_4),
	.pwmout(servo2));


Servo	b2v_inst5(
	.clkin(SYNTHESIZED_WIRE_7),
	.rstn(reset),
	.cntin(SYNTHESIZED_WIRE_6),
	.pwmout(servo1));


Clock50kHz	b2v_inst6(
	.clockin50mHz(clk),
	.clockout(SYNTHESIZED_WIRE_7));


endmodule
