module top_module (
    input          clk,
    input          load,
    input  [255:0] data,
    output [255:0] q
);


    reg [15:0] qs   [15:0];

    // 1. 除了计算逻辑变量, 其他变量都要指定位宽
    // 2. 这个位宽如果是5,就会报错, 原因好像是-1 % 16计算得到的变成了负数???
    // 3. 为了避免这种情况,先+16再取余数
    reg [4:0] row0, row1, row2;
    reg [4:0] column0, column1, column2;
    reg [4:0] sum;

    integer i, j;
    always @(posedge clk) begin
        if (load)
        // 将data放入二维数组中
            {qs[15], qs[14],qs[13], qs[12],qs[11], qs[10],qs[9], qs[8],
            qs[7], qs[6],qs[5], qs[4],qs[3], qs[2],qs[1], qs[0]} <= data;
        else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    row0 = (i - 1 + 16) % 16;
                    row1 = i;
                    row2 = (i + 1) % 16;
                    column0 = (j - 1 + 16) % 16;
                    column1 = j;
                    column2 = (j + 1) % 16;
                    sum = qs[row0][column0]+qs[row0][column1]+qs[row0][column2]+qs[row1][column0]+
                                qs[row1][column2]+qs[row2][column0]+qs[row2][column1]+qs[row2][column2];
                    case (sum)
                        2: qs[i][j] <= qs[i][j];
                        3: qs[i][j] <= 1;
                        default: qs[i][j] <= 0;
                    endcase
                end
            end
        end
    end
    // 这里在always中使用了阻塞赋值,是为了在一个clk中计算出sum并转化为对应的关系; 非做题不要尝试!
    // 如果不想使用阻塞赋值, 可以把sum的表达式一整个放入case的判断中

    assign q = {qs[15], qs[14],qs[13], qs[12],qs[11], qs[10],qs[9], qs[8],
            qs[7], qs[6],qs[5], qs[4],qs[3], qs[2],qs[1], qs[0]};


endmodule
