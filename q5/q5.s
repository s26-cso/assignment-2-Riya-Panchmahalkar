.section .rodata
filename:
   .string "input.txt"
mode:
    .string "r"
msg_yes:
    .string "Yes"
msg_no:
    .string "No"

.text
.globl main

main:
    addi sp,sp,-64
    sd ra,56(sp)
    sd s0,48(sp)
    sd s1,40(sp)
    sd s2,32(sp)
    sd s3,24(sp)
    sd s4,16(sp)

    la a0,filename
    la a1,mode
    call fopen
    beqz a0,is_no
    mv s0,a0         # s0 = fp

    mv a0,s0
    li a1,0
    li a2,2
    call fseek
    
    mv a0,s0
    call ftell
    mv s2,a0         # s2 = total size

    mv a0,s0
    addi a1,s2,-1
    li a2,0
    call fseek
    
    mv a0,s0
    call fgetc        # Returns char in a0
    li t0,10         # '\n'
    beq a0,t0,trim
    j init_pointers

trim:
    addi s2,s2,-1

init_pointers:
    li s1,0          # left = 0
    addi s2,s2,-1     # right = size - 1

palindrome_loop:
    bge s1,s2,is_yes
    
    # Get char at left (s1)
    mv a0,s0
    mv a1,s1
    li a2,0
    call fseek
    mv a0,s0
    call fgetc
    mv s3,a0         # s3 = char at left

    # Get char at right
    mv a0,s0
    mv a1,s2
    li a2,0
    call fseek
    mv a0,s0
    call fgetc
    mv s4,a0         # s4 = char at right

    # Compare
    bne s3,s4,is_no
    
    addi s1,s1,1    # left++
    addi s2,s2,-1   # right--
    j palindrome_loop

is_yes:
    la a0,msg_yes
    call puts
    j cleanup

is_no:
    la a0,msg_no
    call puts

cleanup:
    mv a0,s0
    call fclose

    # Restore and return
    li a0,0
    ld ra,56(sp)
    ld s0,48(sp)
    ld s1,40(sp)
    ld s2,32(sp)
    ld s3,24(sp)
    ld s4,16(sp)
    addi sp,sp,64
    ret
    