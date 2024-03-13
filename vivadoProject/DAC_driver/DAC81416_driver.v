module DAC81416_driver (
    input         clk,
    input         rst_n,
    input         start_init_dac,
    input         start,
    input  [15:0] control_output,
    output        DAC_CSn,
    output        DAC_SCLK,
    output        DAC_SDI
);

    wire [23:0] dac_cmd;

    DAC81416_cmd_gen u_DAC81416_cmd_gen (
        .clk           (clk),
        .rst_n         (rst_n),
        .start_init_dac(start_init_dac),
        .start         (start),
        .control_output(control_output),
        .dac_cmd       (dac_cmd),
        .dac_cmd_valid (dac_cmd_valid)
    );

    DAC81416_spi u_DAC81416_spi (
        .clk          (clk),
        .rst_n        (rst_n),
        .dac_cmd      (dac_cmd),
        .dac_cmd_valid(dac_cmd_valid),
        .DAC_CSn      (DAC_CSn),
        .DAC_SCLK     (DAC_SCLK),
        .DAC_SDI      (DAC_SDI)
    );

endmodule
