.text
main:
    # ========== 阶段1：生成初始值 ==========
    nor $t0, $zero, $zero    # $t0 = 0xFFFFFFFF (0x00004027)
    srl $t1, $t0, 31         # $t1 = 1 (0x00014902)
    
    # ========== 阶段2：测试内存指令 ==========
    sw $t1, 0x400($zero)     # mem[0x400] = 1 (0xAC090400)
    lw $t2, 0x400($zero)     # $t2 = 1 (0x8C0A0400)
    
    # ========== 阶段3：测试R-type算术运算 ==========
    add $t3, $t2, $t2        # $t3 = 2 (0x014A5840)
    addu $t4, $t3, $t2       # $t4 = 3 (0x016C6020)
    sub $t5, $t4, $t2        # $t5 = 2 (0x018A6822)
    subu $t6, $t4, $t3       # $t6 = 1 (0x018C7022)
    
    sw $t3, 0x404($zero)     # mem[0x404] = 2 (0xAC0B0404)
    sw $t4, 0x408($zero)     # mem[0x408] = 3 (0xAC0C0408)
    
    # ========== 阶段4：测试逻辑运算 ==========
    and $t7, $t3, $t4        # $t7 = 2 & 3 = 2 (0x016F7840)
    or $t8, $t3, $t4         # $t8 = 2 | 3 = 3 (0x016C8041)
    xor $t9, $t3, $t4        # $t9 = 2 ^ 3 = 1 (0x016B8841)
    nor $s0, $t3, $t4        # $s0 = ~(2|3) = 0xFFFFFFFC (0x01A9C026 或 0x016E9027)
    
    # ========== 阶段5：测试移位运算 ==========
    sll $s1, $t2, 2          # $s1 = 1 << 2 = 4 (0x000A9140)
    srl $s2, $s0, 2          # $s2 = 0xFFFFFFFC >> 2 = 0x3FFFFFFF (0x0200900A)
    
    # ========== 阶段6：测试比较运算 ==========
    slt $s3, $t2, $t3        # 1 < 2 = 1 (0x014B9842)
    sltu $s4, $t2, $t3       # 1 < 2 = 1 (0x014BA043)
    
    # ========== 阶段7：测试分支 ==========
    beq $t2, $t2, branch1    # 应该跳转 (0x114A0001)
    add $a0, $zero, $zero    # 这行跳过
    
branch1:
    lw $a1, 0x404($zero)     # $a1 = 2 (0x8C0B0404)
    
    beq $t2, $t3, skip       # 1==2? 不应该跳转 (0x114B0002)
    add $a2, $t2, $t2        # $a2 = 2（执行）(0x014AB020)
    
skip:
    # ========== 阶段8：测试跳转 ==========
    j jump_target            # (0x0800001B)
    add $a3, $zero, $zero    # 跳过
    
jump_target:
    add $t0, $t0, $zero      # nop (0x010A4020)
    
    # ========== 阶段9：最终验证 ==========
    lw $k0, 0x400($zero)     # $k0 = 1 (0x8C1A0400)
    lw $k1, 0x404($zero)     # $k1 = 2 (0x8C1B0404)
    add $at, $k0, $k1        # $at = 3 (0x035B5020)
    beq $at, $t4, success    # 如果$at == 3，成功 (0x114C0001)
    
fail:
    j fail                   # (0x08000022)
    
success:
    # 将成功标志存储到alu_out对应的内存地址
    # 假设alu_out映射到内存地址0x40C
    addi $v0, $zero, 1       # 成功标志值 = 1
    sw $v0, 0x40C($zero)     # mem[0x40C] = 1（成功标志）(0xAC02040C)
    
done:
    j done                   # (0x08000025)