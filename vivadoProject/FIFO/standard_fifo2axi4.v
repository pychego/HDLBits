/////////////////////////////////////////////////////////////////////////////////
// Company       : 武汉芯路恒科技有限公司
//                 http://xiaomeige.taobao.com
// Web           : http://www.corecourse.cn
// 
// Create Date   : 2019/05/01 00:00:00
// Module Name   : fifo2axi4
// Description   : fifo接口到AXI4接口的转换模块(不含FIFO)
// 
// Dependencies  : 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
/////////////////////////////////////////////////////////////////////////////////

module fifo2axi4
#(
  parameter WR_AXI_BYTE_ADDR_BEGIN = 0      ,
  parameter WR_AXI_BYTE_ADDR_END   = 200    ,
  parameter RD_AXI_BYTE_ADDR_BEGIN = 0      ,
  parameter RD_AXI_BYTE_ADDR_END   = 200    ,

  parameter AXI_DATA_WIDTH         = 128    ,
  parameter AXI_ADDR_WIDTH         = 28     ,
  parameter AXI_ID_WIDTH           = 4      ,
  parameter AXI_ID                 = 4'b0000,
  parameter AXI_BURST_LEN          = 8'd31    //burst length = 32
)
(
  // clock reset
  input                              clk              ,
  input                              reset            ,
  // wr_fifo wr Interface
  input                              wr_addr_clr      ,//sync clk
  output                             wr_fifo_rdreq    ,
  input      [AXI_DATA_WIDTH-1:0]    wr_fifo_rddata   ,
  input                              wr_fifo_empty    ,
  input      [5:0]                   wr_fifo_rd_cnt   ,
  input                              wr_fifo_rst_busy ,
  // rd_fifo rd Interface
  input                              rd_addr_clr      ,
  output                             rd_fifo_wrreq    ,
  output     [AXI_DATA_WIDTH-1:0]    rd_fifo_wrdata   ,
  input                              rd_fifo_alfull   ,
  input      [5:0]                   rd_fifo_wr_cnt   ,
  input                              rd_fifo_rst_busy ,
  // Master Interface Write Address Ports
  output     [AXI_ID_WIDTH-1:0]      m_axi_awid       ,
  output reg [AXI_ADDR_WIDTH-1:0]    m_axi_awaddr     ,
  output     [7:0]                   m_axi_awlen      ,
  output     [2:0]                   m_axi_awsize     ,
  output     [1:0]                   m_axi_awburst    ,
  output     [0:0]                   m_axi_awlock     ,
  output     [3:0]                   m_axi_awcache    ,
  output     [2:0]                   m_axi_awprot     ,
  output     [3:0]                   m_axi_awqos      ,
  output     [3:0]                   m_axi_awregion   ,
  output reg                         m_axi_awvalid    ,
  input                              m_axi_awready    ,
  // Master Interface Write Data Ports
  output     [AXI_DATA_WIDTH-1:0]    m_axi_wdata      ,
  output     [AXI_DATA_WIDTH/8-1:0]  m_axi_wstrb      ,
  output reg                         m_axi_wlast      ,
  output reg                         m_axi_wvalid     ,
  input                              m_axi_wready     ,
  // Master Interface Write Response Ports
  input      [AXI_ID_WIDTH-1:0]      m_axi_bid        ,
  input      [1:0]                   m_axi_bresp      ,
  input                              m_axi_bvalid     ,
  output                             m_axi_bready     ,
  // Master Interface Read Address Ports
  output     [AXI_ID_WIDTH-1:0]      m_axi_arid       ,
  output reg [AXI_ADDR_WIDTH-1:0]    m_axi_araddr     ,
  output     [7:0]                   m_axi_arlen      ,
  output     [2:0]                   m_axi_arsize     ,
  output     [1:0]                   m_axi_arburst    ,
  output     [0:0]                   m_axi_arlock     ,
  output     [3:0]                   m_axi_arcache    ,
  output     [2:0]                   m_axi_arprot     ,
  output     [3:0]                   m_axi_arqos      ,
  output     [3:0]                   m_axi_arregion   ,
  output reg                         m_axi_arvalid    ,
  input                              m_axi_arready    ,
  // Master Interface Read Data Ports
  input      [AXI_ID_WIDTH-1:0]      m_axi_rid        ,
  input      [AXI_DATA_WIDTH-1:0]    m_axi_rdata      ,
  input      [1:0]                   m_axi_rresp      ,
  input                              m_axi_rlast      ,
  input                              m_axi_rvalid     ,
  output                             m_axi_rready     
);

  localparam S_IDLE    = 6'b000001,
             S_WR_ADDR = 6'b000010,
             S_WR_DATA = 6'b000100,
             S_WR_RESP = 6'b001000,
             S_RD_ADDR = 6'b010000,
             S_RD_RESP = 6'b100000;

  localparam DATA_SIZE = clogb2(AXI_DATA_WIDTH/8-1);

  wire [7:0] wr_req_cnt_thresh;
  wire [7:0] rd_req_cnt_thresh;
  wire       wr_ddr3_req;
  wire       rd_ddr3_req;
  reg        axi_awaddr_clr;
  reg        axi_araddr_clr;
  reg  [5:0] curr_wr_state;
  reg  [5:0] next_wr_state;
  reg  [5:0] curr_rd_state;
  reg  [5:0] next_rd_state;
  reg  [7:0] wr_data_cnt;

  assign m_axi_awid    = AXI_ID[AXI_ID_WIDTH-1:0];
  assign m_axi_awsize  = DATA_SIZE;
  assign m_axi_awburst = 2'b01;
  assign m_axi_awlock  = 1'b0;
  assign m_axi_awcache = 4'b0000;
  assign m_axi_awprot  = 3'b000;
  assign m_axi_awqos   = 4'b0000;
  assign m_axi_awregion= 4'b0000;
  assign m_axi_awlen   = AXI_BURST_LEN[7:0];
  
  assign m_axi_wstrb   = 16'hffff;
  assign m_axi_wdata   = wr_fifo_rddata;

  assign m_axi_bready  = 1'b1;

  assign m_axi_arid    = AXI_ID[AXI_ID_WIDTH-1:0];
  assign m_axi_arsize  = DATA_SIZE;
  assign m_axi_arburst = 2'b01;
  assign m_axi_arlock  = 1'b0;
  assign m_axi_arcache = 4'b0000;
  assign m_axi_arprot  = 3'b000;
  assign m_axi_arqos   = 4'b0000;
  assign m_axi_arregion= 4'b0000;
  assign m_axi_arlen   = AXI_BURST_LEN[7:0];

  assign m_axi_rready  = ~rd_fifo_alfull;

  assign wr_fifo_rdreq  = (~axi_awaddr_clr) && m_axi_wvalid && m_axi_wready;
  assign rd_fifo_wrreq  = (~axi_araddr_clr) && m_axi_rvalid && m_axi_rready;
  assign rd_fifo_wrdata = m_axi_rdata;

  assign wr_req_cnt_thresh = (m_axi_awlen == 'd0)? 1'b1 : (AXI_BURST_LEN[7:0]+1'b1-2'd2);//计数比实际数量少2
  assign rd_req_cnt_thresh = AXI_BURST_LEN[7:0];
  assign wr_ddr3_req = (wr_fifo_rst_busy == 1'b0) && (wr_fifo_rd_cnt >= wr_req_cnt_thresh) ? 1'b1:1'b0;
  assign rd_ddr3_req = (rd_fifo_rst_busy == 1'b0) && (rd_fifo_wr_cnt <= rd_req_cnt_thresh) ? 1'b1:1'b0;

  always@(posedge clk or posedge reset)
  begin
    if(reset)
      axi_awaddr_clr <= 1'b0;
    else if(m_axi_wready && m_axi_wvalid && m_axi_wlast)
      axi_awaddr_clr <= 1'b0;
    else if(wr_addr_clr && (m_axi_awvalid || m_axi_wvalid))
      axi_awaddr_clr <= 1'b1;
    else
      axi_awaddr_clr <= axi_awaddr_clr;
  end

  //m_axi_awaddr
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
    else if(wr_addr_clr || axi_awaddr_clr)
      m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
    else if(m_axi_awaddr >= WR_AXI_BYTE_ADDR_END)
      m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
    else if((curr_wr_state == S_WR_RESP) && m_axi_bready && m_axi_bvalid && (m_axi_bresp == 2'b00) && (m_axi_bid == AXI_ID[AXI_ID_WIDTH-1:0]))
      m_axi_awaddr <= m_axi_awaddr + ((m_axi_awlen + 1'b1)*(AXI_DATA_WIDTH/8));
    else
      m_axi_awaddr <= m_axi_awaddr;
  end

  //m_axi_awvalid
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      m_axi_awvalid <= 1'b0;
    else if((curr_wr_state == S_WR_ADDR) && m_axi_awready && m_axi_awvalid)
      m_axi_awvalid <= 1'b0;
    else if(curr_wr_state == S_WR_ADDR)
      m_axi_awvalid <= 1'b1;
    else
      m_axi_awvalid <= m_axi_awvalid;
  end

  //m_axi_awvalid
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      m_axi_wvalid <= 1'b0;
    else if((curr_wr_state == S_WR_DATA) && m_axi_wready && m_axi_wvalid && m_axi_wlast)
      m_axi_wvalid <= 1'b0;
    else if(curr_wr_state == S_WR_DATA)
      m_axi_wvalid <= 1'b1;
    else
      m_axi_wvalid <= m_axi_wvalid;
  end

  //wr_data_cnt
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      wr_data_cnt <= 1'b0;
    else if(curr_wr_state == S_IDLE)
      wr_data_cnt <= 1'b0;
    else if(curr_wr_state == S_WR_DATA && m_axi_wready && m_axi_wvalid)
      wr_data_cnt <= wr_data_cnt + 1'b1;
    else
      wr_data_cnt <= wr_data_cnt;
  end

  //m_axi_wlast
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      m_axi_wlast <= 1'b0;
    else if(curr_wr_state == S_WR_DATA && m_axi_wready && m_axi_wvalid && m_axi_wlast)
      m_axi_wlast <= 1'b0;
    else if(curr_wr_state == S_WR_DATA && m_axi_awlen == 8'd0)
      m_axi_wlast <= 1'b1;
    else if(curr_wr_state == S_WR_DATA && m_axi_wready && m_axi_wvalid && (wr_data_cnt == m_axi_awlen -1'b1))
      m_axi_wlast <= 1'b1;
    else
      m_axi_wlast <= m_axi_wlast;
  end

  always@(posedge clk or posedge reset)
  begin
    if(reset)
      axi_araddr_clr <= 1'b0;
    else if(m_axi_rready && m_axi_rvalid && m_axi_rlast)
      axi_araddr_clr <= 1'b0;
    else if(rd_addr_clr && (m_axi_arvalid || m_axi_rvalid))
      axi_araddr_clr <= 1'b1;
    else
      axi_araddr_clr <= axi_araddr_clr;
  end

  //m_axi_araddr
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
    else if(rd_addr_clr || axi_araddr_clr)
      m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
    else if(m_axi_araddr >= RD_AXI_BYTE_ADDR_END)
      m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
    else if((curr_rd_state == S_RD_RESP) && m_axi_rready && m_axi_rvalid && m_axi_rlast && (m_axi_rresp == 2'b00) && (m_axi_rid == AXI_ID[AXI_ID_WIDTH-1:0]))
      m_axi_araddr <= m_axi_araddr + ((m_axi_arlen + 1'b1)*(AXI_DATA_WIDTH/8));
    else
      m_axi_araddr <= m_axi_araddr;
  end

  //m_axi_arvalid
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      m_axi_arvalid <= 1'b0;
    else if((curr_rd_state == S_RD_ADDR) && m_axi_arready && m_axi_arvalid)
      m_axi_arvalid <= 1'b0;
    else if(curr_rd_state == S_RD_ADDR)
      m_axi_arvalid <= 1'b1;
    else
      m_axi_arvalid <= m_axi_arvalid;
  end

  //**********************************
  //write state machine
  //**********************************
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      curr_wr_state <= S_IDLE;
    else
      curr_wr_state <= next_wr_state;
  end

  always@(*)
  begin
    case(curr_wr_state)
      S_IDLE:
      begin
        if(wr_ddr3_req == 1'b1)
          next_wr_state = S_WR_ADDR;
        else
          next_wr_state = S_IDLE;
      end

      S_WR_ADDR:
      begin
        if(m_axi_awready && m_axi_awvalid)
          next_wr_state = S_WR_DATA;
        else
          next_wr_state = S_WR_ADDR;
      end

      S_WR_DATA:
      begin
        if(m_axi_wready && m_axi_wvalid && m_axi_wlast)
          next_wr_state = S_WR_RESP;
        else
          next_wr_state = S_WR_DATA;
      end

      S_WR_RESP:
      begin
        if(m_axi_bready && m_axi_bvalid && (m_axi_bresp == 2'b00) && (m_axi_bid == AXI_ID[AXI_ID_WIDTH-1:0]))
          next_wr_state = S_IDLE;
        else
          next_wr_state = S_WR_RESP;
      end

      default: next_wr_state = S_IDLE;
    endcase
  end

  //**********************************
  //read state machine
  //**********************************
  always@(posedge clk or posedge reset)
  begin
    if(reset)
      curr_rd_state <= S_IDLE;
    else
      curr_rd_state <= next_rd_state;
  end

  always@(*)
  begin
    case(curr_rd_state)
      S_IDLE:
      begin
        if(rd_ddr3_req == 1'b1)
          next_rd_state = S_RD_ADDR;
        else
          next_rd_state = S_IDLE;
      end

      S_RD_ADDR:
      begin
        if(m_axi_arready && m_axi_arvalid)
          next_rd_state = S_RD_RESP;
        else
          next_rd_state = S_RD_ADDR;
      end

      S_RD_RESP:
      begin
        if(m_axi_rready && m_axi_rvalid && m_axi_rlast && (m_axi_rresp == 2'b00) && (m_axi_rid == AXI_ID[AXI_ID_WIDTH-1:0]))
          next_rd_state = S_IDLE;
        else
          next_rd_state = S_RD_RESP;
      end

      default: next_rd_state = S_IDLE;
    endcase
  end


  //**********************************
  //The following function calculates the awsize/arsize width based on AXI_DATA_WIDTH
  //**********************************
  function integer clogb2;
    input integer axi_data_byte;
      for (clogb2=0; axi_data_byte>0; clogb2=clogb2+1)
        axi_data_byte = axi_data_byte >> 1;
  endfunction

endmodule