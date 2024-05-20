module Four_DAC81416_driver (
    input         clk,
    input         rst_n,
    input         start_init_dac,
    input         start,
    input  [15:0] control_output0,
    input  [15:0] control_output1,
    input  [15:0] control_output2,
    input  [15:0] control_output3,
    
    output        DAC_CSn,
    output        DAC_SCLK,
    output        DAC_SDI,
    output        LDACn
);

    wire [23:0] dac_cmd;

    Four_DAC81416_cmd_gen u_DAC81416_cmd_gen (
        .clk            (clk),
        .rst_n          (rst_n),
        .start_init_dac (start_init_dac),
        .start          (start),
        .control_output0(control_output0),
        .control_output1(control_output1),
        .control_output2(control_output2),
        .control_output3(control_output3),
        .dac_cmd        (dac_cmd),            // output 
        .dac_cmd_valid  (dac_cmd_valid),
        .LDACn          (LDACn)
    );

    // LDACn 不需要这个模块处理, 直接在上面输出就行
    Four_DAC81416_spi u_DAC81416_spi (
        .clk          (clk),
        .rst_n        (rst_n),
        .dac_cmd      (dac_cmd),
        .dac_cmd_valid(dac_cmd_valid),
        .DAC_CSn      (DAC_CSn),
        .DAC_SCLK     (DAC_SCLK),
        .DAC_SDI      (DAC_SDI)
    );

endmodule
