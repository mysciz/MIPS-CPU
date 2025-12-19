`timescale 1ns / 1ps
module PC(
    input wire clk,           
    input wire rst,           
    input wire PCWrite,       
    input wire [31:0] next_pc, 
    output reg [31:0] pc      
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 0;
    end else begin
        if (PCWrite) begin
            pc <= next_pc;
        end
    end
end

endmodule