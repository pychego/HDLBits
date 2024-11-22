// 这道题history shift register理解起来用了很长时间
module top_module (
    input clk,
    input areset,

    input             predict_valid,
    input             predict_taken,
    output reg [31:0] predict_history,

    input        train_mispredicted,
    input        train_taken,
    input [31:0] train_history
);

    // 题目如果理解了, 写起来是很简单的, 一次就success了
    // S0 初始状态, S1 正常预测没有错误的状态, S2 出错的状态
    parameter S0 = 0, S1 = 1, S2 = 2;
    reg [1:0] state, next;

    always @(*) begin
        case (state)
            S0: next = train_mispredicted ? S2 : (predict_valid ? S1 : S0);
            S1: next = train_mispredicted ? S2 : S1;
            S2: next = train_mispredicted ? S2 : S1;
            default: ;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        state <= areset ? S0 : next;
    end

    always @(posedge clk, posedge areset) begin
        if (areset) predict_history <= 0;
        else begin
            case (next)
                S0: predict_history <= 0;
                S1:
                predict_history <= predict_valid ? {predict_history[30:0], predict_taken} : predict_history;
                S2: predict_history <= {train_history[30:0], train_taken};
                default: ;
            endcase
        end
    end



endmodule
