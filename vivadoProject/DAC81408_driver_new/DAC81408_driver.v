module DAC81408_driver (
    input        clk,
    input        rst_n,
    input        start_init_dac,
    input        start,
    input [15:0] control_output4,
    input [15:0] control_output5,
    input [15:0] control_output6,
    input [15:0] control_output7,
    input [15:0] control_output8,
    input [15:0] control_output9,
    input [15:0] control_output10,
    input [15:0] control_output11,

    output DAC_CSn,
    output DAC_SCLK,
    output DAC_SDI,
    output LDACn
);

    wire [23:0] dac_cmd;
    wire        dac_cmd_valid;

    DAC81408_cmd_gen u_DAC81408_cmd_gen (
        .clk            (clk),
        .rst_n          (rst_n),
        .start_init_dac (start_init_dac),
        .start          (start),
        .control_output4(control_output4),
        .control_output5(control_output5),
        .control_output6(control_output6),
        .control_output7(control_output7),
        .control_output8(control_output8),
        .control_output9(control_output9),
        .control_output10(control_output10),
        .control_output11(control_output11),
        .dac_cmd        (dac_cmd),          // output
        .dac_cmd_valid  (dac_cmd_valid),
        .LDACn          (LDACn)
    );

    DAC81408_spi u_DAC81408_spi (
        .clk          (clk),
        .rst_n        (rst_n),
        .dac_cmd      (dac_cmd),
        .dac_cmd_valid(dac_cmd_valid),
        .DAC_CSn      (DAC_CSn),
        .DAC_SCLK     (DAC_SCLK),
        .DAC_SDI      (DAC_SDI)
    );

endmodule
