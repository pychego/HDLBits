`timescale 1ns / 1ps

module Four_DAC81416_driver_tb ();

    reg         clk;
    reg         rst_n;
    reg         start_init_dac;
    reg         start;
    wire [15:0] control_output0;
    wire DAC_CSn, DAC_SCLK, DAC_SDI;

    wire        rom_clk;
    wire        rom_en;
    wire [31:0] rom_addr;
    wire [31:0] loc_data_set;
    wire [31:0] loc_data;
    reg [9:0] param_kp = 10, param_ki = 0, param_kd = 0;
    wire LDACn;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        start_init_dac = 1'b0;
        start = 1'b0;
        #15 rst_n = 1'b1;
        #2000000 start_init_dac = 1'b1;
        #2000000 start = 1'b1;
    end

    always #5 clk = ~clk;

    my_ROM_controller u_my_ROM_controller (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (start),
        .rom_en  (rom_en),
        .rom_addr(rom_addr),
        .rom_clk (rom_clk)
    );


    blk_mem_gen_0 u_blk_mem_gen_0 (
        .clka (rom_clk),      // rom_clk频率10kHz
        .ena  (rom_en),       // input wire ena
        .addra(rom_addr),     // input wire [9 : 0] addra
        .douta(loc_data_set)  // output wire [31 : 0] douta
    );


    assign loc_data = 140000;


    pid_ctrl u_pid_ctrl (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (start),
        .param_kp      (param_kp),
        .param_ki      (param_ki),
        .param_kd      (param_kd),
        .loc_data_set  (loc_data_set),
        .loc_data      (loc_data),
        .control_output(control_output0)
    );

    Four_DAC81416_driver u_DAC81416_driver (
        .clk            (clk),
        .rst_n          (rst_n),
        .start_init_dac (start_init_dac),
        .start          (start),
        .control_output0(control_output0),
        .control_output1(control_output0),
        .control_output2(control_output0),
        .control_output3(control_output0),
        .DAC_CSn        (DAC_CSn),
        .DAC_SCLK       (DAC_SCLK),
        .DAC_SDI        (DAC_SDI),
        .LDACn          (LDACn)
    );

    initial begin
        #3000000 $finish;
    end

endmodule
