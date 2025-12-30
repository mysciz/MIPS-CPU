module Hazard_Unit (
    input clk,
    input rst,
    input ID_EX_MemRd,
    input ID_EX_Jump,
    input EX_MA_Branch,
    input [4:0]FI_ID_Rs,
    input [4:0]FI_ID_Rt,
    input [4:0] ID_EX_IR_Rt,
    input EX_MA_Flag_ZF,
    output PCWr,
    output IF_ID_RegWr,
    output clear0,
    output clear1,
    output flush
);
    reg[1:0] times;
    // 检测load-use数据冒险
    assign load_use_hazard = ID_EX_MemRd && 
                            ((FI_ID_Rs == ID_EX_IR_Rt) || 
                             (FI_ID_Rt == ID_EX_IR_Rt));
    
    // 控制冒险
    assign branch_taken = EX_MA_Branch && EX_MA_Flag_ZF;
    
    // 输出逻辑
    // load-use冒险时：暂停PC和IF/ID，清除ID阶段控制信号
    // 控制冒险时：暂停PC和IF/ID，清除ID和EX阶段控制信号
    wire hazard_detected = load_use_hazard || branch_taken || ID_EX_Jump;
    
    //assign PCWr = ~hazard_detected;
    assign PCWr= ~(load_use_hazard );
    //assign IF_ID_RegWr = ~hazard_detected;
    assign flush=branch_taken;
    assign IF_ID_RegWr= ~(load_use_hazard );
    // clear0: 清除ID阶段控制信号
    // 需要：load-use冒险、分支跳转
    assign clear0 = load_use_hazard || branch_taken || ID_EX_Jump||(times!=0);

    // clear1: 清除EX阶段控制信号
    // 只需要：分支跳转（load-use冒险不清除EX）
    assign clear1 = branch_taken;
    always @(posedge clk or rst) begin
        if(rst)
            times <= 2'b00;
        if(ID_EX_Jump)
            times <= 2'b10;
        if(times!=0)begin
            times<=times-1;
        end
    end
endmodule