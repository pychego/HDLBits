`timescale 1 ns / 1 ps

module system_wrapper_tb ();

    reg         ap_clk_0;
    wire        ap_done_0;
    wire        ap_idle_0;
    wire        ap_ready_0;
    reg         ap_rst_0;
    reg         ap_start_0;

    wire [31:0] realA_0;
    wire        realA_ap_vld_0;
    wire [31:0] realB_0;
    wire        realB_ap_vld_0;
    wire [31:0] realC_0;
    wire        realC_ap_vld_0;
    wire [31:0] realX_0;
    wire        realX_ap_vld_0;
    wire [31:0] realY_0;
    wire        realY_ap_vld_0;
    wire [31:0] realZ_0;
    wire        realZ_ap_vld_0;
    wire [31:0] target1_0;
    wire        target1_ap_vld_0;
    wire [31:0] target2_0;
    wire        target2_ap_vld_0;
    wire [31:0] target3_0;
    wire        target3_ap_vld_0;
    wire [31:0] target4_0;
    wire        target4_ap_vld_0;
    wire [31:0] target5_0;
    wire        target5_ap_vld_0;
    wire [31:0] target6_0;
    wire        target6_ap_vld_0;

    initial begin
        ap_clk_0 = 0;
        ap_rst_0 = 1;
        ap_start_0 = 0;
        #100;
        ap_rst_0 = 0;
        # 1890;
        ap_start_0 = 1;

    end

    always #5 ap_clk_0 = ~ap_clk_0;

    system system_i (
        .ap_clk_0        (ap_clk_0),
        .ap_done_0       (ap_done_0),
        .ap_idle_0       (ap_idle_0),
        .ap_ready_0      (ap_ready_0),
        .ap_rst_0        (ap_rst_0),
        .ap_start_0      (ap_start_0),
        .downLen1_0      (541028),
        .downLen2_0      (541633),
        .downLen3_0      (547477),
        .downLen4_0      (587832),
        .downLen5_0      (622644),
        .downLen6_0      (549194),
        .realA_0         (realA_0),
        .realA_ap_vld_0  (realA_ap_vld_0),
        .realB_0         (realB_0),
        .realB_ap_vld_0  (realB_ap_vld_0),
        .realC_0         (realC_0),
        .realC_ap_vld_0  (realC_ap_vld_0),
        .realX_0         (realX_0),
        .realX_ap_vld_0  (realX_ap_vld_0),
        .realY_0         (realY_0),
        .realY_ap_vld_0  (realY_ap_vld_0),
        .realZ_0         (realZ_0),
        .realZ_ap_vld_0  (realZ_ap_vld_0),
        .target1_0       (target1_0),
        .target1_ap_vld_0(target1_ap_vld_0),
        .target2_0       (target2_0),
        .target2_ap_vld_0(target2_ap_vld_0),
        .target3_0       (target3_0),
        .target3_ap_vld_0(target3_ap_vld_0),
        .target4_0       (target4_0),
        .target4_ap_vld_0(target4_ap_vld_0),
        .target5_0       (target5_0),
        .target5_ap_vld_0(target5_ap_vld_0),
        .target6_0       (target6_0),
        .target6_ap_vld_0(target6_ap_vld_0),
        .upLen1_0        (299174),
        .upLen2_0        (387245),
        .upLen3_0        (387654),
        .upLen4_0        (305619),
        .upLen5_0        (306836),
        .upLen6_0        (327377)
    );
endmodule
