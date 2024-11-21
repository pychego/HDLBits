module top_module (
    input            clk,
    input            reset,
    input            data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input            ack
);

    // 一次成功, 明天写一下注释, 基本框架就是在上一个程序上面修改
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, SHIFT = 5, COUNTING = 6, DONE = 7;
    reg [2:0] state, next;

    // FSM和计数器结合, 指定在某个state的周期数, 这个值得学习

    // 这个是SHIFT状态的计数器
    reg [15:0] countSHIFT;

    reg [ 3:0] delay;  // 与作者相同的变量

    // 记录1000个clk
    reg [15:0] counter;
    always @(posedge clk) begin
        if (reset) counter <= 0;
        else if (state == COUNTING && counter < 999) counter <= counter + 1;
        else counter <= 0;
    end

    // 状态转移
    always @(*) begin
        case (state)
            S0: next = data ? S1 : S0;
            S1: next = data ? S2 : S0;
            S2: next = data ? S2 : S3;
            S3: next = data ? SHIFT : S0;
            SHIFT: next = (countSHIFT == 4) ? COUNTING : SHIFT;
            COUNTING: next = (count == 0 && counter == 999) ? DONE : COUNTING;
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
            counting <= 0;
            done <= 0;
            countSHIFT <= 0;
        end else begin
            case (next)
                S0, S1, S2, S3: begin
                    counting <= 0;
                    done <= 0;
                    countSHIFT <= 0;
                end
                SHIFT: begin
                    counting <= 0;
                    done <= 0;
                    countSHIFT <= countSHIFT + 1;
                end
                COUNTING: begin
                    counting <= 1;
                    done <= 0;
                    countSHIFT <= 0;
                end
                DONE: begin
                    counting <= 0;
                    done <= 1;
                    countSHIFT <= 0;
                end
                default: ;
            endcase
        end
    end

    always @(posedge clk) begin
        if (reset) delay <= 0;
        else if (state == SHIFT) delay <= {delay[2:0], data};
        else delay <= delay;
    end

    // 大的计数器里面套小的计数器, 主要就是把握好转换条件即可
    always @(posedge clk) begin
        if (reset) count <= 0;
        else if (state == SHIFT && next == COUNTING) count <= {delay[2:0], data};
        else if (state == COUNTING && counter == 999) begin
            if (count > 0) count <= count - 1;
            else count <= count;
        end else count <= count;

    end

endmodule
