/* 状态机实现按键消抖，消抖时间20ms
    0：空闲 idle 来下降沿之后进入按下消抖（1）
    1：按下消抖 p_filter 20ms内没有上升沿就进入等待释放（3），否则保持原态
    2：等待释放 wait_release 来上升沿之后进入释放消抖（3）
    3：释放消抖 r_filter 20ms内没有下降沿就进入空闲（0），否则保持原态
*/

module shake_suppression (
    input  clk,
    input  reset_n,      // 按键消抖适合有复位键吗
    input  key_value,
    output filter_value
);

    // 两个寄存器判断上升沿和下降沿
    reg [1:0] key_value_reg;
    always @(posedge clk) begin
        key_value_reg[0] <= key_value;
        key_value_reg[1] <= key_value_reg[0];
    end

    // 上升沿和下降沿判断 脉冲信号
    wire pedge, nedge;
    assign pedge = key_value_reg == 2'b01;
    assign nedge = key_value_reg == 2'b10;

    // 定义状态机
    reg [1:0] state;
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
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (nedge) begin
                        state <= 1;
                        count <= 0;
                        flag  <= 0;
                    end
                end
                1: begin
                    if (!flag) begin
                        if (pedge) begin
                            state <= 1;
                            count <= 0;
                            flag  <= 0;
                        end 
                    end else state <= 2;  // 超过20ms没有动作
                end
                2: begin
                    if (pedge) begin
                        state <= 3;
                        count <= 0;
                        flag  <= 0;
                    end
                end
                3: begin
                    if (!flag) begin
                        if (nedge) begin
                            state <= 3;
                            count <= 0;
                            flag  <= 0;
                        end 
                    end else state <= 0;  
                end
                default: ;
            endcase
        end
    end
    
    assign filter_value = state == 0 || state == 1;



endmodule
