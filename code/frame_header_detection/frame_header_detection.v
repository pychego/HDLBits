module frame_header_detection (
    input       clk,
    input       rst_n,
    input       frame_head,
    input [7:0] din,

    output reg detect
);

    reg [3:0] state, next;
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

    /* 状态转换逻辑
        由于detect只输出一个clk周期, 因此S3状态只能持续一个clk周期
        目前从仿真结果看是没有什么问题
    */
    always @(*) begin
        case (state)
            S0: next = frame_head ? (din == 8'h23 ? S1 : S0) : S0;
            S1: next = frame_head ? (din == 8'h23 ? S2 : S0) : S1;
            S2: next = frame_head ? (din == 8'h23 ? S3 : S0) : S2;
            S3: next = frame_head ? (din == 8'h23 ? S1 : S0) : S0;
            default: ;
        endcase
    end

    always @(posedge clk, negedge rst_n) begin
        state <= (~rst_n) ? S0 : next;
    end

    always @(posedge clk, negedge rst_n) begin
        detect <= (~rst_n) ? 1'b0 : (state == S3);
    end

endmodule
