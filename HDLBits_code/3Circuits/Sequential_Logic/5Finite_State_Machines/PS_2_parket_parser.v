module top_module(
    input clk,
    input [7:0] in,
    input reset,
    output done
);

    // 感觉没有思路, 但是一想到FSM就能写了
    // S0 复位(未匹配到开头) S1 已匹配到开头1byte
    // S2 已匹配到开头2byte  S3 已匹配到开头3byte
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    reg [2:0] state, next;

    always @(*) begin
        case (state)
            S0: next = (in[3]==1) ? S1 : S0;
            S0: next = S1;
            S1: next = S2;
            S2: next = S3;
            S3: next = (in[3]==1) ? S1 : S0;
            default: ;
        endcase
    end    

    always @(posedge clk ) begin
        state <= reset ? S0 : next;
    end

    assign done = (state==S3);

endmodule