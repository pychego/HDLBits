module top_module (
    input clk,
    input areset,

    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    input       train_valid,
    input       train_taken,
    input       train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // PHT 这个数组怎么来  看不懂题目,暂时放弃吧

endmodule
