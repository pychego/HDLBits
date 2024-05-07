`timescale 1ns / 1ps

module system_wrapper_tb ();
    reg         clk;
    reg         rst_n;
    reg         ap_start;
    reg  [ 2:0] addra;
    reg  [31:0] dina;
    reg         wea;

    wire [ 2:0] pose3_address0;
    wire [31:0] pose3_d0;
    wire        pose3_we0;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        #15 rst_n = 1'b1;
    end

    always #5 clk = ~clk;

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    // 每次0.1ms 来一个clk_10kHz_en脉冲
    (*mark_DEBUG = "TRUE"*) wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // 产生0~9的计数count_10kHz, 每个状态持续0.1ms
    (*mark_DEBUG = "TRUE"*) reg [3:0] count_10kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en) begin
            if (count_10kHz == 4'd4 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    // 记录1ms的个数 count_1khz
    reg [3:0] count_1kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_1kHz <= 4'd0;
        end else if (count_10kHz == 4'd0 && clk_10kHz_en) begin
            count_1kHz <= count_1kHz + 1'b1;
        end
    end

    // 操作wea
    always @(posedge clk or negedge !rst_n) begin
        if (!rst_n) wea <= 1'b0;
        else if (count_10kHz == 1) begin
            wea <= 1'b1;
        end else wea <= 1'b0;
    end

    // 每次状态为0, 且有高脉冲时进行初始化
    reg       flag;  // 用来标记addra是否走完了一次0~5
    reg [4:0] count_for_addra;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || (count_10kHz == 4'd0 && clk_10kHz_en)) begin
            ap_start <= 1'b0;
            flag <= 1'b0;
            count_for_addra <= 0;
        end else begin
            if (count_10kHz == 1 && flag == 1'b0) begin
                if (count_for_addra == 9) begin
                    flag <= 1'b1;
                end else begin
                    count_for_addra <= count_for_addra + 1'b1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (count_1kHz == 4'd1) begin
            case (count_for_addra)
                // dina  29.9174	38.7245	38.7654	30.5619	30.6836	32.7377
                // 得到 pose2 -10.4348, -4.6101, 36.1813, 4.7796, -3.4395, -3.7206
                // 此时 platform在最理想位置
                1: begin
                    addra <= 3'b000;
                    dina  <= 299174;
                end
                2: begin
                    addra <= 3'b001;
                    dina  <= 387245;
                end
                3: begin
                    addra <= 3'b010;
                    dina  <= 387654;
                end
                4: begin
                    addra <= 3'b011;
                    dina  <= 305619;
                end
                5: begin
                    addra <= 3'b100;
                    dina  <= 306836;
                end
                6: begin
                    addra <= 3'b101;
                    dina <= 327377;
                    ap_start <= 1'b1;
                end
                9: begin
                    ap_start <= 1'b0;
                end
                default: ;
            endcase
        end else if (count_1kHz == 4'd2) begin
            case (count_for_addra)
                // dina 29.6380	37.0097	36.9845	30.5498	30.5232	31.7569
                // pose2 -8, -4, 36, 4, -3, -3
                // 此时platform位姿  2.3730  0.7484  96.6228  -0.8054 0.3877 0.7671
                1: begin
                    addra <= 3'b000;
                    dina  <= 296380;
                end
                2: begin
                    addra <= 3'b001;
                    dina  <= 370097;
                end
                3: begin
                    addra <= 3'b010;
                    dina  <= 369845;
                end
                4: begin
                    addra <= 3'b011;
                    dina  <= 305498;
                end
                5: begin
                    addra <= 3'b100;
                    dina  <= 305232;
                end
                6: begin
                    addra <= 3'b101;
                    dina <= 317569;
                    ap_start <= 1'b1;
                end
                9: begin
                    ap_start <= 1'b0;
                end
                default: ;
            endcase
        end
    end

    system_wrapper system_i (
        .addra         (addra),
        .ap_clk        (clk),
        .ap_rst        (~rst_n),
        .ap_start      (ap_start),
        .dina          (dina),
        .pose3_address0(pose3_address0),
        .pose3_d0      (pose3_d0),
        .pose3_we0     (pose3_we0),
        .wea           (wea)
    );
endmodule