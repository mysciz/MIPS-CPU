`timescale 1ns / 1ps

module DM(
    input wire clk,
    input wire[31:0] addr,
    input wire W,
    input wire R,
    input wire[31:0] W_data,
    output wire [31:0] R_data
    );
    
    reg[31:0] mem [255:0];
    reg[31:0] n;
     
    initial begin
        for(n = 0; n <= 255; n = n + 1)
            mem[n] = 0;
    end

    always @(posedge clk) begin
        if(W)
            mem[addr] <= W_data;
    end
    assign R_data = R ? mem[addr] : 32'bz;
    
    
endmodule