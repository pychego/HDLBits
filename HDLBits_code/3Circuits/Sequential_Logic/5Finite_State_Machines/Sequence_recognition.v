module top_module (
    input      clk,
    input      reset,
    input      in,
    output reg disc,
    output reg flag,
    output reg err
);

    // 关键是要设计出S5_0和S6_0, 注意不需要S7_0, 当S7状态下输入0后,在clk上升沿err就变0了
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;
    parameter S5_0 = 8, S6_0 = 9;
    reg [3:0] state, next;

    always @(*) begin
        case (state)
            S5_0, S6_0, S0: next = in ? S1 : S0;
            S1: next = in ? S2 : S0;
            S2: next = in ? S3 : S0;
            S3: next = in ? S4 : S0;
            S4: next = in ? S5 : S0;
            S5: next = in ? S6 : S5_0;
            S6: next = in ? S7 : S6_0;
            S7: next = in ? S7 : S0;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= reset ? S0 : next;
    end

    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err  <= 0;
        end else
            case (next)
                S0, S1, S2, S3, S4, S5, S6: begin
                    disc <= 0;
                    flag <= 0;
                    err  <= 0;
                end
                S5_0: begin
                    disc <= 1;
                    flag <= 0;
                    err  <= 0;
                end
                S6_0: begin
                    disc <= 0;
                    flag <= 1;
                    err  <= 0;
                end
                S7: begin
                    disc <= 0;
                    flag <= 0;
                    err  <= 1;
                end
                default: ;
            endcase
    end





endmodule
