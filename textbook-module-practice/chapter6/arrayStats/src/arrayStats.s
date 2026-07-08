# goal: write a 6 word signed integer array in assembly and store three results: sum, max, and pos count

# Memory layout
# Address	        Meaning	Decimal value	32-bit hex
# 0x100	array[0]	7	                    0x00000007
# 0x104	array[1]	-3	                    0xFFFFFFFD
# 0x108	array[2]	0	                    0x00000000
# 0x10C	array[3]	12	                    0x0000000C
# 0x110	array[4]	7	                    0x00000007
# 0x114	array[5]	-5	                    0xFFFFFFFB

# Output memory
# Address	        Meaning	                Expected final decimal	Expected final hex
# 0x200	            sum	                    18	                    0x00000012
# 0x204	            maximum	                12	                    0x0000000C
# 0x208	            positive count	        3	                    0x00000003

addi s0, zero, 0x100 # base address of input array 
addi s6, zero, 0x200 # base address of output
addi t0, zero, 0 # i = 0
addi t1, zero, 0 # sum = 0
addi t2, zero, 0 # pos count = 0
lw t3, 0(s0) # max = first element of input array
addi t4, zero, 6 #loop limit

loop: beq t0, t4, done  # when i = 6 --> done
slli t5 , t0, 2         # t5 = i * 4 (byte offset)
add s1, s0, t5          #addres of array[i]
lw t6, 0(s1)            # load data from array
add t1, t1, t6          # sum = sum + array[i]
bge t3, t6, skip        # if max >= current value, skip max update
addi t3, t6, 0          # otherwise, current value becomes new max
j finish                # jump past the skip label after updating max
skip:
finish:
bge zero, t6, next      # if current value <= 0, skip positive count increment
addi t2, t2, 1          # otherwise, positive count++
j complete              # jump past the next label after incrementing count
next:
complete:
addi t0, t0, 1          # i++
j loop                  # repeat loop for next array element
done:
sw t1, 0(s6)            # store final sum at output[0], address 0x200
sw t3, 4(s6)            # store final max at output[1], address 0x204
sw t2, 8(s6)            # store final positive count at output[2], address 0x208