.text
main:
    # 测试1: 基本算术运算 - 验证R-type指令
    addi $t0, $zero, 5        # $t0 = 5
    addi $t1, $zero, 3        # $t1 = 3
    
    # R-type指令测试
    add  $t2, $t0, $t1        # $t2 = 5 + 3 = 8 (测试add)
    sub  $t3, $t0, $t1        # $t3 = 5 - 3 = 2 (测试sub)
    and  $t4, $t0, $t1        # $t4 = 5 & 3 = 1 (测试and)
    or   $t5, $t0, $t1        # $t5 = 5 | 3 = 7 (测试or)
    xor  $t6, $t0, $t1        # $t6 = 5 ^ 3 = 6 (测试xor)
    nor  $t7, $t0, $t1        # $t7 = ~(5|3) (测试nor)
    slt  $t8, $t1, $t0        # $t8 = (3<5)?1:0 = 1 (测试slt)
    
    # 测试2: I-type指令
    addi $s0, $zero, 0xFF     # $s0 = 0xFF
    andi $s1, $s0, 0x0F       # $s1 = 0xFF & 0x0F = 0x0F
    ori  $s2, $s0, 0xF0       # $s2 = 0xFF | 0xF0 = 0xFF
    xori $s3, $s0, 0xAA       # $s3 = 0xFF ^ 0xAA = 0x55
    
    # 测试3: 内存访问 - 应该成功
    sw   $t0, 0($zero)        # mem[0] = 5
    lw   $s4, 0($zero)        # $s4 = mem[0] = 5
    
    # 测试4: 分支指令 - 应该跳转（成功分支）
    addi $k0, $zero, 1        # $k0 = 1 (成功标志)
    beq  $k0, $k0, success    # 1==1, 应该跳转到success
    
    # 这里不应该执行（分支失败路径）
fail_path:
    addi $k0, $zero, 0        # 设置失败标志（不应该执行）
    sw   $k0, 8($zero)        # mem[8] = 0
    j    fail_loop            # 进入失败循环
    
success:
    sw   $k0, 12($zero)       # mem[12] = 1 表示成功
    j    end_loop             # 进入成功结束循环

fail_loop:
    j    fail_loop            # 失败循环

end_loop:
    j    end_loop             # 成功结束循环