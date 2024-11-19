module top_module (
    input         clk,
    input  [ 7:0] in,
    input         reset,
    output [23:0] out_bytes,
    output        done
);


    // 设置一个中间变量保存要输出的内容
    reg [23:0] out_bytes_reg;
    reg [23:16] next_first_byte;    // 用于存放S3时的下一个周期的第一字节
    // 画出状态转换图就好了, 这个关键是S1_FROM0和S1_FROM3的区分,比较关键
    parameter S0 = 0, S1_FROM0 = 1, S1_FROM3 = 2, S2 = 3, S3 = 4;
    reg [2:0] state, next;

    // 像这种在组合逻辑中写了好几个阻塞赋值的, 总感觉会有问题
    // 这种多个阻塞赋值语句, 在仿真中是串行执行的, 实现时,综合工具会将他们并行执行,得到正确结果(与仿真结果一致)
    always @(*) begin
        case (state)
            S0: begin
                next = (in[3] == 1) ? S1_FROM0 : S0;
                out_bytes_reg[23:16] = in;
            end
            S1_FROM0: begin
                next = S2;
                out_bytes_reg[15:8] = in;
            end
            S1_FROM3: begin
                next = S2;
                out_bytes_reg[23:16] = next_first_byte;
                out_bytes_reg[15:8] = in;
            end
            S2: begin
                next = S3;
                out_bytes_reg[7:0] = in;
            end
            S3: begin
                next = (in[3] == 1) ? S1_FROM3 : S0;
                next_first_byte = (in[3] == 1) ? in : next_first_byte;
            end
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= reset ? S0 : next;
    end

    assign done = (state == S3);
    assign out_bytes = (state == S3) ? out_bytes_reg : out_bytes;



endmodule
