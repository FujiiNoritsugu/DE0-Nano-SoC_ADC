`timescale 1 ps / 1 ps

module mys_xc7z010_trd
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
       //LCD
    LCD_DATA,
    LCD_VSYNC,
    LCD_HSYNC,
    LCD_DE,
    LCD_PCLK,
       
    I2S_SCLK,
    I2S_FSYNC_OUT,
    I2S_DOUT,
    I2S_FSYNC_IN,
    I2S_DIN,
       
    HDMI_INTn,
    MEMS_INTn,
      
    I2C0_SDA,
    I2C0_SCL,
    
       //user define io,
    /*   
       IO_B13_LP,//11:15
       IO_B13_LN,
       
       IO_B13_LP21,
       IO_B13_LN21,
    */   
    IO_B34_LP,
    IO_B34_LN,
       
    IO_B34_LP6,
    IO_B34_LP8,
    IO_B34_LN8,
           
    IO_B35_LP,
    IO_B35_LN,
       
    IO_B34_LP11,// PL_iCLK12M,
    IO_B34_LN11,
    
    SW,
    BP,
    LEDS);
       
     inout [14:0]DDR_addr;
     inout [2:0]DDR_ba;
     inout DDR_cas_n;
     inout DDR_ck_n;
     inout DDR_ck_p;
     inout DDR_cke;
     inout DDR_cs_n;
     inout [3:0]DDR_dm;
     inout [31:0]DDR_dq;
     inout [3:0]DDR_dqs_n;
     inout [3:0]DDR_dqs_p;
     inout DDR_odt;
     inout DDR_ras_n;
     inout DDR_reset_n;
     inout DDR_we_n;
     inout FIXED_IO_ddr_vrn;
     inout FIXED_IO_ddr_vrp;
     inout [53:0]FIXED_IO_mio;
     inout FIXED_IO_ps_clk;
     inout FIXED_IO_ps_porb;
     inout FIXED_IO_ps_srstb;

     output    [15:0] LCD_DATA;
     output    LCD_VSYNC;
     output    LCD_HSYNC;
     output    LCD_DE;
     output    LCD_PCLK;
       
     output    I2S_SCLK;
     output    I2S_FSYNC_OUT;
     output    I2S_DOUT;
     input     I2S_FSYNC_IN;
     input     I2S_DIN;
       
     input     HDMI_INTn;
     input     MEMS_INTn;
 
     inout     I2C0_SDA;
     inout     I2C0_SCL;     
      
     input     [3:0] SW;
     output    BP;
     output    [2:0]  LEDS;

     input     [5:1] IO_B34_LP;
     input     [5:1] IO_B34_LN;
       
     input     [24:1] IO_B35_LP;
     output     [24:1] IO_B35_LN;
       
     input    IO_B34_LP6;
     input    IO_B34_LP8;
     input    IO_B34_LN8;     
     input    IO_B34_LP11;
     input    IO_B34_LN11;

    wire [63:0] gpio_0_tri_i;
    wire [63:0] gpio_0_tri_io;
    wire [63:0] gpio_0_tri_o;
    wire [63:0] gpio_0_tri_t;
        
    wire iic_0_scl_i;
    wire iic_0_scl_io =   I2C0_SCL;
    wire iic_0_scl_o;
    wire iic_0_scl_t;
    wire iic_0_sda_i;
    wire iic_0_sda_io =   I2C0_SDA;
    wire iic_0_sda_o;
    wire iic_0_sda_t;
    
    wire arm_io_led_r;
    wire arm_io_led_b;
    wire arm_io_led_g;
    wire arm_io_bp;
    
    assign  gpio_0_tri_i[59:56] =  SW[3:0];
    assign  gpio_0_tri_o[60] = arm_io_led_r;
    assign  gpio_0_tri_o[61] = arm_io_led_g;
    assign  gpio_0_tri_o[62] = arm_io_led_b;
    assign  gpio_0_tri_o[63] = arm_io_bp;
    
// user wire define code       
    wire PL_iCLK12M =   IO_B34_LP11; 
//    wire PS_iCLK50M;
//    wire PS_iRESETn;
//    wire clk;
 
//    wire ledr      =     LED1_reg && SW[0];
//    wire ledg      =     SW[1] ;
//    wire ledb      =     SW[2] ;
//end user wire define 

//user logic example
//    assign PS_iCLK50M = PL_iCLK12M;   
//    assign PS_iRESETn   =   ~SW[3];
         
//    assign LEDS[0]  =     PS_iRESETn   ?  ledr : arm_io_led_r;
//    assign LEDS[1]  =     PS_iRESETn   ?  ledg : arm_io_led_g;
//    assign LEDS[2]  =     PS_iRESETn   ?  ledb : arm_io_led_b;
//    assign BP       =     arm_io_bp;
  
//    reg LED1_reg; 
//    reg [20:0] COUNT_1MS;
//    reg [10:0] LED_BLINK_SPEED;
//    reg PL_CLK1K;
     
//     always @( posedge PS_iCLK50M or negedge PS_iRESETn )
//         begin
//         if ( PS_iRESETn == 1'b0) begin
 //            PL_CLK1K    =   1'b0;
 //        end
 //        else if(PS_iCLK50M == 1'b1 )
 //            if(COUNT_1MS == 21'd5999) begin
 //                COUNT_1MS = 21'd0;
 //                PL_CLK1K    =   ~PL_CLK1K;
 //                end
 //            else begin
 //                COUNT_1MS = COUNT_1MS + 21'd1;
 //            end
 //    end
         
 //    always @( posedge  PL_CLK1K or negedge PS_iRESETn )
 //       begin
 //        if ( PS_iRESETn == 1'b0) begin
 // 		    LED1_reg    =   1'b1;
 // 		    LED_BLINK_SPEED= 11'd0;
 // 	     end
 //        else if(PL_CLK1K == 1'b1 )
 // 			if(LED_BLINK_SPEED == 11'd499) begin
 // 				LED_BLINK_SPEED = 11'd0;
 // 				LED1_reg    =  ~LED1_reg;
 // 			end
  //               else begin
  //				LED_BLINK_SPEED = LED_BLINK_SPEED + 11'd1;                
  //               end
  //       end
         
         wire clock50k;
         reg[6:0] range;
         reg[24:0] range_counter;
         
        always @( posedge PL_iCLK12M)
        begin
        if(PL_iCLK12M == 1'b1) begin
             if(range_counter > 24'd12582912) begin
                 range_counter = 0;
             end
             else if(range_counter > 24'd6291456) begin
                range = 7'd35;
             end
             else begin
                range = 7'd135;
             end
            range_counter = range_counter + 24'd1;
         end
         end
         
         Clock50kHz clock50kHz(
                 .clockin50mHz(PL_iCLK12M),
                 .clockout(clock50k)
             );
         
         Servo servo(
                 .clkin(clock50k),
                 .rstn(1'b0),
                 .cntin(range),
                 .pwmout(IO_B35_LN[2])
         );

//end user logic

design_1 design_1_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .GPIO_0_tri_i(gpio_0_tri_i),
        .GPIO_0_tri_o(gpio_0_tri_o),
        .GPIO_0_tri_t(gpio_0_tri_t),
        .IIC_0_scl_i(iic_0_scl_i),
        .IIC_0_scl_o(iic_0_scl_o),
        .IIC_0_scl_t(iic_0_scl_t),
        .IIC_0_sda_i(iic_0_sda_i),
        .IIC_0_sda_o(iic_0_sda_o),
        .IIC_0_sda_t(iic_0_sda_t),
        .hdmi_clk(LCD_PCLK),
        .hdmi_data(LCD_DATA),
        .hdmi_de(LCD_DE),
        .hdmi_hsync(LCD_HSYNC),
        .hdmi_intn(HDMI_INTn),
        .mems_intn(MEMS_INTn),
        .temp_intn(MEMS_INTn),
        .hdmi_vsync(LCD_VSYNC));
IOBUF iic_0_scl_iobuf
       (.I(iic_0_scl_o),
        .IO(iic_0_scl_io),
        .O(iic_0_scl_i),
        .T(iic_0_scl_t));
IOBUF iic_0_sda_iobuf
       (.I(iic_0_sda_o),
        .IO(iic_0_sda_io),
        .O(iic_0_sda_i),
        .T(iic_0_sda_t));
endmodule
