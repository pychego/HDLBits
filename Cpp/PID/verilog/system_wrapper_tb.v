`timescale 1 ns / 1 ps

/* 仅添加了单独的PID模块, 为了测试PID是不是每个控制周期只运行一次, 如果不是, 需要修改程序
   让PID每周期只运行一次
*/
module system_wrapper_tb ();

    reg         ap_clk_0;
    wire        ap_done_0;
    wire        ap_idle_0;
    wire        ap_ready_0;
    reg         ap_rst_0;
    wire         ap_start_0;
    wire [15:0] control_output_0;
    wire        control_output_ap_vld_0;
    reg  [31:0] data_real_0;
    reg  [31:0] data_target_0;
    reg  [31:0] kd_0;
    reg  [31:0] ki_0;
    reg  [31:0] kp_0;
    reg         zero_output_0;

    initial begin
        kp_0 = 1500;
        ki_0 = 1200;
        kd_0 = 1000;
        data_target_0 = 200000;
        data_real_0 = 180000;
        zero_output_0 = 0;
    end

    initial begin
        ap_clk_0   = 0;
        ap_rst_0   = 1;
        #15;
        ap_rst_0 = 0;
    end

    // 设置时钟周期10ns
    always #5 ap_clk_0 = ~ap_clk_0;

    // 计时100ns
    reg [14:0] count;
    always @(posedge ap_clk_0 or posedge ap_rst_0) begin
        if(ap_rst_0) begin
            count <= 0;
        end else if(count >= 9999)
            count <= 0;
        else
            count <= count + 1;
    end

    assign ap_start_0 = (count == 9999);

    system system_i (
        .ap_clk_0               (ap_clk_0),
        .ap_done_0              (ap_done_0),
        .ap_idle_0              (ap_idle_0),
        .ap_ready_0             (ap_ready_0),
        .ap_rst_0               (ap_rst_0),
        .ap_start_0             (ap_start_0),
        .control_output_0       (control_output_0),
        .control_output_ap_vld_0(control_output_ap_vld_0),
        .data_real_0            (data_real_0),
        .data_target_0          (data_target_0),
        .kd_0                   (kd_0),
        .ki_0                   (ki_0),
        .kp_0                   (kp_0),
        .zero_output_0          (zero_output_0)
    );
endmodule

/*  本程序和test_PID这个vivado项目相匹配, 验证了当参数到位之后, 每个控制周期给一个ap_start的上升沿即可
    输出控制量, 且static修饰的变量只会初始化一次, 之后不会再初始化,ap_start的高低不影响他们初始化
\*/