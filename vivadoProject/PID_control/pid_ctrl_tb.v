`timescale 1ns / 1ps

module pid_ctrl_tb ();

    reg         clk;
    reg         rst_n;
    reg         start;
    reg  [31:0] param_kp = 131072;
    reg  [31:0] param_ki = 0;
    reg  [31:0] param_kd = 0;
    wire [31:0] data_target;
    wire [31:0] data_real;
    wire [15:0] control_output;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        #15 rst_n = 1'b1;
        #100 start = 1'b1;
    end

    // 10MHz
    always #5 clk = ~clk;

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // rom_clk 20kHz
    reg rom_clk;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rom_clk <= 4'd0;
        else if (cnt == 14'd1) rom_clk <= 1'b1;
        else if (cnt == 14'd5001) rom_clk <= 1'b0;
        else rom_clk <= rom_clk;
    end

    // One round of count_10kHz is 1ms, which is a control cycle
    reg [3:0] count_10kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en) begin
            if (count_10kHz == 4'd10 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    reg        rom_en;
    reg [31:0] rom_addr;
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

    // data_target change every 1ms
    blk_mem_gen_0 u_blk_mem_gen_0 (
        .clka (rom_clk),     // input wire clka
        .ena  (rom_en),      // input wire ena
        .addra(rom_addr),    // input wire [9 : 0] addra
        .douta(data_target)  // output wire [31 : 0] douta
    );


    assign data_real = 140000;

    initial begin
        #3000000 $finish;
    end

    pid_ctrl u_pid_ctrl (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (start),
        .param_kp      (param_kp),
        .param_ki      (param_ki),
        .param_kd      (param_kd),
        .data_target   (data_target),
        .data_real     (data_real),
        .control_output(control_output)
    );

endmodule
