/* 状态机实现按键消抖，消抖时间20ms
    0：空闲 idle 来下降沿之后进入按下消抖（1）
    1：按下消抖 p_filter 20ms内没有上升沿就进入等待释放（3），否则保持原态
    2：等待释放 wait_release 来上升沿之后进入释放消抖（3）
    3：释放消抖 r_filter 20ms内没有下降沿就进入空闲（0），否则保持原态
*/

module shake_suppression (
    input      clk,
    input      reset_n,      // 按键消抖适合有复位键吗
    input      key_value,
    // output reg p_flag,       // 按下标志
    // output reg r_flag,       // 释放标志
    output  key_flag,      // 按键状态改变的标志信号
    output     filter_value
);

    // 两个寄存器判断上升沿和下降沿
    reg [1:0] key_value_reg;
    always @(posedge clk) begin
        // key_value_reg[0] <= key_value;
        // key_value_reg[1] <= key_value_reg[0];
        key_value_reg <= {key_value_reg[0], key_value};
    end

    // 上升沿和下降沿判断 脉冲信号
    wire pedge, nedge;
    assign pedge = key_value_reg == 2'b01;
    assign nedge = key_value_reg == 2'b10;

    reg p_flag, r_flag;     // 按下标志和释放标志   
    assign key_flag = p_flag | r_flag;  // 按键状态改变的标志信号

    // 定义状态机
    reg [ 1:0] state;
    // 在20ms内再次判断是否有沿发生
    reg [31:0] count;
    reg        flag;  // 标志信号判断是否记时达到20ms
    parameter MCNT = 1_000_000;  // 20ms周期数

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 0;
            flag  <= 0;
        end else if (MCNT - 1 <= count) begin
            count <= 0;
            flag  <= 1;
        end else begin
            count <= count + 1;
            flag  <= 0;
        end
    end


    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state  <= 0;
            p_flag <= 0;
            r_flag <= 0;
        end else begin
            case (state)
                0: begin  // 此状态下count和flag没有用 不用管
                    r_flag <= 0;
                    if (nedge) begin  // nedge相对于clk下降沿有一个时延
                        state <= 1;
                        count <= 0;
                        flag  <= 0;
                    end
                end
                1: begin
                    if (!flag) begin  // 在20ms之内
                        if (pedge) begin
                            state <= 0;
                        end
                    end else begin
                        state  <= 2;
                        p_flag <= 1;  // 按下标志 脉冲信号
                    end
                end
                2: begin
                    p_flag <= 0;
                    if (pedge) begin
                        state <= 3;
                        count <= 0;
                        flag  <= 0;
                    end
                end
                3: begin
                    // 使用flag判断应该会比使用count判断产生一个延时
                    // 但是不能直接使用count <= MCNT-1判断，因为这个条件恒成立
                    if (!flag) begin
                        if (nedge) begin
                            state <= 2;
                        end
                    end else begin
                        state  <= 0;
                        r_flag <= 1;  // 释放标志 脉冲信号
                    end
                end
                default: ;
            endcase
        end
    end

    assign filter_value = state == 0 || state == 1;

endmodule
