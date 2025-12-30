`timescale 1ns / 1ps

module RF(
    input wire clk,
    input wire w,
    input wire[4:0] R_Reg1,
    input wire[4:0] R_Reg2,
    input wire[4:0] W_Reg,
    input wire[31:0] w_data,
    output wire[31:0] R_data1,
    output wire[31:0] R_data2
);

    reg[31:0] register[31:0];
    
    // 初始化所有寄存器为0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            register[i] = 32'b0;
        end
        $display("RF: 寄存器文件初始化完成");
    end

    always @(posedge clk) begin
        if (w && (W_Reg != 0)) begin  // $0寄存器始终为0
            register[W_Reg] <= w_data;
            // 可选：显示写入信息
            // $display("RF: 写入寄存器$%0d = %h @ %t", W_Reg, w_data, $time);
        end
    end

    assign R_data1 = (R_Reg1 != 0) ? register[R_Reg1] : 0;
    assign R_data2 = (R_Reg2 != 0) ? register[R_Reg2] : 0;

endmodule