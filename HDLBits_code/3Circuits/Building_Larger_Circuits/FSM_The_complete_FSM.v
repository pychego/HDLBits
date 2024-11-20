module top_module (
    input      clk,
    input      reset,
    input      data,
    output reg shift_ena,
    output reg counting,
    input      done_counting,
    output reg done,
    input      ack
);

    // 这里面关键就是状态的安排, 自己画一下状态转换图, 注意S3为匹配到了110, 如果再来一个1就直接进入SHIFT
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, SHIFT = 5, COUNTING = 6, DONE = 7;
    reg [2:0] state, next;

    // FSM和计数器结合, 指定在某个state的周期数, 这个值得学习
    reg [15:0] count;

    // 状态转移
    always @(*) begin
        case (state)
            S0: next = data ? S1 : S0;
            S1: next = data ? S2 : S0;
            S2: next = data ? S2 : S3;
            S3: next = data ? SHIFT : S0;
            SHIFT: next = (count == 4) ? COUNTING : SHIFT;
            COUNTING: next = done_counting ? DONE : COUNTING;
            DONE: next = ack ? S0 : DONE;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= reset ? S0 : next;
    end

    // 操作输出和count
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            count <= 0;
        end else begin
            case (next)
                S0, S1, S2, S3: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    count <= 0;
                end
                SHIFT: begin
                    shift_ena <= 1;
                    counting <= 0;
                    done <= 0;
                    count <= count + 1;
                end
                COUNTING: begin
                    shift_ena <= 0;
                    counting <= 1;
                    done <= 0;
                    count <= 0;
                end
                DONE: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 1;
                    count <= 0;
                end
                default: ;
            endcase
        end
    end




endmodule
