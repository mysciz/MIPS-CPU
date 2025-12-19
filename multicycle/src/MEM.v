`timescale 1ns / 1ps

module MEM(
    input wire clk,
    input wire[31:0] addr,
    input wire W,
    input wire R,
    input wire[31:0] W_data,
    output wire [31:0] R_data
);
    
    // 内存定义
    reg[31:0] imem [0:1023];  // 4KB统一内存
    integer i;
    
    // 初始化内存
    initial begin
        for(i = 0; i < 1024; i = i + 1)
            imem[i] = 32'h00000000;
        $readmemh("./asm/test_expend.txt", imem);
    end
    
    // 字地址
    wire [9:0] word_addr = addr[11:2];
    
    // 写操作（有条件的写保护）
    always @(posedge clk) begin
        if(W) begin
            // 只允许写入地址 >= 0x400 的区域（数据区）
            if(word_addr >= 10'h100) begin  // 0x400 >> 2 = 0x100
                imem[word_addr] <= W_data;
            end
        end
    end
    
    // 读操作
    assign R_data = R ? ((word_addr < 1024) ? imem[word_addr] : 32'h0) : 32'hz;
    
endmodule