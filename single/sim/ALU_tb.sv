`timescale 1ns/1ns

module ALU_tb;

    // 测试信号
    reg [3:0] ALUControl;
    reg [31:0] a, b;
    wire [31:0] alu_out;
    wire zf;
    
    // 实例化被测模块
    ALU dut (
        .ALUControl(ALUControl),
        .a(a),
        .b(b),
        .alu_out(alu_out),
        .zf(zf)
    );
    
    // 测试统计
    integer pass_count = 0;
    integer fail_count = 0;
    
    initial begin
        $display("=== ALU Testbench Started ===");
        $display("");
        
        // 测试1: ADD
        $display("Test 1: ADD (5 + 3)");
        ALUControl = 4'b0010;
        a = 32'd5;
        b = 32'd3;
        #10;
        if (alu_out == 32'd8 && zf == 0) begin
            $display("  PASS: Result = %0d, ZF = %0d", alu_out, zf);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Expected 8, got %0d (ZF = %0d)", alu_out, zf);
            fail_count = fail_count + 1;
        end
        $display("");
        
        // 测试2: SUB
        $display("Test 2: SUB (10 - 3)");
        ALUControl = 4'b0110;
        a = 32'd10;
        b = 32'd3;
        #10;
        if (alu_out == 32'd7 && zf == 0) begin
            $display("  PASS: Result = %0d, ZF = %0d", alu_out, zf);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Expected 7, got %0d (ZF = %0d)", alu_out, zf);
            fail_count = fail_count + 1;
        end
        $display("");
        
        // 测试3: AND
        $display("Test 3: AND (0xFF & 0x0F)");
        ALUControl = 4'b0000;
        a = 32'hFF;
        b = 32'h0F;
        #10;
        if (alu_out == 32'h0F && zf == 0) begin
            $display("  PASS: Result = 0x%h, ZF = %0d", alu_out, zf);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Expected 0x0F, got 0x%h (ZF = %0d)", alu_out, zf);
            fail_count = fail_count + 1;
        end
        $display("");
        
        // 测试4: OR
        $display("Test 4: OR (0xF0 | 0x0F)");
        ALUControl = 4'b0001;
        a = 32'hF0;
        b = 32'h0F;
        #10;
        if (alu_out == 32'hFF && zf == 0) begin
            $display("  PASS: Result = 0x%h, ZF = %0d", alu_out, zf);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Expected 0xFF, got 0x%h (ZF = %0d)", alu_out, zf);
            fail_count = fail_count + 1;
        end
        $display("");
        
        // 测试5: SLT (小于则置1)
        $display("Test 5: SLT (5 < 10)");
        ALUControl = 4'b0111;
        a = 32'd5;
        b = 32'd10;
        #10;
        if (alu_out == 32'd1 && zf == 0) begin
            $display("  PASS: Result = %0d, ZF = %0d", alu_out, zf);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Expected 1, got %0d (ZF = %0d)", alu_out, zf);
            fail_count = fail_count + 1;
        end
        $display("");
        
        // 测试6: SLL (左移)
        $display("Test 6: SLL (0xF << 2)");
        ALUControl = 4'b1000;
        a = 32'd2;  // 移位位数
        b = 32'hF;  // 要移位的值
        #10;
        if (alu_out == 32'h3C && zf == 0) begin  // 0xF << 2 = 0x3C
            $display("  PASS: Result = 0x%h, ZF = %0d", alu_out, zf);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Expected 0x3C, got 0x%h (ZF = %0d)", alu_out, zf);
            fail_count = fail_count + 1;
        end
        $display("");
        
        // 测试7: 零标志
        $display("Test 7: Zero Flag (0 + 0)");
        ALUControl = 4'b0010;
        a = 32'd0;
        b = 32'd0;
        #10;
        if (alu_out == 32'd0 && zf == 1) begin
            $display("  PASS: Result = %0d, ZF = %0d", alu_out, zf);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: Expected 0 with ZF=1, got %0d (ZF = %0d)", alu_out, zf);
            fail_count = fail_count + 1;
        end
        $display("");
        
        // 测试结果汇总
        $display("=== Test Summary ===");
        $display("Total tests: %0d", pass_count + fail_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        
        if (fail_count == 0) begin
            $display("All tests PASSED! ✓");
        end else begin
            $display("Some tests FAILED! ✗");
        end
        
        // 结束仿真
        #10;
        $finish;
    end
    
endmodule