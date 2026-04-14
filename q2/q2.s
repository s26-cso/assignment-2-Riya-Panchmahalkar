.section .rodata

fmt_int:
    .string "%d"
fmt_space:
    .string " "
fmt_line:
    .string "\n"

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
    sd s5,8(sp)

    addi s0,a0,-1
    mv s5,a1
    blez s0,exit

    slli a0,s0,2
    call malloc
    mv s1,a0

    slli a0,s0,2
    call malloc
    mv s2,a0

    slli a0,s0,2
    call malloc
    mv s3,a0

    li t0,0

loop:
    bge t0,s0,done

    slli t1,t0,2
    add t1,s2,t1
    li t2,-1
    sw t2,0(t1)
    
    addi t1,t0,1
    slli t1,t1,3
    add t1,s5,t1
    ld a0,0(t1)

    addi sp,sp,-16
    sd t0,0(sp)
    call atoi
    ld t0,0(sp)
    addi sp,sp,16
    
    slli t1,t0,2
    add t1,s1,t1
    sw a0,0(t1)
    addi t0,t0,1
    j loop

done:
    addi s5,s0,-1
    li s4,-1

loop2:
    bltz s5,done2

pop_loop:
    bltz s4,pop_done

    slli t0,s4,2
    add t0,s3,t0
    lw t0,0(t0)
    slli t1,t0,2
    add t1,s1,t1
    lw t1,0(t1)

    slli t2,s5,2
    add t2,s1,t2
    lw t2,0(t2)  

    bgt t1,t2,pop_done
    addi s4,s4,-1
    j pop_loop

pop_done:
    bltz s4,push
    slli t0,s4,2
    add t0,s3,t0
    lw t0,0(t0)
    slli t1,s5,2
    add t1,s2,t1
    sw t0,0(t1)

push:
    addi s4,s4,1
    slli t0,s4,2
    add t0,s3,t0
    sw s5,0(t0)
    addi s5,s5,-1
    j loop2

done2:
    li s5,0

print_loop:
    bge s5,s0,print_done
    beqz s5,skip_space
    la a0,fmt_space
    call printf

skip_space:
    slli t0,s5,2
    add t0,s2,t0
    lw a1,0(t0)
    la a0,fmt_int
    call printf
    addi s5,s5,1
    j print_loop

print_done:
    la a0,fmt_line
    call printf

exit:
    li a0,0
    ld ra,56(sp)
    ld s0,48(sp)
    ld s1,40(sp)
    ld s2,32(sp)
    ld s3,24(sp)
    ld s4,16(sp)
    ld s5,8(sp)
    addi sp,sp,64
    ret

