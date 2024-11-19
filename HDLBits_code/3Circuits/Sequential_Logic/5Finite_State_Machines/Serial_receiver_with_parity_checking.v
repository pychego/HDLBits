module top_module (
    input            clk,
    input            in,
    input            reset,
    output reg [7:0] out_byte,
    output reg       done
);

    // 错误......
    // 这个题目和上面的题目用的思路方法一样,但是就是不成功, 而且最简单的第一次测试也没有通过
    // 不知道为啥,好像没有进入STOP状态......

    // 已经修改正确了.......
    // 错误的原因, 当时以为如果奇检验不通过的话就不能进入stop状态. 这样就必须有wait和idle
    // 但是如果奇检验不通过也进入stop状态,就可能不进入wait状态和idle状态, 直接进入start
    parameter IDLE = 0, START = 1, S1_9 = 2, STOP = 3, WAIT = 4;
    reg [2:0] state, next;
    reg  [15:0] count;
    reg  [ 8:0] out_byte_parity;
    wire        odd;

    always @(*) begin
        case (state)
            IDLE: next = in ? IDLE : START;
            START: next = S1_9;
            S1_9: begin
                if (count == 9) begin
                    if (in) next = STOP;
                    else next = WAIT;
                end else next = S1_9;
            end
            STOP: next = in ? IDLE : START;
            WAIT: next = in ? IDLE : WAIT;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= reset ? IDLE : next;
    end

    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
            out_byte <= 0;
            count <= 0;
        end else begin
            case (next)
                IDLE: begin
                    done <= 0;
                    out_byte <= 0;
                    count <= 0;
                end
                START: begin
                    done <= 0;
                    out_byte <= 0;
                    count <= 0;
                end
                S1_9: begin
                    done <= 0;
                    out_byte_parity[count] = in;
                    count <= count + 1;
                end
                STOP: begin
                    if (^out_byte_parity) begin
                        done <= 1;
                        out_byte <= out_byte_parity[7:0];
                    end else begin
                        done <= 0;
                        out_byte <= 0;
                    end
                    count <= 0;
                end
                WAIT: begin
                    done <= 0;
                    out_byte <= 0;
                    count <= 0;
                end
                default: ;
            endcase
        end
    end


endmodule
