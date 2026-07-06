# load 0x100 into base address (x0 using addi)
# load a b and c from base address
# do T = A + B 
# then do T = (A + B) - C
# then U = T + 17 - 9 
# store U at OUT0(0x10C)
# build K=0x12345678 with lui
# calculate U + K
# store U at OUT1(0x110)

addi t0, x0, 0x100 # load 0x100 into t0 (using addi)
lw t1, 0(t0) # A 
lw t2, 4(t0) # B
lw t3, 8(t0) # C
add t4, t1, t2 # T = A + B 
sub t4, t4, t3 # T = T - C
addi t5, t4, 17 # U = U + 17 
addi t5, t5, -9 # U = U - 9
sw t5, 12(t0) # store U at OUT0
lui s0, 0x12345 # build K=0x12345 with lui
addi s0, s0, 0x678 # finish off K
add t6, s0, t5 # calculate U + K
sw t6, 16(t0) # store U at OUT1