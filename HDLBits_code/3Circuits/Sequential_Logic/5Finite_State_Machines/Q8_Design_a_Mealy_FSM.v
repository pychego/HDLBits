module top_module (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // 需要先画出状态转换图
    // incorrect之后看波形图, 发展在10之后,再出现1,立刻z=1, 不需要等时序了
    // Mealy状态机的输出与当前状态和输入都有关系
    parameter S0 = 0, S1 = 1, S2 = 2;
    reg [1:0] state, next;

    always @(*) begin
        case (state)
            S0: next = x ? S1 : S0;
            S1: next = x ? S1 : S2;
            S2: next = x ? S1 : S0;
            default: ;
        endcase
    end

    always @(posedge clk, negedge aresetn) begin
        if (~aresetn) state <= S0;
        else state <= next;
    end

    assign z = (state == S2) && x && aresetn;

endmodule