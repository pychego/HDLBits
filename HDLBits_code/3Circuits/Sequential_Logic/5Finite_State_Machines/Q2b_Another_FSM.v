module top_module (
    input      clk,
    input      resetn,
    input      x,
    input      y,
    output reg f,
    output reg g
);

    // 有点麻烦, 理解题意花了挺长时间
    // A 初始态, B 输出f=1的状态, 注意B状态后面的一个状态才开始检测101(定义这个状态为C0), 并不是直接在B状态
    // 的clk直接检测101
    // C1 已经读取1, C2 已经读取10, C3已经读取101, C3状态要保存两个周期
    // 在C3状态下如果检测出至少一个高电平输入y, 则后面跳转状态E, 否则跳转状态F
    parameter A = 0, B = 1, C0 = 8, C1 = 2, C2 = 3, C3 = 4, E = 6, F = 7;
    reg [3:0] state, next;

    reg [15:0] count;
    reg [ 1:0] y_data;

    always @(*) begin
        case (state)
            A: next = resetn ? B : A;
            B: next = C0;
            C0: next = x ? C1 : C0;
            C1: next = x ? C1 : C2;
            C2: next = x ? C3 : C0;
            // 因为count是在case(state)下产生的, 因此该判断条件已经是在C3的第二个周期了
            C3: next = (count == 1) ? ((y_data[0] || y) ? E : F) : C3;
            E: next = E;
            F: next = F;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state = (~resetn) ? A : next;
    end

    always @(posedge clk) begin
        if (~resetn) begin
            f <= 0;
            g <= 0;
        end else
            case (next)
                A, C0, C1, C2: begin
                    f <= 0;
                    g <= 0;
                end
                B: begin
                    f <= 1;
                    g <= 0;
                end
                C3, E: begin
                    f <= 0;
                    g <= 1;
                end
                F: begin
                    f <= 0;
                    g <= 0;
                end
                default: ;
            endcase
    end

    always @(posedge clk) begin
        if (~resetn) begin
            count <= 0;
        end else
            case (state)
                A, C0, C1, C2, B, E, F: begin
                    count <= 0;
                end
                C3: begin
                    count <= count + 1;
                    y_data[count] <= y;
                end
                default: ;
            endcase
    end

endmodule
