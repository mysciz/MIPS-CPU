.text
main:
    # ========================================
    # 测试1: 算术运算并验证结果
    # ========================================
    
    # 初始化测试值
    addi $t0, $zero, 5        # $t0 = 5
    addi $t1, $zero, 3        # $t1 = 3
    
    # 执行各种运算
    add  $t2, $t0, $t1        # $t2 = 5+3 = 8  (正确结果应为8)
    sub  $t3, $t0, $t1        # $t3 = 5-3 = 2  (正确结果应为2)
    and  $t4, $t0, $t1        # $t4 = 5&3 = 1  (正确结果应为1)
    or   $t5, $t0, $t1        # $t5 = 5|3 = 7  (正确结果应为7)
    xor  $t6, $t0, $t1        # $t6 = 5^3 = 6  (正确结果应为6)
    
    # ========================================
    # 测试2: 验证计算结果
    # ========================================
    
    # 验证add结果 (应该为8)
    addi $s0, $zero, 8        # 期望值: 8
    beq  $t2, $s0, test1_pass # 如果$t2==8，跳转到test1_pass
    j    test_fail            # 否则跳转到失败
    
test1_pass:
    # 验证sub结果 (应该为2)
    addi $s1, $zero, 2        # 期望值: 2
    beq  $t3, $s1, test2_pass # 如果$t3==2，跳转
    j    test_fail            # 否则失败
    
test2_pass:
    # 验证and结果 (应该为1)
    addi $s2, $zero, 1        # 期望值: 1
    beq  $t4, $s2, test3_pass # 如果$t4==1，跳转
    j    test_fail            # 否则失败
    
test3_pass:
    # 验证or结果 (应该为7)
    addi $s3, $zero, 7        # 期望值: 7
    beq  $t5, $s3, test4_pass # 如果$t5==7，跳转
    j    test_fail            # 否则失败
    
test4_pass:
    # 验证xor结果 (应该为6)
    addi $s4, $zero, 6        # 期望值: 6
    beq  $t6, $s4, test5_pass # 如果$t6==6，跳转
    j    test_fail            # 否则失败
    
test5_pass:
    # ========================================
    # 测试3: I-type指令验证
    # ========================================
    
    addi $a0, $zero, 0xFF     # $a0 = 0xFF
    andi $a1, $a0, 0x0F       # $a1 = 0xFF & 0x0F = 0x0F
    ori  $a2, $a0, 0xF0       # $a2 = 0xFF | 0xF0 = 0xFF
    xori $a3, $a0, 0xAA       # $a3 = 0xFF ^ 0xAA = 0x55
    
    # 验证andi结果
    addi $s5, $zero, 0x0F     # 期望值: 0x0F
    beq  $a1, $s5, test6_pass
    j    test_fail
    
test6_pass:
    # 验证ori结果
    addi $s6, $zero, 0xFF     # 期望值: 0xFF
    beq  $a2, $s6, test7_pass
    j    test_fail
    
test7_pass:
    # 验证xori结果
    addi $s7, $zero, 0x55     # 期望值: 0x55
    beq  $a3, $s7, test8_pass
    j    test_fail
    
test8_pass:
    # ========================================
    # 测试4: 内存访问验证
    # ========================================
    
    # 存储测试
    sw   $t0, 0($zero)        # mem[0] = 5
    lw   $v0, 0($zero)        # $v0 = mem[0]
    
    # 验证加载结果
    beq  $v0, $t0, test9_pass # 如果$v0==5，跳转
    j    test_fail
    
test9_pass:
    # ========================================
    # 所有测试通过，进入成功循环
    # ========================================
    
    # 写入成功标记
    addi $k0, $zero, 1        # 成功标志 = 1
    sw   $k0, 12($zero)       # mem[12] = 1
    
    # 跳转到成功循环
    j    success_loop

test_fail:
    # ========================================
    # 测试失败，进入失败循环
    # ========================================
    
    # 写入失败标记
    addi $k1, $zero, 0        # 失败标志 = 0
    sw   $k1, 12($zero)       # mem[12] = 0
    
    # 跳转到失败循环
    j    fail_loop

success_loop:
    # 成功循环 - 执行简单操作便于观察
    addi $v0, $zero, 0x5555   # 加载成功标记值
    addi $v1, $zero, 0xAAAA
    j    success_loop         # 无限循环

fail_loop:
    # 失败循环 - 执行简单操作便于观察
    addi $v0, $zero, 0x0000   # 加载失败标记值
    addi $v1, $zero, 0xFFFF
    j    fail_loop           # 无限循环

# 填充nop指令确保指令存储器有足够空间
nop
nop
nop
nop