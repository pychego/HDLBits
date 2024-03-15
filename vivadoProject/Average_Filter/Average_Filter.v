module Average_Filter #(
    parameter AVE_DATA_NUM = 'd128,
    parameter AVE_DATA_BIT = 'd7
) (
    input                clk,    //PL_clk0 100MHz
    input                rst_n,
    input  signed [15:0] din,
    output signed [15:0] dout
);

    reg [8:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 9'd0;
        else if (cnt == 9'd499) cnt <= 9'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_200kHz_en;
    assign clk_200kHz_en = (cnt == 9'd1);


    // width is 16, depth is 128
    reg signed [15:0] data_reg[0:AVE_DATA_NUM-1];

    // signed number, no need to specify bit width when declaring, default to 32 bits
    integer           temp_i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (temp_i = 0; temp_i < AVE_DATA_NUM; temp_i = temp_i + 1) data_reg[temp_i] <= 'd0;
        end else if (clk_200kHz_en) begin
            data_reg[0] <= din;         // input  signed [15:0] din,
            for (temp_i = 0; temp_i < AVE_DATA_NUM - 1; temp_i = temp_i + 1)
                data_reg[temp_i+1] <= data_reg[temp_i];
        end
    end

    reg signed [31:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) sum <= 'd0;
        else if (clk_200kHz_en)
            // this logic can be understood by simulating the action of the clock signal whern it arrives
            sum <= sum + din - data_reg[AVE_DATA_NUM-1];
    end

    // arithmetic shift right, equivalent to dividing a signed number by 8
    assign dout = sum >>> AVE_DATA_BIT;  
endmodule
