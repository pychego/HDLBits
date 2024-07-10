//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Tue Apr 23 19:30:26 2024
//Host        : liyibo running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module system_wrapper_tb ();

    reg         ap_clk;
    reg         rst_n;
    reg  [ 2:0] addra;
    reg  [31:0] dina;
    reg         wea;
    reg        ap_start;
    reg  [ 2:0] addrb;
    reg         enb;
    wire        ap_done;
    wire [31:0] doutb;

    initial begin
        ap_clk = 1'b0;
        ap_start = 1'b0;
        rst_n = 1'b0;
        addra = 3'b0;
        dina = 32'b0;
        addrb = 3'b0;
        wea = 1'b1;
        enb = 1'b0;
        #15 rst_n = 1'b1;
    end

    // 100Mhz
    always #5 ap_clk = ~ap_clk;

    initial begin
        #1000000 $finish;
    end

    always @(posedge ap_clk or negedge rst_n) begin
        if (~rst_n) begin
            addra <= 3'b0;
            addrb <= 3'b0;
        end else begin
            addra <= addra + 3'b1;
            addrb <= addrb + 3'b1;
        end
    end

    // 根据addra的值确定dina的值
    always @(*) begin
        case (addra)
            3'b000:  dina = 32'd584536;
            3'b001:  dina = 32'd503413;
            3'b010:  dina = 32'd522402;
            3'b011:  dina = 501538;
            3'b100:  dina = 487386;
            3'b101:  dina = 542602;
            3'b110:  ap_start = 1'b1;
            default: dina = 0;
        endcase
    end

    always @(negedge ap_done) begin
        enb = 1'b1;
    end



    wire [2:0]pose_address0;
    wire [31:0] pose_d0;
    system system_i (
        .addra        (addra),
        .addrb        (addrb),
        .ap_clk       (ap_clk),
        .ap_done      (ap_done),
        .ap_rst       (~rst_n),
        .ap_start     (ap_start),
        .dina         (dina),
        .doutb        (doutb),
        .enb          (enb),
        .pose_address0(pose_address0),
        .pose_d0      (pose_d0),
        .wea          (wea)
    );
endmodule
