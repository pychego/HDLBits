/* 该模块用于将六路并联信号(实时SSI)转化为M_AXIStream, 与 AXI Stream DATA FIFO连接 
   通过DMA一次性将六个实时SSI信号传输到DDR中,只需要用到DMA write功能
   2025.11.26
   这个代码有bug, 使用这个传输0~5路ssi时, 1,2,3路的ssi会串第5路的ssi数据, 但是不知道哪里出错了
   使用12通道的代码, 只使用前六个通道传输数据, 这时没有问题
   ... 不知道哪里出错了, ,,
*/

module SixParalleldata2FIFO (
    input clk,
    input rst_n,

    input [31:0] data0,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [31:0] data4,
    input [31:0] data5,

    // M_AXIS接口 与AXI4-Stream Data FIFO接口连接
    output reg [31:0] M_AXIS_tdata,
    output     [ 3:0] M_AXIS_tkeep,
    output reg        M_AXIS_tlast,
    input             M_AXIS_tready,
    output reg        M_AXIS_tvalid
);

    assign M_AXIS_tkeep = 4'b1111;

    // 因为接口ssi一直在变化, 必须要SelectInput指示当前发送的是哪一个ssi!
    // 直接使用接口数据作为判断语句,根本不会进行数据的传送!!!
    // 这个错误找了两天才发现
    reg [3:0] SelectInput;

    reg [1:0] state;
    // 循环状态机, 因此循环发送数据
    always @(posedge clk) begin
        if (!rst_n) begin
            M_AXIS_tvalid <= 1'b0;
            M_AXIS_tdata <= data0;
            M_AXIS_tlast <= 1'b0;
            SelectInput <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (M_AXIS_tready) begin
                        M_AXIS_tvalid <= 1'b1;
                        state <= 1;
                    end else begin
                        M_AXIS_tvalid <= 1'b0;
                        state <= 0;
                    end
                end
                1: begin
                    if (M_AXIS_tready) begin
                        case (SelectInput)
                            0: begin
                                M_AXIS_tdata <= data1;
                                SelectInput  <= 1;
                            end
                            1: begin
                                M_AXIS_tdata <= data2;
                                SelectInput  <= 2;
                            end
                            2: begin
                                M_AXIS_tdata <= data3;
                                SelectInput  <= 3;
                            end
                            3: begin
                                M_AXIS_tdata <= data4;
                                SelectInput  <= 4;
                            end
                            4: begin
                                M_AXIS_tdata <= data5;
                                SelectInput <= 5;
                                M_AXIS_tlast <= 1'b1;
                                state <= 2;
                            end
                            default: SelectInput <= 0;
                        endcase
                    end else begin
                        M_AXIS_tdata <= M_AXIS_tdata;
                        SelectInput <= SelectInput;
                        state <= 1;
                    end
                end
                2: begin  // 发送最后一个数据时已经state=2了
                    if (!M_AXIS_tready) begin  // 如果此时slave没准备接收
                        M_AXIS_tvalid <= 1'b1;
                        M_AXIS_tlast <= 1'b1;
                        M_AXIS_tdata <= M_AXIS_tdata;
                        state <= 2;
                    end else begin  // 已经准备好接收了
                        M_AXIS_tvalid <= 1'b0;
                        M_AXIS_tlast <= 1'b0;
                        M_AXIS_tdata <= data0;
                        SelectInput <= 0;
                        state <= 0;
                    end
                end
                default: state <= 0;
            endcase
        end
    end

endmodule
