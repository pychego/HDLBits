module shift_led_top #(
    parameter DATA_WIDTH = 4
) (
    input                       i_clk,
    input                       i_rst_n,
    output reg [DATA_WIDTH-1:0] led
);

    reg  [           1:0] cnt;
    reg  [DATA_WIDTH-1:0] led_i_V;
    wire                  ap_start;
    wire                  led_i_vld;
    wire [DATA_WIDTH-1:0] led_o_V;
    wire                  led_o_vld;

    always @(posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            cnt <= 2'b00;
        end else begin
            if (cnt[1] == 1'b0) begin
                cnt <= cnt + 1;
            end
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) begin
            led_i_V <= 4'b0;
        end else if (cnt[0] == 1'b1) begin
            led_i_V <= 4'h1;
        end else if (led_o_vld == 1'b1) begin
            led_i_V <= led_o_V;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (i_rst_n == 1'b0) led <= 1'b0;
        else if (led_o_vld == 1'b1) led <= led_o_V;
    end

    assign ap_start  = cnt[1];
    assign led_i_vld = cnt[1];

    // 问题：这里的 led_o_vld 信号一直为低电平
    shift_led_0 u_shift_led_0 (
        .led_o_V_ap_vld(led_o_vld),  // output wire led_o_vld
        .led_i_V_ap_vld(led_i_vld),  // input wire led_i_vld
        .ap_clk        (i_clk),      // input wire ap_clk
        .ap_rst        (~i_rst_n),   // input wire ap_rst
        .ap_start      (ap_start),   // input wire ap_start
        .ap_done       (),           // output wire ap_done
        .ap_idle       (),           // output wire ap_idle
        .ap_ready      (),           // output wire ap_ready
        .led_o_V       (led_o_V),    // output wire [3 : 0] led_o_V
        .led_i_V       (led_i_V)     // input wire [3 : 0] led_i_V
    );

endmodule
