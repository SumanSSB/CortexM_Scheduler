.section .vectors
vector_table:
    .word 0x20001000
    .word reset_handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word sys_tick

    .section .text
    .align 1
    .type reset_handler, %function

reset_handler:
    LDR r1, =0xE000E010
    LDR r2, =0xE000E014
    LDR r3, [r1]
    LDR r4, [r2]
    mov r6, #3
    ORR r3, r3, r6
    mov r4, #5
    str r4, [r2]
    str r3, [r1]
    b .

    .align 1
    .type sys_tick, %function
sys_tick:
    mov r3, #0
    mov r4, #0
    str r4, [r2]
    str r3, [r1]
    bx lr