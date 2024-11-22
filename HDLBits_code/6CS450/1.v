module top_module (
    input            clk,
    input            load,
    input      [9:0] data,
    output reg       tc
);

    // 这个题目还是有点麻烦的, 主要是load可以在计数过程中清零计数
    // S0为初始状态, S2为已经检测到了load,开始计数了
    // S3是已经计数完成,输出tc, 等待load
    // 这里我考虑了如果load高电平时,如果输入data=0的话,就直接进入S3状态了
    parameter S0 = 0, S2 = 2, S3 = 3;
    reg [1:0] state, next;
    reg [9:0] data_reg;
    reg [9:0] count;

    always @(*) begin
        case (state)
            S0: next = load ? (data ? S2 : S3) : S0;
            S2: next = load ? (data ? S2 : S3) : ((count == data_reg) ? S3 : S2);
            S3: next = load ? (data ? S2 : S3) : S3;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= load ? (data ? S2 : S3) : next;
    end

    always @(posedge clk) begin
        if (load) data_reg <= data;
        else data_reg <= data_reg;
    end

    always @(posedge clk) begin
        case (next)
            S0: begin
                count <= 0;
                tc <= 0;
            end
            S2: begin
                // 这里需要有load的判断条件, 如果load,则要将count清除,从1开始
                if (load) count <= 1;
                else begin
                    if (count < data_reg) count <= count + 1;
                    else count <= 0;
                end
                tc <= 0;
            end
            S3: begin
                count <= 0;
                tc <= 1;
            end
            default: ;
        endcase
    end


endmodule
