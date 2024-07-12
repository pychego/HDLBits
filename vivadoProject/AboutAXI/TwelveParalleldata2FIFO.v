/* 该模块用于将六路并联信号(实时SSI)转化为M_AXIStream, 与 AXI Stream DATA FIFO连接 
   通过DMA一次性将6个实时SSI信号和反解得到的target传输到DDR中,只需要用到DMA write功能
*/

module TwelveParalleldata2FIFO (
    input clk,
    input rst_n,

    input [31:0] data0,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [31:0] data4,
    input [31:0] data5,
    input [31:0] data6,
    input [31:0] data7,
    input [31:0] data8,
    input [31:0] data9,
    input [31:0] data10,
    input [31:0] data11,

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
                            end
                            5: begin
                                M_AXIS_tdata <= data6;
                                SelectInput  <= 6;
                            end
                            6: begin
                                M_AXIS_tdata <= data7;
                                SelectInput  <= 7;
                            end
                            7: begin
                                M_AXIS_tdata <= data8;
                                SelectInput  <= 8;
                            end
                            8: begin
                                M_AXIS_tdata <= data9;
                                SelectInput  <= 9;
                            end
                            9: begin
                                M_AXIS_tdata <= data10;
                                SelectInput  <= 10;
                            end
                            10: begin
                                M_AXIS_tdata <= data11;
                                SelectInput <= 11;
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
