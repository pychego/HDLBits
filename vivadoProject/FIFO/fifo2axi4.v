module fifo2axi4 #(
    parameter WR_AXI_BYTE_ADDR_BEGIN = 0,
    parameter WR_AXI_BYTE_ADDR_END   = 200,
    parameter RD_AXI_BYTE_ADDR_BEGIN = 0,
    parameter RD_AXI_BYTE_ADDR_END   = 200,

    parameter AXI_DATA_WIDTH = 128,
    parameter AXI_ADDR_WIDTH = 28,
    parameter AXI_ID_WIDTH   = 4,
    parameter AXI_ID         = 4'b0000,
    parameter AXI_BURST_LEN  = 8'd31     //burst length = 32
) (
    // clock reset
    input                             clk,
    input                             reset,
    // wr_fifo wr Interface
    input                             wr_addr_clr,       //sync clk
    output                            wr_fifo_rdreq,
    input      [  AXI_DATA_WIDTH-1:0] wr_fifo_rddata,
    input                             wr_fifo_empty,
    input      [                 5:0] wr_fifo_rd_cnt,
    input                             wr_fifo_rst_busy,
    // rd_fifo rd Interface
    input                             rd_addr_clr,
    output                            rd_fifo_wrreq,
    output     [  AXI_DATA_WIDTH-1:0] rd_fifo_wrdata,
    input                             rd_fifo_alfull,
    input      [                 5:0] rd_fifo_wr_cnt,
    input                             rd_fifo_rst_busy,
    // Master Interface Write Address Ports
    output     [    AXI_ID_WIDTH-1:0] m_axi_awid,
    output reg [  AXI_ADDR_WIDTH-1:0] m_axi_awaddr,
    output     [                 7:0] m_axi_awlen,
    output     [                 2:0] m_axi_awsize,
    output     [                 1:0] m_axi_awburst,
    output     [                 0:0] m_axi_awlock,
    output     [                 3:0] m_axi_awcache,
    output     [                 2:0] m_axi_awprot,
    output     [                 3:0] m_axi_awqos,
    output     [                 3:0] m_axi_awregion,
    output reg                        m_axi_awvalid,
    input                             m_axi_awready,
    // Master Interface Write Data Ports
    output     [  AXI_DATA_WIDTH-1:0] m_axi_wdata,
    output     [AXI_DATA_WIDTH/8-1:0] m_axi_wstrb,
    output reg                        m_axi_wlast,
    output reg                        m_axi_wvalid,
    input                             m_axi_wready,
    // Master Interface Write Response Ports
    input      [    AXI_ID_WIDTH-1:0] m_axi_bid,
    input      [                 1:0] m_axi_bresp,
    input                             m_axi_bvalid,
    output                            m_axi_bready,
    // Master Interface Read Address Ports
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
    // Master Interface Read Data Ports
    input      [    AXI_ID_WIDTH-1:0] m_axi_rid,
    input      [  AXI_DATA_WIDTH-1:0] m_axi_rdata,
    input      [                 1:0] m_axi_rresp,
    input                             m_axi_rlast,
    input                             m_axi_rvalid,
    output                            m_axi_rready
);



endmodule
