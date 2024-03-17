module my_BRAM_rd_controller(
	input clk,
	input rst_n,
	input start,
	(*mark_DEBUG = "TRUE"*)output reg bram_en,
	(*mark_DEBUG = "TRUE"*)output reg [31:0] bram_addr,
	(*mark_DEBUG = "TRUE"*)output reg bram_clk,
	input [31:0] bram_rd_count			//鐢ㄦ潵璁剧疆鍙傝�冩尝褰㈢殑鐐规暟
);

reg [13:0] cnt;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt <= 14'd0;
	else if(cnt == 14'd9999)
		cnt <= 14'd0;
	else
		cnt <= cnt + 1'b1;
end

(*mark_DEBUG = "TRUE"*)wire clk_10kHz_en;
assign clk_10kHz_en = (cnt == 14'd1);

// assign bram_clk = clk_10kHz_en;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		bram_clk <= 4'd0;
	else if(cnt == 14'd1)
		bram_clk <= 1'b1;
	else if(cnt == 14'd5001)
		bram_clk <= 1'b0;
	else
		bram_clk <= bram_clk;
end

(*mark_DEBUG = "TRUE"*)reg [3:0]count_10kHz; // 鏆備笖鐢�10涓�10kHz鏃堕挓鍛ㄦ湡锛堝嵆1ms锛夋潵鍋氫竴娆″畬鏁寸殑杩愮畻
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		count_10kHz <= 4'd0;
	else if(clk_10kHz_en && start) begin
		if(count_10kHz == 4'd10 - 1)
			count_10kHz <= 4'd0;
		else
			count_10kHz <= count_10kHz + 1'b1;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		bram_en <= 1'b0;
		bram_addr <= 32'd0;
	end
	else if(clk_10kHz_en) begin
		case(count_10kHz)
		4'd1: begin
			bram_en <= 1'b1;
		end
		4'd2: begin
			bram_en <= 1'b0;
		end
		4'd9: begin
			if(bram_addr >= (bram_rd_count << 2) - 32'd4)
				bram_addr <= 32'd0;
			else
				bram_addr <= bram_addr + 'd4;
		end
		default: begin
			bram_en <= 1'b0;
		end
		endcase
	end
end

endmodule
