// what is the position of this module in the entire design?
module SSI_gray_driver (
                            input clk,
                            input rst_n,
    (*mark_DEBUG = "TRUE"*) input SSI_data,            // come from sensor or MAX3077

    (*mark_DEBUG = "TRUE"*) output reg        SSI_clk, // output to sensor
    (*mark_DEBUG = "TRUE"*) output     [24:0] loc_data // 25bit
);

    // 1MHz
    reg [7:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 8'd0;
        else if (cnt == 8'd99) cnt <= 8'd0;
        else cnt <= cnt + 1'b1;
    end

    (*mark_DEBUG = "TRUE"*) wire clk_1MHz_en;
    assign clk_1MHz_en = (cnt == 8'd1);

    // count_1MHz from 0 to 72, 73 states in total
    (*mark_DEBUG = "TRUE"*) reg [7:0] count_1MHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_1MHz <= 8'd0;
        else if (clk_1MHz_en) begin
            count_1MHz <= count_1MHz + 1'b1;
            if (count_1MHz > 8'd71) count_1MHz <= 8'd0;
        end
    end

    // SSI_clk's frequency is 1Mhz / 2 = 500kHz
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_clk <= 1'b1;
        else if (clk_1MHz_en) begin
            if (count_1MHz < 20) SSI_clk <= 1'b1;
            else if (count_1MHz == 20) SSI_clk <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz <= 71) SSI_clk <= ~SSI_clk;
            else SSI_clk <= SSI_clk;
        end
    end

    // SSI_flag is used to indicate the SSI_clk is in the period of 22~71
    (*mark_DEBUG = "TRUE"*) reg SSI_flag;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) SSI_flag <= 1'b0;
        else if (clk_1MHz_en) begin
            if (count_1MHz <= 20) SSI_flag <= 1'b0;
            else if (count_1MHz > 20 && count_1MHz < 71) SSI_flag <= 1'b1;
            else if (count_1MHz == 71) SSI_flag <= 1'b0;
            else SSI_flag <= 1'b0;
        end
    end


    // 25 SSI_clk neg edge
    (*mark_DEBUG = "TRUE"*) reg [7:0] count_SSIclk;
    always @(negedge SSI_clk or negedge rst_n) begin
        if (!rst_n) count_SSIclk <= 8'd0;
        else if (SSI_flag) count_SSIclk <= count_SSIclk + 1'b1;
        else if (count_SSIclk == 8'd25) count_SSIclk <= 8'd0;
    end

    (*mark_DEBUG = "TRUE"*)reg [24:0] data_buffer;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_gray;
    // SSI_data in the negedge od SSI_clk id stable
    always @(negedge SSI_clk or negedge rst_n) begin
        if (!rst_n) begin
            loc_data_gray <= 25'd0;
            data_buffer   <= 25'd0;
        end else if (SSI_flag) begin
            data_buffer <= {data_buffer[23:0], SSI_data};
        end else if (count_SSIclk == 8'd25) begin
            // time is count_SSIclk from 25 to 0
            loc_data_gray <= data_buffer;
            // loc_data[0] <= data_buffer[0]^loc_data[1];
            // loc_data[1] <= data_buffer[1]^loc_data[2];
            // loc_data[2] <= data_buffer[2]^loc_data[3];
            // loc_data[3] <= data_buffer[3]^loc_data[4];
            // loc_data[4] <= data_buffer[4]^loc_data[5];
            // loc_data[5] <= data_buffer[5]^loc_data[6];
            // loc_data[6] <= data_buffer[6]^loc_data[7];
            // loc_data[7] <= data_buffer[7]^loc_data[8];
            // loc_data[8] <= data_buffer[8]^loc_data[9];
            // loc_data[9] <= data_buffer[9]^loc_data[10];
            // loc_data[10] <= data_buffer[10]^loc_data[11];
            // loc_data[11] <= data_buffer[11]^loc_data[12];
            // loc_data[12] <= data_buffer[12]^loc_data[13];
            // loc_data[13] <= data_buffer[13]^loc_data[14];
            // loc_data[14] <= data_buffer[14]^loc_data[15];
            // loc_data[15] <= data_buffer[15]^loc_data[16];
            // loc_data[16] <= data_buffer[16]^loc_data[17];
            // loc_data[17] <= data_buffer[17]^loc_data[18];
            // loc_data[18] <= data_buffer[18]^loc_data[19];
            // loc_data[19] <= data_buffer[19]^loc_data[20];
            // loc_data[20] <= data_buffer[20]^loc_data[21];
            // loc_data[21] <= data_buffer[21]^loc_data[22];
            // loc_data[22] <= data_buffer[22]^loc_data[23];
            // loc_data[23] <= data_buffer[23]^loc_data[24];
            // loc_data[24] <= data_buffer[24];
            data_buffer   <= 25'd0;
        end
    end

    reg [ 4:0] i = 0;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_binary;
    (*mark_DEBUG = "TRUE"*)reg [24:0] loc_data_binary_r;

    // ???
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) i <= 5'd0;
        else begin
            i <= i + 1'b1;
            case (i)                    // gray格雷码 to binary principle
                // Force Serial
                5'd0: loc_data_binary[24] <= loc_data_gray[24];
                5'd1: loc_data_binary[23] <= loc_data_binary[24] ^ loc_data_gray[23];
                5'd2: loc_data_binary[22] <= loc_data_binary[23] ^ loc_data_gray[22];
                5'd3: loc_data_binary[21] <= loc_data_binary[22] ^ loc_data_gray[21];
                5'd4: loc_data_binary[20] <= loc_data_binary[21] ^ loc_data_gray[20];
                5'd5: loc_data_binary[19] <= loc_data_binary[20] ^ loc_data_gray[19];
                5'd6: loc_data_binary[18] <= loc_data_binary[19] ^ loc_data_gray[18];
                5'd7: loc_data_binary[17] <= loc_data_binary[18] ^ loc_data_gray[17];
                5'd8: loc_data_binary[16] <= loc_data_binary[17] ^ loc_data_gray[16];
                5'd9: loc_data_binary[15] <= loc_data_binary[16] ^ loc_data_gray[15];
                5'd10: loc_data_binary[14] <= loc_data_binary[15] ^ loc_data_gray[14];
                5'd11: loc_data_binary[13] <= loc_data_binary[14] ^ loc_data_gray[13];
                5'd12: loc_data_binary[12] <= loc_data_binary[13] ^ loc_data_gray[12];
                5'd13: loc_data_binary[11] <= loc_data_binary[12] ^ loc_data_gray[11];
                5'd14: loc_data_binary[10] <= loc_data_binary[11] ^ loc_data_gray[10];
                5'd15: loc_data_binary[9] <= loc_data_binary[10] ^ loc_data_gray[9];
                5'd16: loc_data_binary[8] <= loc_data_binary[9] ^ loc_data_gray[8];
                5'd17: loc_data_binary[7] <= loc_data_binary[8] ^ loc_data_gray[7];
                5'd18: loc_data_binary[6] <= loc_data_binary[7] ^ loc_data_gray[6];
                5'd19: loc_data_binary[5] <= loc_data_binary[6] ^ loc_data_gray[5];
                5'd20: loc_data_binary[4] <= loc_data_binary[5] ^ loc_data_gray[4];
                5'd21: loc_data_binary[3] <= loc_data_binary[4] ^ loc_data_gray[3];
                5'd22: loc_data_binary[2] <= loc_data_binary[3] ^ loc_data_gray[2];
                5'd23: loc_data_binary[1] <= loc_data_binary[2] ^ loc_data_gray[1];
                5'd24: loc_data_binary[0] <= loc_data_binary[1] ^ loc_data_gray[0];
                5'd25: begin
                    loc_data_binary_r <= loc_data_binary;
                    i <= 5'd0;
                end
                default: i <= 5'd0;
            endcase
        end
    end

    assign loc_data = loc_data_binary_r;


endmodule
