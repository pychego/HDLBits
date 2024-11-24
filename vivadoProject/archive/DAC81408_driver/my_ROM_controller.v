// this module is used to opearte the block memory to read data form it
// BRAM的控制器,对BRAM进行读操作
module my_ROM_controller (
                            input             clk,
                            input             rst_n,
                            input             start,
                            
                            output reg        rom_en,
    (*mark_DEBUG = "TRUE"*) output reg [31:0] rom_addr,
                            output reg        rom_clk
);

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // rom_clk频率10kHz
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rom_clk <= 4'd0;
        else if (cnt == 14'd1) rom_clk <= 1'b1;
        else if (cnt == 14'd5001) rom_clk <= 1'b0;
        else rom_clk <= rom_clk;
    end

    // count_10kHz也是0-9,每个状态持续0.1ms,周期1ms;和其他模块的count_10kHz是完全同步的
    reg [3:0] count_10kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en && start) begin
            if (count_10kHz == 4'd10 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_en   <= 1'b0;
            rom_addr <= 32'd0;
            // 状态机没问题, 初始化之后addr为0期间,会有rom_en为1的一个clk周期
            // 每1ms取一次数据
        end else if (clk_10kHz_en) begin
            case (count_10kHz)
                4'd1: begin
                    rom_en <= 1'b1;
                end
                4'd2: begin
                    rom_en <= 1'b0;
                end
                4'd9: begin
                    if (rom_addr >= 32'd1000 - 32'd1) rom_addr <= 32'd0;
                    else rom_addr <= rom_addr + 1'b1;
                end
                default: begin
                    rom_en <= 1'b0;
                end
            endcase
        end
    end

endmodule
/*
取参考波形的时序:
1. count_10kHz从0-9,每个状态持续0.1ms,总共1ms,在count_10kHz=1时取数据
2. 也就是说在1ms的控制周期刚开始就取参考波形了
*/
