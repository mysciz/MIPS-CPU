module Hazard_Detection (
    // 输入
    input EX_MA_Flag_ZF,      // EX阶段的零标志
    input EX_MA_Flag_Branch,  // EX阶段是否是分支指令
    input EX_Jump,            // EX阶段是否是跳转指令
    input EX_MemRD,           // EX阶段是否是load指令
    input [4:0] ID_Rs,        // ID阶段的rs
    input [4:0] ID_Rt,        // ID阶段的rt  
    input [4:0] EX_Rt,        // EX阶段的rt
    
    // 输出
    output reg clear1,        // 清空EX_MA前的MUX
    output reg clear0,        // 清空ID/EX前的MUX  
    output reg FI_ID_RegWr,   // IF/ID寄存器写使能
    output reg PCWr           // PC寄存器写使能
);

always @(*) begin
    // 默认值
    clear1 = 1'b0;
    clear0 = 1'b0;
    FI_ID_RegWr = 1'b1;
    PCWr = 1'b1;
    
    // 1. 分支跳转（需要清空）
    if (EX_MA_Flag_Branch && EX_MA_Flag_ZF) begin
        // 分支成立，清空流水线中的错误指令
        clear1 = 1'b1;   // 清空EX_MA路径
        clear0 = 1'b1;   // 清空ID/EX路径
        // PC继续从分支目标取指
    end
    
    // 2. 跳转指令
    else if (EX_Jump) begin
        // 跳转，清空流水线
        clear1 = 1'b1;
        clear0 = 1'b1;
    end
    
    // 3. load-use冒险
    else if (EX_MemRD && (EX_Rt != 5'b0)) begin
        if ((EX_Rt == ID_Rs) || (EX_Rt == ID_Rt)) begin
            // 暂停，不清空
            FI_ID_RegWr = 1'b0;
            PCWr = 1'b0;
            // clear保持0（不清空）
        end
    end
end

endmodule