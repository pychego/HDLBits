module DDS_module (
    input         clk,
    input         reset_n,
    input  [31:0] fword,    // 32位频率控制字 确定采样的步长 N=32,N是分为2^32份, 每个clk到来地址改变步长为fword/2^32
    input  [11:0] pword,    // 12位相位控制字 作为地址偏移 位数和地址位数相同
    output [13:0] data      // rom存储的数据，输送到dac
);

    // 频率控制字的同步寄存器
    reg [31:0] fword_reg;
    always @(posedge clk) begin
        fword_reg <= fword;
    end

    // 相位控制字的同步寄存器
    reg [11:0] pword_reg;
    always @(posedge clk) begin
        pword_reg <= pword;
    end

    // 相位累加器
    reg [31:0] phase_acc;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            phase_acc <= 0;
        end else begin
            phase_acc <= phase_acc + fword_reg;
        end
    end

    // 存放4096个地址, 每次取地址加上偏移pword_reg
    wire [11:0] addr;
    assign addr = phase_acc[31:20] + pword_reg;

    // rom模块
    // 4096个地址, 存放的4096个数据是正弦波的一个周期
    /*
        理解 F_0 = fword * F_clk / 2^N , N=32
        考虑使用12位地址,共4096个点存放一个周期正弦波,若fword=2^20,则F_0=F_clk / 2^12
        此时,addr也是每clk加一,故频率为F_clk / 4096, 和公式算出来的结果一样
    */
    rom rom_inst(
        .clka(clk),
        .addra(addr),
        .douta(data)
    );

endmodule
