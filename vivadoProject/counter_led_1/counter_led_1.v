// led ��0.25, ��0.75

module counter_led_1 (
    input clock,
    input reset_n,
    output reg led
);
    parameter MCNT = 50_000_000;  // MCNT = ����������ns / 20ns
    reg [31:0]count;

    // ʱ�Ӽ���  
    always @(posedge clock or negedge reset_n) begin
        if(! reset_n) begin
            count <= 0;
        end
        else begin   // clock������
            if(count == MCNT - 1) begin
                count <= 0;
            end
            else begin
                count <= count + 1;
            end
        end
    end

    // led ��0.25, ��0.75
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            led <= 1'b0;
        end
        else begin  // count 0~MCNT/4 - 1
            if (count <=  MCNT/4 - 1) begin 
                led <= 1'b1;
            end
            else begin  // count MCNT/4 ~ MCNT - 1
                led <= 1'b0;
            end
        end
    end

endmodule