# goal: write a program that computes out = double(x) + y - z
# arbitrary values: x = 7 y = 20 z = 5
# main loads x y and z from memory and places them into ax registers, then calls compute and stores a0 into output memory 
# compute: receives argument and calls double function
    # - must save ra before calling double 
    # - preserve values it needs after helper call
    # - returns a0 
# double: receives a0 = x and returns a0 = 2*x
    # - does not call another function so it does not need to save ra

main:
addi t0, zero, 0x100 # base address of inputs
lw a0, 0(t0) # x
lw a1, 4(t0) # y
lw a2, 8(t0) # z
jal ra, compute # jal writes the return address into ra
addi t1, zero, 0x200 #create output address
sw a0, 0(t1) #save a0 to memory output address 

done: 
    jal zero, done # repeating instructions a to "stop" program

compute:  
addi sp, sp, -12 # make space on stack for 3 word (ra, y and z) since double can overwrite their registers
sw ra, 8(sp)
sw a1, 4(sp) # save y in memory
sw a2, 0(sp) # save z in memory
jal ra, double # jal writes the return address into ra
lw ra, 8(sp) # load ra to main after retrurning from double
lw a1, 4(sp) # load y in memory
lw a2, 0(sp) # load z in memory
add a0, a0, a1 # double(x) + y 
sub a0, a0, a2 # (double(x) + y) - z
addi sp, sp, 12 # deallocate space on stack
jr ra # return to main (jalr zero, ra, 0)

double:
slli a0, a0, 1 # double x 
jr ra #return to compute (jalr zero, ra, 0)