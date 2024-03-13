// this module is used to opearte the block memory to read data form it
module my_ROM_controller (
                            input             clk,
                            input             rst_n,
                            input             start,
                            output reg        rom_en,
    (*mark_DEBUG = "TRUE"*) output reg [31:0] rom_addr,
                            output reg        rom_clk
);

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // assign rom_clk = clk_10kHz_en;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rom_clk <= 4'd0;
        else if (cnt == 14'd1) rom_clk <= 1'b1;
        else if (cnt == 14'd5001) rom_clk <= 1'b0;
        else rom_clk <= rom_clk;
    end

    reg [3:0]count_10kHz; 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en && start) begin
            if (count_10kHz == 4'd10 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_en   <= 1'b0;
            rom_addr <= 32'd0;
        end else if (clk_10kHz_en) begin
            case (count_10kHz)
                4'd1: begin
                    rom_en <= 1'b1;
                end
                4'd2: begin
                    rom_en <= 1'b0;
                end
                4'd9: begin
                    if (rom_addr >= 32'd1000 - 32'd1) rom_addr <= 32'd0;
                    else rom_addr <= rom_addr + 1'b1;
                end
                default: begin
                    rom_en <= 1'b0;
                end
            endcase
        end
    end

endmodule
