`timescale 1 ns / 1 ps
/*  2024.12.17
    这个仅供学习PS通过AXI总线传输到PL, 上机还是要用V1版本, 这个V2主要是减少param的数量,只要两个
*/
module param_distributor_v2_0 #(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line


    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 9
) (
    // Users to add ports here
    input  wire                            param_change_flag,
    output wire [C_S00_AXI_DATA_WIDTH-1:0] param0,
    output wire [C_S00_AXI_DATA_WIDTH-1:0] param1,
    // User ports ends
    // Do not modify the ports beyond this line


    // Ports of Axi Slave Bus Interface S00_AXI
    input  wire                                  s00_axi_aclk,
    input  wire                                  s00_axi_aresetn,
    // 写地址通道
    input  wire [    C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input  wire [                         2 : 0] s00_axi_awprot,
    input  wire                                  s00_axi_awvalid,
    output wire                                  s00_axi_awready,
    // 写数据通道
    input  wire [    C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input  wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input  wire                                  s00_axi_wvalid,
    output wire                                  s00_axi_wready,
    // 写响应通道
    output wire [                         1 : 0] s00_axi_bresp,
    output wire                                  s00_axi_bvalid,
    input  wire                                  s00_axi_bready,
    // 读地址通道
    input  wire [    C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input  wire [                         2 : 0] s00_axi_arprot,
    input  wire                                  s00_axi_arvalid,
    output wire                                  s00_axi_arready,
    // 读数据通道
    output wire [    C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [                         1 : 0] s00_axi_rresp,
    output wire                                  s00_axi_rvalid,
    input  wire                                  s00_axi_rready
);
    // Instantiation of Axi Bus Interface S00_AXI
    param_distributor_v1_0_S00_AXI #(
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) param_distributor_v1_0_S00_AXI_inst (
        .param_change_flag(param_change_flag),
        .param0           (param0),
        .param1           (param1),
        .S_AXI_ACLK       (s00_axi_aclk),
        .S_AXI_ARESETN    (s00_axi_aresetn),
        .S_AXI_AWADDR     (s00_axi_awaddr),
        .S_AXI_AWPROT     (s00_axi_awprot),
        .S_AXI_AWVALID    (s00_axi_awvalid),
        .S_AXI_AWREADY    (s00_axi_awready),
        .S_AXI_WDATA      (s00_axi_wdata),
        .S_AXI_WSTRB      (s00_axi_wstrb),
        .S_AXI_WVALID     (s00_axi_wvalid),
        .S_AXI_WREADY     (s00_axi_wready),
        .S_AXI_BRESP      (s00_axi_bresp),
        .S_AXI_BVALID     (s00_axi_bvalid),
        .S_AXI_BREADY     (s00_axi_bready),
        .S_AXI_ARADDR     (s00_axi_araddr),
        .S_AXI_ARPROT     (s00_axi_arprot),
        .S_AXI_ARVALID    (s00_axi_arvalid),
        .S_AXI_ARREADY    (s00_axi_arready),
        .S_AXI_RDATA      (s00_axi_rdata),
        .S_AXI_RRESP      (s00_axi_rresp),
        .S_AXI_RVALID     (s00_axi_rvalid),
        .S_AXI_RREADY     (s00_axi_rready)
    );

    // Add user logic here

    // User logic ends

endmodule
