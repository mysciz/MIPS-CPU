`timescale 1ns / 1ps

module SHL #(
    parameter INPUT_WIDTH  = 26,  // 默认输入26位
    parameter OUTPUT_WIDTH = 28 // 默认输出28位
)(
    input wire [INPUT_WIDTH-1:0]  data_in,
    output wire [OUTPUT_WIDTH-1:0] data_out
);
    
    // 左移指定位数，低位补0
    assign data_out = {data_in, 2'b00};
    
endmodule