/*
    奇数分频: 保证50%占空比, 以5分频为例
    counter: 0, 1, 2, 3, 4
    设计clk1, 低3个counter, 高2个counter,在clk上升沿响应
    设计clk2, 低三个counter, 高2个counter, 在clk下降沿响应
    clk1 和 clk2 相差半个clk周期
    clk_out = clk1 | clk2;
*/




module five_channel_division (
    input clk,
    input rst_n,

    output clk_out
);

    reg clk1, clk2;

    reg [2:0] counter, next;

    always @(*) begin
        case (counter)
            0, 1, 2, 3: next = counter + 1;
            4: next = 0;
            default: next = 0;
        endcase
    end

    always @(posedge clk, negedge rst_n) begin
        counter <= (~rst_n) ? 0 : next;
    end

    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) clk1 <= 0;
        else begin
            case (next)
                0, 1, 2: clk1 <= 0;
                3, 4: clk1 <= 1;
                default: ;
            endcase
        end
    end

    always @(negedge clk, negedge rst_n) begin
        if (~rst_n) clk2 <= 0;
        else begin
            case (counter)
                0, 1, 2: clk2 <= 0;
                3, 4: clk2 <= 1;
                default: ;
            endcase
        end
    end

    assign clk_out = clk1 | clk2;







endmodule
