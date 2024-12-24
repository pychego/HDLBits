/*  计数器法实现同步FIFO
    接口: 
    1. clk, rst_n
    2. 输入: data_in, wr_en, rd_en
    3. 输出: data_out, full, empty
*/




module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DATA_DEPTH = 8
) (
    input                  clk,
    input                  rst_n,
    input [DATA_WIDTH-1:0] data_in,
    input                  wr_en,    // 写使能
    input                  rd_en,    // 读使能

    output reg [DATA_WIDTH-1 : 0] data_out,  // 该输出和raddr的逻辑写在一个always块
    output full,
    output empty,
    output reg [$clog2(DATA_DEPTH) : 0] fifo_cnt
);


    // 怎么初始化?  不用初始化
    reg [DATA_WIDTH-1 : 0] fifo [DATA_DEPTH-1 : 0];  // 这个和waddr写在一个always块

    reg [$clog2(DATA_DEPTH)-1 : 0] waddr, raddr;

    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) waddr <= 0;
        else begin
            if (wr_en && ~full) begin
                waddr <= waddr + 1;
                fifo[waddr] <= data_in;
            end
        end
    end

    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            raddr <= 0;
        end else begin
            if (rd_en && ~empty) begin
                raddr <= raddr + 1;
                data_out <= fifo[raddr];
            end
        end
    end

    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) fifo_cnt <= 0;
        else begin
            case ({
                wr_en, rd_en
            })
                2'b00, 2'b11: fifo_cnt <= fifo_cnt;
                2'b10: begin
                    if (~full) fifo_cnt <= fifo_cnt + 1;
                    else fifo_cnt <= fifo_cnt;
                end
                2'b01: begin
                    if (~empty) fifo_cnt <= fifo_cnt - 1;
                    else fifo_cnt <= fifo_cnt;
                end
                default: ;
            endcase
        end
    end

    assign empty = (fifo_cnt == 0);
    assign full  = (fifo_cnt == DATA_DEPTH);

endmodule
