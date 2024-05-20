// what is the position of this module in the entire design?
// 为了方便与AXI总线传输, 将输出设置成32bit, 但是实际只有25bit有用
module Board1_Processing_SSI (
    input         rst_n,
    input         SSI_clk,
    input         SSI_flag,
    input         SSI_data,  

    output [31:0] loc_data   // 31bit
);
    // 根据SSI时序可知，SSI_clk每来一个上升沿传感器就送入一个SSI_data 因此要设计在SSI_clk下降沿读取SSI_data
    // 25 SSI_clk neg edge
    (*mark_DEBUG = "TRUE"*) reg [7:0] count_SSIclk;
    always @(negedge SSI_clk or negedge rst_n) begin
        if (!rst_n) count_SSIclk <= 8'd0;
        else if (SSI_flag) count_SSIclk <= count_SSIclk + 1'b1;
        else if (count_SSIclk == 8'd25) count_SSIclk <= 8'd0;
    end

    (*mark_DEBUG = "TRUE"*)reg [24:0] data_buffer;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_gray;
    // SSI_data in the negedge od SSI_clk is stable
    // 在SSI_clk的下降沿读取SSI_data, 实际综合时用SSI_clk下降沿作为触发信号合适吗
    always @(negedge SSI_clk or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_gray <= 25'd0;
            data_buffer   <= 25'd0;
        end else if (SSI_flag) begin
            // 新来的放到最低位，旧的左移一位
            data_buffer <= {data_buffer[23:0], SSI_data};
        end else if (count_SSIclk == 8'd25) begin
            // time is count_SSIclk from 25 to 0
            // 如果是二进制的位移传感器, 那得到loc_data_gray程序就结束了
            loc_data_gray <= data_buffer;
            data_buffer   <= 25'd0;
        end
    end
    assign loc_data = loc_data_gray;

endmodule

