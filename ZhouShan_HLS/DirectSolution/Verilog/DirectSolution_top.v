module DirectSolution_top (
    input  wire        clk,
    input  wire        rst_n,
    output wire [31:0] lengths_q0,
    output wire        lengths_ce0,
    output wire        pose_ce0,
    output wire        pose_we0,
    output wire        ap_start,
    output wire        ap_done,
    output wire        ap_idle,
    output wire        ap_ready,
    output wire [ 2:0] lengths_address0,
    output wire [ 2:0] pose_address0,
    output wire [31:0] pose_d0
);

    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            cnt <= 2'b00;
        end else begin
            if (cnt[1] == 1'b0) begin
                cnt <= cnt + 1;
            end
        end
    end

    assign ap_start = cnt[1];

    blk_mem_gen_0 blk_mem_gen_0 (
        .clka (clk),               // input wire clka
        .ena  (lengths_ce0),       // input wire ena
        .addra(lengths_address0),  // input wire [2 : 0] addra
        .douta(lengths_q0)         // output wire [31 : 0] douta
    );
    DirectSolution_0 DirectSolution_0 (
        .lengths_ce0     (lengths_ce0),       // output wire lengths_ce0
        .pose_ce0        (pose_ce0),          // output wire pose_ce0
        .pose_we0        (pose_we0),          // output wire pose_we0
        .ap_clk          (clk),               // input wire ap_clk
        .ap_rst          (~rst_n),            // input wire ap_rst
        .ap_start        (ap_start),          // input wire ap_start
        .ap_done         (ap_done),           // output wire ap_done
        .ap_idle         (ap_idle),           // output wire ap_idle
        .ap_ready        (ap_ready),          // output wire ap_ready
        .lengths_address0(lengths_address0),  // output wire [2 : 0] lengths_address0
        .lengths_q0      (lengths_q0),        // input wire [31 : 0] lengths_q0
        .pose_address0   (pose_address0),     // output wire [2 : 0] pose_address0
        .pose_d0         (pose_d0)            // output wire [31 : 0] pose_d0
    );
endmodule
