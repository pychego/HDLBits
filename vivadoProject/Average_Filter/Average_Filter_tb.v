`timescale 1ns / 1ps

module Average_Filter_tb ();

    reg                clk;
    reg                rst_n;
    reg  signed [15:0] din;
    wire signed [15:0] dout;

    wire signed [15:0] data_sine_wave;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        din   = $random() % 1000;
        #15 rst_n = 1'b1;
    end

    always #5 clk = ~clk;  //100MHz


    reg [15:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 16'd0;
        else if (cnt == 16'd49999) cnt <= 16'd0;
        else cnt <= cnt + 1'b1;
    end
    reg clk_1kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) clk_1kHz <= 1'b0;
        else if (cnt == 16'd25000) clk_1kHz <= ~clk_1kHz;
    end
    reg [7:0] table_addr;
    always @(posedge clk_1kHz or negedge rst_n) begin
        if (!rst_n) table_addr <= 'd0;
        else table_addr <= table_addr + 1'b1;
    end

    sine_table sine_table_uut (
        .table_addr(table_addr),
        .sine      (data_sine_wave)
    );
    // always #5 clk = ~clk;  //100MHz
    always #5000 din = data_sine_wave + $random() % 1000;  
    Average_Filter Average_Filter_uut (
        .clk  (clk),
        .rst_n(rst_n),
        .din  (din),
        .dout (dout)
    );

endmodule



/**************************************************
module: sine_table
**************************************************/
module sine_table (
    input             [ 7:0] table_addr,
    output reg signed [15:0] sine
);

    always @(table_addr)
        case (table_addr)
            8'd0:   sine = 16'h0000;
            8'd1:   sine = 16'h0192;
            8'd2:   sine = 16'h0324;
            8'd3:   sine = 16'h04B5;
            8'd4:   sine = 16'h0646;
            8'd5:   sine = 16'h07D6;
            8'd6:   sine = 16'h0964;
            8'd7:   sine = 16'h0AF1;
            8'd8:   sine = 16'h0C7C;
            8'd9:   sine = 16'h0E06;
            8'd10:  sine = 16'h0F8D;
            8'd11:  sine = 16'h1112;
            8'd12:  sine = 16'h1294;
            8'd13:  sine = 16'h1413;
            8'd14:  sine = 16'h1590;
            8'd15:  sine = 16'h1709;
            8'd16:  sine = 16'h187E;
            8'd17:  sine = 16'h19EF;
            8'd18:  sine = 16'h1B5D;
            8'd19:  sine = 16'h1CC6;
            8'd20:  sine = 16'h1E2B;
            8'd21:  sine = 16'h1F8C;
            8'd22:  sine = 16'h20E7;
            8'd23:  sine = 16'h223D;
            8'd24:  sine = 16'h238E;
            8'd25:  sine = 16'h24DA;
            8'd26:  sine = 16'h2620;
            8'd27:  sine = 16'h2760;
            8'd28:  sine = 16'h289A;
            8'd29:  sine = 16'h29CE;
            8'd30:  sine = 16'h2AFB;
            8'd31:  sine = 16'h2C21;
            8'd32:  sine = 16'h2D41;
            8'd33:  sine = 16'h2E5A;
            8'd34:  sine = 16'h2F6C;
            8'd35:  sine = 16'h3076;
            8'd36:  sine = 16'h3179;
            8'd37:  sine = 16'h3274;
            8'd38:  sine = 16'h3368;
            8'd39:  sine = 16'h3453;
            8'd40:  sine = 16'h3537;
            8'd41:  sine = 16'h3612;
            8'd42:  sine = 16'h36E5;
            8'd43:  sine = 16'h37B0;
            8'd44:  sine = 16'h3871;
            8'd45:  sine = 16'h392B;
            8'd46:  sine = 16'h39DB;
            8'd47:  sine = 16'h3A82;
            8'd48:  sine = 16'h3B21;
            8'd49:  sine = 16'h3BB6;
            8'd50:  sine = 16'h3C42;
            8'd51:  sine = 16'h3CC5;
            8'd52:  sine = 16'h3D3F;
            8'd53:  sine = 16'h3DAF;
            8'd54:  sine = 16'h3E15;
            8'd55:  sine = 16'h3E72;
            8'd56:  sine = 16'h3EC5;
            8'd57:  sine = 16'h3F0F;
            8'd58:  sine = 16'h3F4F;
            8'd59:  sine = 16'h3F85;
            8'd60:  sine = 16'h3FB1;
            8'd61:  sine = 16'h3FD4;
            8'd62:  sine = 16'h3FEC;
            8'd63:  sine = 16'h3FFB;
            8'd64:  sine = 16'h4000;
            8'd65:  sine = 16'h3FFB;
            8'd66:  sine = 16'h3FEC;
            8'd67:  sine = 16'h3FD4;
            8'd68:  sine = 16'h3FB1;
            8'd69:  sine = 16'h3F85;
            8'd70:  sine = 16'h3F4F;
            8'd71:  sine = 16'h3F0F;
            8'd72:  sine = 16'h3EC5;
            8'd73:  sine = 16'h3E72;
            8'd74:  sine = 16'h3E15;
            8'd75:  sine = 16'h3DAF;
            8'd76:  sine = 16'h3D3F;
            8'd77:  sine = 16'h3CC5;
            8'd78:  sine = 16'h3C42;
            8'd79:  sine = 16'h3BB6;
            8'd80:  sine = 16'h3B21;
            8'd81:  sine = 16'h3A82;
            8'd82:  sine = 16'h39DB;
            8'd83:  sine = 16'h392B;
            8'd84:  sine = 16'h3871;
            8'd85:  sine = 16'h37B0;
            8'd86:  sine = 16'h36E5;
            8'd87:  sine = 16'h3612;
            8'd88:  sine = 16'h3537;
            8'd89:  sine = 16'h3453;
            8'd90:  sine = 16'h3368;
            8'd91:  sine = 16'h3274;
            8'd92:  sine = 16'h3179;
            8'd93:  sine = 16'h3076;
            8'd94:  sine = 16'h2F6C;
            8'd95:  sine = 16'h2E5A;
            8'd96:  sine = 16'h2D41;
            8'd97:  sine = 16'h2C21;
            8'd98:  sine = 16'h2AFB;
            8'd99:  sine = 16'h29CE;
            8'd100: sine = 16'h289A;
            8'd101: sine = 16'h2760;
            8'd102: sine = 16'h2620;
            8'd103: sine = 16'h24DA;
            8'd104: sine = 16'h238E;
            8'd105: sine = 16'h223D;
            8'd106: sine = 16'h20E7;
            8'd107: sine = 16'h1F8C;
            8'd108: sine = 16'h1E2B;
            8'd109: sine = 16'h1CC6;
            8'd110: sine = 16'h1B5D;
            8'd111: sine = 16'h19EF;
            8'd112: sine = 16'h187E;
            8'd113: sine = 16'h1709;
            8'd114: sine = 16'h1590;
            8'd115: sine = 16'h1413;
            8'd116: sine = 16'h1294;
            8'd117: sine = 16'h1112;
            8'd118: sine = 16'h0F8D;
            8'd119: sine = 16'h0E06;
            8'd120: sine = 16'h0C7C;
            8'd121: sine = 16'h0AF1;
            8'd122: sine = 16'h0964;
            8'd123: sine = 16'h07D6;
            8'd124: sine = 16'h0646;
            8'd125: sine = 16'h04B5;
            8'd126: sine = 16'h0324;
            8'd127: sine = 16'h0192;
            8'd128: sine = 16'h0000;
            8'd129: sine = 16'hFE6E;
            8'd130: sine = 16'hFCDC;
            8'd131: sine = 16'hFB4B;
            8'd132: sine = 16'hF9BA;
            8'd133: sine = 16'hF82A;
            8'd134: sine = 16'hF69C;
            8'd135: sine = 16'hF50F;
            8'd136: sine = 16'hF384;
            8'd137: sine = 16'hF1FA;
            8'd138: sine = 16'hF073;
            8'd139: sine = 16'hEEEE;
            8'd140: sine = 16'hED6C;
            8'd141: sine = 16'hEBED;
            8'd142: sine = 16'hEA70;
            8'd143: sine = 16'hE8F7;
            8'd144: sine = 16'hE782;
            8'd145: sine = 16'hE611;
            8'd146: sine = 16'hE4A3;
            8'd147: sine = 16'hE33A;
            8'd148: sine = 16'hE1D5;
            8'd149: sine = 16'hE074;
            8'd150: sine = 16'hDF19;
            8'd151: sine = 16'hDDC3;
            8'd152: sine = 16'hDC72;
            8'd153: sine = 16'hDB26;
            8'd154: sine = 16'hD9E0;
            8'd155: sine = 16'hD8A0;
            8'd156: sine = 16'hD766;
            8'd157: sine = 16'hD632;
            8'd158: sine = 16'hD505;
            8'd159: sine = 16'hD3DF;
            8'd160: sine = 16'hD2BF;
            8'd161: sine = 16'hD1A6;
            8'd162: sine = 16'hD094;
            8'd163: sine = 16'hCF8A;
            8'd164: sine = 16'hCE87;
            8'd165: sine = 16'hCD8C;
            8'd166: sine = 16'hCC98;
            8'd167: sine = 16'hCBAD;
            8'd168: sine = 16'hCAC9;
            8'd169: sine = 16'hC9EE;
            8'd170: sine = 16'hC91B;
            8'd171: sine = 16'hC850;
            8'd172: sine = 16'hC78F;
            8'd173: sine = 16'hC6D5;
            8'd174: sine = 16'hC625;
            8'd175: sine = 16'hC57E;
            8'd176: sine = 16'hC4DF;
            8'd177: sine = 16'hC44A;
            8'd178: sine = 16'hC3BE;
            8'd179: sine = 16'hC33B;
            8'd180: sine = 16'hC2C1;
            8'd181: sine = 16'hC251;
            8'd182: sine = 16'hC1EB;
            8'd183: sine = 16'hC18E;
            8'd184: sine = 16'hC13B;
            8'd185: sine = 16'hC0F1;
            8'd186: sine = 16'hC0B1;
            8'd187: sine = 16'hC07B;
            8'd188: sine = 16'hC04F;
            8'd189: sine = 16'hC02C;
            8'd190: sine = 16'hC014;
            8'd191: sine = 16'hC005;
            8'd192: sine = 16'hC000;
            8'd193: sine = 16'hC005;
            8'd194: sine = 16'hC014;
            8'd195: sine = 16'hC02C;
            8'd196: sine = 16'hC04F;
            8'd197: sine = 16'hC07B;
            8'd198: sine = 16'hC0B1;
            8'd199: sine = 16'hC0F1;
            8'd200: sine = 16'hC13B;
            8'd201: sine = 16'hC18E;
            8'd202: sine = 16'hC1EB;
            8'd203: sine = 16'hC251;
            8'd204: sine = 16'hC2C1;
            8'd205: sine = 16'hC33B;
            8'd206: sine = 16'hC3BE;
            8'd207: sine = 16'hC44A;
            8'd208: sine = 16'hC4DF;
            8'd209: sine = 16'hC57E;
            8'd210: sine = 16'hC625;
            8'd211: sine = 16'hC6D5;
            8'd212: sine = 16'hC78F;
            8'd213: sine = 16'hC850;
            8'd214: sine = 16'hC91B;
            8'd215: sine = 16'hC9EE;
            8'd216: sine = 16'hCAC9;
            8'd217: sine = 16'hCBAD;
            8'd218: sine = 16'hCC98;
            8'd219: sine = 16'hCD8C;
            8'd220: sine = 16'hCE87;
            8'd221: sine = 16'hCF8A;
            8'd222: sine = 16'hD094;
            8'd223: sine = 16'hD1A6;
            8'd224: sine = 16'hD2BF;
            8'd225: sine = 16'hD3DF;
            8'd226: sine = 16'hD505;
            8'd227: sine = 16'hD632;
            8'd228: sine = 16'hD766;
            8'd229: sine = 16'hD8A0;
            8'd230: sine = 16'hD9E0;
            8'd231: sine = 16'hDB26;
            8'd232: sine = 16'hDC72;
            8'd233: sine = 16'hDDC3;
            8'd234: sine = 16'hDF19;
            8'd235: sine = 16'hE074;
            8'd236: sine = 16'hE1D5;
            8'd237: sine = 16'hE33A;
            8'd238: sine = 16'hE4A3;
            8'd239: sine = 16'hE611;
            8'd240: sine = 16'hE782;
            8'd241: sine = 16'hE8F7;
            8'd242: sine = 16'hEA70;
            8'd243: sine = 16'hEBED;
            8'd244: sine = 16'hED6C;
            8'd245: sine = 16'hEEEE;
            8'd246: sine = 16'hF073;
            8'd247: sine = 16'hF1FA;
            8'd248: sine = 16'hF384;
            8'd249: sine = 16'hF50F;
            8'd250: sine = 16'hF69C;
            8'd251: sine = 16'hF82A;
            8'd252: sine = 16'hF9BA;
            8'd253: sine = 16'hFB4B;
            8'd254: sine = 16'hFCDC;
            8'd255: sine = 16'hFE6E;
        endcase
endmodule
