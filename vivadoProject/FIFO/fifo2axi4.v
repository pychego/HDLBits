/*
    AXI4协议：定义以下 5 个独立的传输通道：读地址通道 AR、 读数据通道 R、 写地址通道 AW、写数据通道 B、写响应通道 W
    读数据进行时没有单独的读响应通道，读响应操作在读数据通道R中进行

    VALID/READY：
    5条独立通道都包含一个双路VALID/READY握手信号
    信息源通过VALID信号只是通道中的数据和控制信息什么时候有效 目的源通过READY信号告诉信息源它是否准备好接收数据
    传输地址信息和数据都是在VALID和READY同时为高时有效

    LAST:
    R和W都包含一个LAST信号，发送最后一个数据时为高，其他情况为低
*/

module fifo2axi4 #(
    parameter WR_AXI_BYTE_ADDR_BEGIN = 0,   // 写入data的开始地址
    parameter WR_AXI_BYTE_ADDR_END   = 200, // 写入data的结束地址
    parameter RD_AXI_BYTE_ADDR_BEGIN = 0,
    parameter RD_AXI_BYTE_ADDR_END   = 200,

    parameter AXI_DATA_WIDTH = 128,
    parameter AXI_ADDR_WIDTH = 28,
    parameter AXI_ID_WIDTH   = 4,
    parameter AXI_ID         = 4'b0000,
    parameter AXI_BURST_LEN  = 8'd31     //burst length = 32
) (
    // clock reset
    input                       clk,
    input                       reset,
    // wr_fifo wr Interface
    input                       wr_addr_clr,       //sync clk
    output                      wr_fifo_rdreq,     // 与wr_fifo的接口，输出到wr_fifo的rd_en
    input  [AXI_DATA_WIDTH-1:0] wr_fifo_rddata,    // 从wr_fifo读出送入ddr3的data
    input                       wr_fifo_empty,     // 没用到的端口
    input  [               5:0] wr_fifo_rd_cnt,    // wr_fifo中可供读取的read width
    input                       wr_fifo_rst_busy,
    // rd_fifo rd Interface
    input                       rd_addr_clr,
    output                      rd_fifo_wrreq,
    output [AXI_DATA_WIDTH-1:0] rd_fifo_wrdata,
    input                       rd_fifo_alfull,
    input  [               5:0] rd_fifo_wr_cnt,     // rd_fifo中已经写入的 write width
    input                       rd_fifo_rst_busy,
    // Master Interface Write Address Ports 写addr AW
    output     [    AXI_ID_WIDTH-1:0] m_axi_awid,      // 写地址信号组的ID tag
    output reg [  AXI_ADDR_WIDTH-1:0] m_axi_awaddr,    // 输出到mig的地址和控制信息
    output     [                 7:0] m_axi_awlen,     // 突发式传输数据的个数为awlen+1
    output     [                 2:0] m_axi_awsize,    // 每个突发传输数据的字节数 4
    output     [                 1:0] m_axi_awburst,   // 突发传输类型
    output     [                 0:0] m_axi_awlock,    // 锁类型
    output     [                 3:0] m_axi_awcache,   // cache类型
    output     [                 2:0] m_axi_awprot,    // 保护类型
    output     [                 3:0] m_axi_awqos,     // 质量服务
    output     [                 3:0] m_axi_awregion,  // 区域标识符
    output reg                        m_axi_awvalid,   // 写地址有效
    input                             m_axi_awready,   // mig输入给该模块 slave端准备好接收写地址
    // Master Interface Write Data Ports  写data W
    output     [  AXI_DATA_WIDTH-1:0] m_axi_wdata,     // 128位写入的数据
    output     [AXI_DATA_WIDTH/8-1:0] m_axi_wstrb,     // 写数据有效的字节阀门
    output reg                        m_axi_wlast,     // 最后一个写入数据的指示信号
    output reg                        m_axi_wvalid,
    input                             m_axi_wready,
    // Master Interface Write Response Ports 写resp B
    input      [    AXI_ID_WIDTH-1:0] m_axi_bid,       // 写响应信号组的ID tag
    input      [                 1:0] m_axi_bresp,     // 写响应 指明写事务的状态
    input                             m_axi_bvalid,
    output                            m_axi_bready,
    // Master Interface Read Address Ports  读addr AR
    output     [    AXI_ID_WIDTH-1:0] m_axi_arid,
    output reg [  AXI_ADDR_WIDTH-1:0] m_axi_araddr,
    output     [                 7:0] m_axi_arlen,
    output     [                 2:0] m_axi_arsize,
    output     [                 1:0] m_axi_arburst,
    output     [                 0:0] m_axi_arlock,
    output     [                 3:0] m_axi_arcache,
    output     [                 2:0] m_axi_arprot,
    output     [                 3:0] m_axi_arqos,
    output     [                 3:0] m_axi_arregion,
    output reg                        m_axi_arvalid,
    input                             m_axi_arready,
    // Master Interface Read Data Ports 读data R
    input      [    AXI_ID_WIDTH-1:0] m_axi_rid,
    input      [  AXI_DATA_WIDTH-1:0] m_axi_rdata,     // ddr3送入axi总线中的读data
    input      [                 1:0] m_axi_rresp,     // 读响应
    input                             m_axi_rlast,
    input                             m_axi_rvalid,
    output                            m_axi_rready
);


    // 写事务4个状态S_IDLE S_WR_ADDR S_WR_DATA S_WR_RESP
    // 读事务3个状态S_IDLE S_RD_ADDR S_RD_RESP
    localparam S_IDLE  = 6'b000001,
             S_WR_ADDR = 6'b000010,
             S_WR_DATA = 6'b000100,
             S_WR_RESP = 6'b001000,
             S_RD_ADDR = 6'b010000,
             S_RD_RESP = 6'b100000;

    localparam DATA_SIZE = clogb2(AXI_DATA_WIDTH / 8 - 1);  // 4

    wire [7:0] wr_req_cnt_thresh;
    wire [7:0] rd_req_cnt_thresh;
    wire       wr_ddr3_req;  // 来了写入请求
    wire       rd_ddr3_req;
    reg        axi_awaddr_clr;
    reg        axi_araddr_clr;
    reg  [5:0] curr_wr_state;
    reg  [5:0] next_wr_state;
    reg  [5:0] curr_rd_state;
    reg  [5:0] next_rd_state;
    reg  [7:0] wr_data_cnt;


    // --------------------写操作状态机---------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) curr_wr_state <= S_IDLE;
        else begin
            curr_wr_state <= next_wr_state;
        end
    end
    // 组合逻辑操作next_wr_state,赋值使用=
    always @(*) begin
        case (curr_wr_state)
            S_IDLE: begin
                if (wr_ddr3_req == 1'b1) begin
                    next_wr_state = S_WR_ADDR;
                end else begin
                    next_wr_state = S_IDLE;
                end
            end
            S_WR_ADDR: begin
                if (m_axi_awready && m_axi_awvalid) begin
                    next_wr_state = S_WR_DATA;
                end else begin
                    next_wr_state = S_WR_ADDR;
                end
            end
            S_WR_DATA: begin
                if (m_axi_wready && m_axi_wvalid && m_axi_wlast) begin
                    next_wr_state = S_WR_RESP;
                end else begin
                    next_wr_state = S_WR_DATA;
                end
            end
            S_WR_RESP: begin
                // bresp为00表示数据写入成功
                if(m_axi_bready && m_axi_bvalid && (m_axi_bresp == 2'b00) 
                && (m_axi_bid == AXI_ID[AXI_ID_WIDTH-1:0])) begin
                    next_wr_state = S_IDLE;
                end else begin
                    next_wr_state = S_WR_RESP;
                end
            end
            default: next_wr_state = 6'bxxxxxx;
        endcase
    end

    // --------------------读操作状态机---------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            curr_rd_state <= S_IDLE;
        end else curr_rd_state <= next_rd_state;
    end

    always @(*) begin
        case (curr_rd_state)
            S_IDLE: begin
                if (rd_ddr3_req == 1'b1) begin
                    next_rd_state = S_RD_ADDR;
                end else begin
                    next_rd_state = S_IDLE;
                end
            end
            S_RD_ADDR: begin
                if (m_axi_arready && m_axi_arvalid) begin
                    next_rd_state = S_RD_RESP;
                end else begin
                    next_rd_state = S_RD_ADDR;
                end
            end
            S_RD_RESP: begin
                if (m_axi_rready && m_axi_rvalid && m_axi_rlast && (m_axi_rresp == 2'b00)
                && (m_axi_rid == AXI_ID[AXI_ID_WIDTH-1:0])) begin
                    next_rd_state = S_IDLE;
                end else begin
                    next_rd_state = S_RD_RESP;
                end
            end
            default: next_rd_state = 6'bxxxxxx;
        endcase
    end
    // ----------------------读写状态机设计完成----------------------------

    /*
        read addr AR
        read data R

        write addr AW
        write data W
        write respond B
        R B大部分是input信号 不需要always块操作，对其中ouput信号直接assign赋值
    */
    assign m_axi_awid = AXI_ID[AXI_ID_WIDTH-1:0];
    assign m_axi_awsize = DATA_SIZE;
    assign m_axi_awburst = 2'b01;
    assign m_axi_awlock = 1'b0;
    assign m_axi_awcache = 4'b0000;
    assign m_axi_awprot = 3'b000;
    assign m_axi_awqos = 4'b0000;
    assign m_axi_awregion = 4'b0000;
    assign m_axi_awlen = AXI_BURST_LEN[7:0];    //burst length = 32

    assign m_axi_wstrb = 16'hffff;

    assign m_axi_bready = 1'b1;                 // 写响应始终为1
    assign m_axi_arid = AXI_ID[AXI_ID_WIDTH-1:0];
    assign m_axi_arsize = DATA_SIZE;
    assign m_axi_arburst = 2'b01;
    assign m_axi_arlock = 1'b0;
    assign m_axi_arcache = 4'b0000;
    assign m_axi_arprot = 3'b000;
    assign m_axi_arqos = 4'b0000;
    assign m_axi_arregion= 4'b0000;
    assign m_axi_arlen = AXI_BURST_LEN[7:0];    // 涉及到读写数据的都是这个值 32
    assign m_axi_rready = ~rd_fifo_alfull;
    // ----------------------以上设计完成AXI接口信号-------------------------

    // ---------------------操作wr_ddr3_fifo 与fifo2axi4之间的接口---------------
    // wr_fifo_rdreq有效即wr_fifo的rd_en信号有效 将wr_fifo中数据送入ddr3
    // 该信号输入到wr_fifo为rd_en   axi总线侧和slave都准备好了，开始对ddr3写入数据
    assign wr_fifo_rdreq = (~axi_awaddr_clr) && m_axi_wvalid &&
                            m_axi_wready;
    // wr_fifo中暂存的数据通过axi写入ddr3
    assign m_axi_wdata = wr_fifo_rddata;        

    
    // rd_fifo_wrreq有效即rd_fifo的wr_en信号有效 ddr3的内容可以被读出来 写入到rd_fifo
    assign rd_fifo_wrreq = (~axi_araddr_clr) && m_axi_rvalid &&
                            m_axi_rready;
    assign rd_fifo_wrdata = m_axi_rdata;    // 将从AXI接口中读到的数据送到rd_fifo


    assign wr_req_cnt_thresh = (m_axi_awlen == 'd0)? 1'b1 :
    (AXI_BURST_LEN[7:0]+1'b1-2'd2);         //计数比实际数量少2 本例中为30
    assign rd_req_cnt_thresh = AXI_BURST_LEN[7:0];  // 31

    // ----------------------------axi总线读写触发信号--------------------------
    // 当wr_fifo存放了30个read width（128bit）后，axi总线开始 写addr AW
    // 理解：wr_fifo写端口每次写入16bit，读端口每次读出128bit，故read width为30时，axi总线可以很快读出32个总线单位
    assign wr_ddr3_req = (wr_fifo_rst_busy == 1'b0) && (wr_fifo_rd_cnt >=
    wr_req_cnt_thresh) ? 1'b1:1'b0;             // 送的数量达到一定值之后才发出写入ddr3的指令
    // rd_fifo的write width是64， 只要其值小于31，剩余空间就还够读入一次burst
    assign rd_ddr3_req = (rd_fifo_rst_busy == 1'b0) && (rd_fifo_wr_cnt <=
    rd_req_cnt_thresh) ? 1'b1:1'b0;             // 只要我rd_fifo中数据不够多，就一直从ddr3中读数据


    // ---------------------产生写过程中的各种信号-------------------------
    // 写地址信号m_axi_awaddr m_axi_awvalid
    // 地址一字节为单位,每次地址增量为突发写数据个数(m_axi_awlen + 1)*每个数据的字节数(AXI_DATA_WIDTH / 8)
    // 每次地址加512byte
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
        end else if (wr_addr_clr || axi_araddr_clr) m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
        else if (m_axi_awaddr >= WR_AXI_BYTE_ADDR_END) m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
        else if(curr_wr_state == S_WR_RESP && m_axi_bready && m_axi_bvalid &&
        (m_axi_bresp == 2'b00) && (m_axi_bid == AXI_ID[AXI_ID_WIDTH-1:0]))
        // 在成功写入一次数据之后,更改下次写入data的地址
            m_axi_awaddr <= m_axi_awaddr + ((m_axi_awlen + 1) * (AXI_DATA_WIDTH / 8));
        else begin
            m_axi_awaddr <= m_axi_awaddr;
        end
    end

    // 内部发出写地址valid信号
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            m_axi_awvalid <= 1'b0;
        end else if((curr_wr_state==S_WR_ADDR) && m_axi_awready && m_axi_awvalid) begin
            // 保证ready和valid只有一个clk同时为高
            m_axi_awvalid <= 0;
        end else if(curr_wr_state==S_WR_ADDR) begin
            m_axi_awvalid <= 1;
        end
    end

    // 写data W 产生wvalid和wlast信号
    // 此处与例程代码不同
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            m_axi_wvalid <= 1'b0;
        end else if (curr_wr_state==S_WR_DATA && !m_axi_wlast)
            m_axi_wvalid <= 1'b1;
        else begin
            m_axi_wvalid <= 1'b0;
        end
    end

    // 对比已传输的数据个数wr_data_cnt和总的数据个数 在传输最后一个数据时置wlast为1
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            wr_data_cnt <= 0;
        end else if (curr_wr_state==S_WR_DATA && m_axi_awready && m_axi_awvalid)
            wr_data_cnt <= wr_data_cnt + 1;
        else if(curr_wr_state==S_IDLE)
            wr_data_cnt <= 0;
    end

    // burst写入ddr3 每轮次写入32个总线单位 wr_data_cnt=31期间last为高电平
    // 正好再来一个clk后读出last为高电平，这个clk就读入的是最后一个数据
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            m_axi_wlast <= 0;
        end else if(curr_wr_state==S_WR_DATA && m_axi_awlen==8'd0)
        // 此时S_WR_DATA只能持续一个clk
            m_axi_wlast <= 1;
     else if(curr_wr_state==S_WR_DATA && m_axi_awready && m_axi_awvalid &&
             (wr_data_cnt==m_axi_awlen-1))    // 比较wr_data_cnt和30
                 m_axi_wlast <= 1;
        else m_axi_wlast <= 0;
    end


    // ---------------------产生读过程中的各种信号-------------------------
    // 读地址过程 m_axi_araddr 128位
    // 这里处理简单了很多，读就从最低位开始读
    // 每一轮burst m_axi_araddr就加上(m_axi_arlen + 1) * (AXI_DATA_WIDTH / 8) byte
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
        end else if (rd_addr_clr || axi_araddr_clr) begin
            m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
        end
        else if (m_axi_araddr >= RD_AXI_BYTE_ADDR_END) begin
            m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
        end
        else if(curr_wr_state == S_RD_RESP && m_axi_rready && m_axi_rvalid &&
        (m_axi_rresp == 2'b00) && (m_axi_rid == AXI_ID[AXI_ID_WIDTH-1:0])) begin
                m_axi_araddr <= m_axi_araddr + ((m_axi_arlen + 1) * (AXI_DATA_WIDTH / 8));
        end
        else begin
            m_axi_araddr <= m_axi_araddr;
        end
    end
    // m_axi_arvalid 类比awvalid
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            m_axi_arvalid <= 1'b0;
        end else if((curr_wr_state==S_RD_ADDR) && m_axi_arready && m_axi_arvalid) begin
            // 保证ready和valid只有一个clk同时为高
            m_axi_arvalid <= 0;
        end else if(curr_wr_state==S_RD_ADDR) begin
            m_axi_arvalid <= 1;
        end
    end

    //**********************************
    //The following function calculates the awsize/arsize width based on AXI_DATA_WIDTH
    //********************************** for语句可以综合？？
    // 计算一个二进制数的最高非0位是第几位
    function integer clogb2;
    input integer axi_data_byte;
        for (clogb2=0; axi_data_byte>0; clogb2=clogb2+1)
        axi_data_byte = axi_data_byte >> 1;
    endfunction
    
endmodule
