`timescale 1ns / 1ps

module IM(
    input wire[31:0] addr,     
    output wire[31:0] inst
);
    reg[31:0] mem [127:0];  
    initial begin
        $readmemh("./asm/test_expend.txt", mem);
    end
    assign inst = mem[addr[8:2]];
    
endmodule