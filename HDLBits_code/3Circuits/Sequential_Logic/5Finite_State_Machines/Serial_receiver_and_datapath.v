// 先发送低位bit
// 方法1
module top_module (
    input        clk,
    input        in,
    input        reset,
    output       done,
    output [7:0] out_byte  // 非逻辑信号要注意位宽
);

    // 这个方法没有使用边沿检测, 感觉很顺利; 就是所有的状态都有一个周期的延后
    // 状态越多, 写起来越简单
    parameter IDLE = 0, START = 1, S1_8 = 2, STOP = 3, WAIT = 4;
    reg [3:0] state, next;

    reg [15:0] count;
    always @(posedge clk) begin
        if (reset) count <= 0;
        else begin
            // 该判断条件会持续9个周期
            if (state == START || state == S1_8) count <= count + 1;
            else count <= 0;
        end
    end

    reg [8:0] out_byte_reg;
    always @(posedge clk) begin
        if (reset) out_byte_reg <= 0;
        else begin
            if (state == START || state == S1_8) out_byte_reg <= {in, out_byte_reg[8:1]};
            else out_byte_reg <= out_byte_reg;
        end
    end


    always @(*) begin
        case (state)
            IDLE: next = in ? IDLE : START;
            START: next = S1_8;
            S1_8: next = (count == 8) ? (in ? STOP : WAIT) : S1_8;
            STOP: next = in ? IDLE : START;
            WAIT: next = in ? IDLE : WAIT;
            default: ;
        endcase
    end


    always @(posedge clk) begin
        state = reset ? IDLE : next;
    end

    assign done = (state == STOP);
    assign out_byte = out_byte_reg[7:0];


endmodule


//方法2, 这种方法更巧妙,通过计数器和FSM结合, 比方法1容易理解很多
module top_module (
    input            clk,
    input            in,
    input            reset,
    output reg       done,
    output reg [7:0] out_byte  // 非逻辑信号要注意位宽
);

    // 这个方法没有使用边沿检测, 感觉很顺利; 就是所有的状态都有一个周期的延后
    // 状态越多, 写起来越简单
    parameter IDLE = 0, START = 1, S1_8 = 2, STOP = 3, WAIT = 4;
    reg [3:0] state, next;

    reg [15:0] count;
    // 注意位宽与方法1不同
    reg [ 7:0] out_byte_reg;


    always @(*) begin
        case (state)
            IDLE: next = in ? IDLE : START;
            START: next = S1_8;
            S1_8: next = (count == 8) ? (in ? STOP : WAIT) : S1_8;
            STOP: next = in ? IDLE : START;
            WAIT: next = in ? IDLE : WAIT;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            done <= 0;
            count <= 0;
            out_byte <= 0;
        end else begin
            case (next) // 注意, 这里直接拿next来判断了,因此取值in没有延迟一个周期
                IDLE: begin
                    done <= 0;
                    count <= 0;
                    out_byte <= 0;
                end
                START: begin
                    done <= 0;
                    count <= 0;
                    out_byte <= 0;
                end
                S1_8: begin
                    done <= 0;
                    count <= count + 1;
                    out_byte_reg[count] <= in;
                end
                STOP: begin
                    done <= 1;
                    count <= 0;
                    out_byte <= out_byte_reg;
                end
                WAIT: begin
                    done <= 0;
                    count <= 0;
                    out_byte <= 0;
                end
                default: ;
            endcase
        end
    end

    always @(posedge clk) begin
        state = reset ? IDLE : next;
    end

endmodule
