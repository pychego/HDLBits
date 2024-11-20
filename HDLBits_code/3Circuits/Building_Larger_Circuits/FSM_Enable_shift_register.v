module top_module (
    input      clk,
    input      reset,
    output reg shift_ena
);

    // 这个题还是需要想一想状态是怎么分配的
    // S0是最初始reset一直为0的状态, S1是检测到了reset=1, S2是确定了reset上一个clk为1, 下一个clk为0
    // 状态越多, 写起来越简单
    parameter S0 = 0, S1 = 1, S2 = 2;
    reg [1:0] state, next;

    reg [15:0] count;

    always @(*) begin
        case (state)
            S0: next = reset ? S1 : S0;
            S1: next = reset ? S1 : S2;
            S2: next = (count == 3) ? S0 : S2;
            default: ;
        endcase
    end

    // 怎么设置初始状态? 这个有点奇特
    always @(posedge clk) begin
        state <= reset ? S1 : next;
    end

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1;
            count <= 0;
        end else begin
            case (next)
                S0: begin
                    shift_ena <= 0;
                    count <= 0;
                end
                S1: begin
                    shift_ena <= 1;
                    count <= 0;
                end
                S2: begin
                    shift_ena <= 1;
                    count <= count + 1;
                end
                default: ;
            endcase
        end
    end

endmodule
