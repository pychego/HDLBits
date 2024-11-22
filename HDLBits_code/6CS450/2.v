module top_module (
    input            clk,
    input            areset,
    input            train_valid,
    input            train_taken,
    output reg [1:0] state
);

    // 只需要输出state, 没有输出变量z  饱和计数器
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    reg [1:0] next;

    always @(*) begin
        case (state)
            S0: next = train_valid ? (train_taken ? S1 : S0) : S0;
            S1: next = train_valid ? (train_taken ? S2 : S0) : S1;
            S2: next = train_valid ? (train_taken ? S3 : S1) : S2;
            S3: next = train_valid ? (train_taken ? S3 : S2) : S3;
            default: ;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        state <= areset ? S1 : next;
    end


endmodule
