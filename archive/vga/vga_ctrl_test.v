/*
    在7020上验证，输出RGB为444 vga_HS vga_VS 
*/

`include "vga_parameter.v"

module vga_ctrl_test (
    input         clk,
    input         reset_n,
    output [11:0] vga_RGB,
    output        vga_HS,
    output        vga_VS
);

    reg  [11:0] disp_data;
    wire [31:0] hcount;
    wire [31:0] vcount;
    wire        clk25m;
    wire        vga_BLK;
    wire        data_request;

    // 锁相环 将100MHz降到25MHz
    vga_pll instance_name (
        // Clock out ports
        .clk_out1(clk25m),
        // Clock in ports
        .clk_in1 (clk)
    );


    localparam 
        BLACK = 12'h000,
        BLUE = 12'h00f,
        RED = 12'hf00,
        PURPPLE = 12'hf0f,
        GREEN = 12'h0f0,
        CYAN = 12'h0ff,
        YELLOW = 12'hff0,
        WHITE = 12'hfff;

    localparam 
        r0_c0 = BLACK,
        r0_c1 = BLUE,
        r1_c0 = RED,
        r1_c1 = PURPPLE,
        r2_c0 = GREEN,
        r2_c1 = CYAN,
        r3_c0 = YELLOW,
        r3_c1 = WHITE;

    parameter DISP_WIDTH = `H_Data_Time;
    parameter DISP_HEIGHT = `V_Data_Time;

    assign c0_act = (hcount >= 0) && (hcount < DISP_WIDTH / 2);
    assign c1_act = (hcount >= DISP_WIDTH / 2) && (hcount < DISP_WIDTH);

    assign r0_act = (vcount >= 0) && (vcount < DISP_HEIGHT / 4);
    assign r1_act = (vcount >= DISP_HEIGHT / 4) && (vcount < DISP_HEIGHT / 2);
    assign r2_act = (vcount >= DISP_HEIGHT / 2) && (vcount < DISP_HEIGHT * 3 / 4);
    assign r3_act = (vcount >= DISP_HEIGHT * 3 / 4) && (vcount < DISP_HEIGHT);

    wire r0_c0_act = r0_act && c0_act;
    wire r0_c1_act = r0_act && c1_act;
    wire r1_c0_act = r1_act && c0_act;
    wire r1_c1_act = r1_act && c1_act;
    wire r2_c0_act = r2_act && c0_act;
    wire r2_c1_act = r2_act && c1_act;
    wire r3_c0_act = r3_act && c0_act;
    wire r3_c1_act = r3_act && c1_act;

    always @(*) begin
        case ({
            r0_c0_act, r0_c1_act, r1_c0_act, r1_c1_act, r2_c0_act, r2_c1_act, r3_c0_act, r3_c1_act
        })
            8'b00000001: disp_data <= r0_c0;
            8'b00000010: disp_data <= r0_c1;
            8'b00000100: disp_data <= r1_c0;
            8'b00001000: disp_data <= r1_c1;
            8'b00010000: disp_data <= r2_c0;
            8'b00100000: disp_data <= r2_c1;
            8'b01000000: disp_data <= r3_c0;
            8'b10000000: disp_data <= r3_c1;
            default: ;
        endcase
    end


    vga_ctrl vga_ctrl_inst (
        .clk         (clk25m),
        .reset_n     (reset_n),
        .data        (disp_data),
        .data_request(data_request),  // output
        .hcount      (hcount),
        .vcount      (vcount),
        .vga_HS      (vga_HS),
        .vga_VS      (vga_VS),
        .vga_BLK     (vga_BLK),
        .vga_RGB     (vga_RGB)
    );

endmodule
