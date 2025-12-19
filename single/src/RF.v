`timescale 1ns / 1ps

module RF(
	input wire clk,w,
	input wire[4:0] R_Reg1,R_Reg2,W_Reg,
	input wire[31:0] w_data,
	output wire[31:0] R_data1,R_data2
    );

	reg[31:0] register[31:0];

	always @(posedge clk) begin
		if(w) begin
			 register[W_Reg] <= w_data;
		end
	end

	assign R_data1 = (R_Reg1 != 0) ? register[R_Reg1] : 0;
	assign R_data2 = (R_Reg2 != 0) ? register[R_Reg2] : 0;

endmodule
