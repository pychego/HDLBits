module pid_ctrl (
                            input             clk,
                            input             rst_n,
                            input             start,
                            input      [ 9:0] param_kp,
                            input      [ 9:0] param_ki,
                            input      [ 9:0] param_kd,
    (*mark_DEBUG = "TRUE"*) input      [31:0] loc_data_set, // set是设置值,这个是参考波形
    (*mark_DEBUG = "TRUE"*) input      [31:0] loc_data,       //maybe come from ssi
	
    (*mark_DEBUG = "TRUE"*) output reg [15:0] control_output
);

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // count_10kHz和其他模块的count_10kHz是完全同步的,因为产生方法是一样的
    reg [3:0] count_10kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en && start) begin
            if (count_10kHz == 4'd10 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    (*Mark_debug = "TRUE"*)wire signed [9:0] param_k0;
    (*Mark_debug = "TRUE"*)wire signed [9:0] param_k1;
    (*Mark_debug = "TRUE"*)wire signed [9:0] param_k2;

    assign param_k0 = param_kp + param_ki + param_kd;
    assign param_k1 = param_kp + 2 * param_kd;
    assign param_k2 = param_kd;

    (*mark_DEBUG = "TRUE"*) reg signed [47:0] control_temp = 0;
    (*mark_DEBUG = "TRUE"*) reg signed [31:0] err = 0, err_p = 0, err_pp = 0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            err_pp <= 0;
            err_p <= 0;
            err <= 0;
            control_temp <= 0;
            control_output <= 0;
        end else if (clk_10kHz_en) begin
            case (count_10kHz)
                // 4'd0:
                // 4'd1:
                // 4'd2:
                4'd3: begin
                    err_pp <= err_p;
                end
                4'd4: begin
                    err_p <= err;
                end
                4'd5: begin
                    err <= $signed(loc_data_set) - $signed(loc_data);
                end
                4'd6: begin
                    control_temp <= param_k0 * err - param_k1 * err_p + param_k2 * err_pp;
                end
                4'd7: begin
                    control_output[14:0] <= ((control_temp[47:20] == 28'h0000000) || (control_temp[47:20] == 28'hfffffff)) ? control_temp[19:5] : control_temp[47]? 15'h0000:15'h7fff;
                    control_output[15] <= ~control_temp[47];
                end
                // 4'd8:
                // 4'd9:
            endcase
        end
    end

endmodule
