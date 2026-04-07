# NODE
.globl make_node
make_node:
    addi sp,sp,-16
    sd ra,8(sp)
    sd s0,0(sp)
    mv s0,a0

    li a0,20
    call malloc
    sw s0,0(a0)
    sd zero,8(a0)
    sd zero,16(a0)

    ld ra,8(sp)
    ld s0,0(sp)
    addi sp,sp,16
    ret

# INSERT
.globl insert
insert:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    sd s2,0(sp)
    mv s0,a0
    mv s1,a1

    beqz s0,new_insert

    lw s2,0(s0)
    blt s1,s2,left_insert
    bgt s1,s2,right_insert
    j insert_done

new_insert:
    mv a0,s1
    call make_node
    mv s0,a0
    j insert_done

left_insert:
    ld a0,8(s0)
    mv a1,s1
    call insert
    sd a0,8(s0)
    j insert_done

right_insert:
    ld a0,16(s0)
    mv a1,s1
    call insert
    sd a0,16(s0)

insert_done:
    mv a0,s0
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    ld s2,0(sp)
    addi sp,sp,32
    ret

# GET
.globl get
get:
    beqz a0,get_done
    lw t0,0(a0)
    beq a1,t0,get_done
    blt a1,t0,get_left
    ld a0,16(a0)
    j get

get_left:
    ld a0,8(a0)
    j get

get_done:
    ret

# GET AT MOST
.globl getAtMost

getAtMost:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)
    sd s2,0(sp)
    mv s0,a0
    mv s1,a1
    li s2,-1

loop:
    beqz s1,done
    lw t0,0(s1)
    beq t0,s0,equal
    bgt t0,s0,go_left

    mv s2,t0
    ld s1,16(s1)
    j loop

equal:
    mv s2,s0
    j done

go_left:
    ld s1,8(s1)
    j loop

done:
    mv a0,s2
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    ld s2,0(sp)
    addi sp,sp,32
    ret



