// 没有修改时钟，还是25MHz
// `define Resolution_640x480
// `define Resolution_1280x720
`define Resolution_1920x1080    // 60Hz需要时钟148.5MHz

`ifdef Resolution_640x480
    `define H_Right_Border 8
    `define H_Front_Porch 8
    `define H_Sync_Time 96
    `define H_Back_Porch 40
    `define H_Lefter_Border 8
    `define H_Data_Time 640
    `define H_Total_Time 800
    `define V_Bottom_Border 8
    `define V_Front_Porch 2
    `define V_Sync_Time 2
    `define V_Back_Porch 25
    `define V_Top_Border 8
    `define V_Data_Time 480
    `define V_Total_Time 525
`elsif Resolution_1280x720
    `define H_Right_Border 0
    `define H_Front_Porch 110
    `define H_Sync_Time 40
    `define H_Back_Porch 220
    `define H_Lefter_Border 0
    `define H_Data_Time 1280
    `define H_Total_Time 1650
    `define V_Bottom_Border 0
    `define V_Front_Porch 5
    `define V_Sync_Time 5
    `define V_Back_Porch 20
    `define V_Top_Border 0
    `define V_Data_Time 720
    `define V_Total_Time 750
`elsif Resolution_1920x1080
    `define H_Right_Border 0
    `define H_Front_Porch 88
    `define H_Sync_Time 44
    `define H_Back_Porch 148
    `define H_Lefter_Border 0
    `define H_Data_Time 1920
    `define H_Total_Time 2200
    `define V_Bottom_Border 0
    `define V_Front_Porch 4
    `define V_Sync_Time 5
    `define V_Back_Porch 36
    `define V_Top_Border 0
    `define V_Data_Time 1080
    `define V_Total_Time 1125
`endif
