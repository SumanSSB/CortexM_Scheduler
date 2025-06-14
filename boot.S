.equ SYST_CSR,   0xE000E010
.equ SYST_RVR,   0xE000E014
.equ SYST_CVR,   0xE000E018
.equ SYST_CALIB, 0xE000E01C
.equ SYST_RELOAD, 0x00FFFFFF
.equ TSTACK_BLOCK, 0x20001FEC
.equ TTSTACK_LIMIT, 0x20002000

.section .vectors
vector_table:
    .word 0x20001000
    .word reset_handler
    .zero 52
    .word sys_tick
    .zero 440

    .section .text
    .align 1
    .type reset_handler, %function

reset_handler:

    bl init_task_stack

    LDR r0, =SYST_RELOAD
    LDR r1, =SYST_CSR
    LDR r2, =SYST_RVR
    str r0, [r2]
    mov r0, #7
    str r0, [r1]
    b .

init_task_stack:    // Initialzes the task stack value
    mov r0, #4
    LDR r2, =0x20001000
    LDR r3, =task_stack1
    LDR r4, =task_stack2
    LDR r5, =task_stack3
    LDR r1, =TSTACK_BLOCK

    STR r0, [r1]    // Storing address of stack 
    ADD r1, r1, r0
    STR r2,[r1]
    ADD r1, r1, r0
    STR r3,[r1]
    ADD r1, r1, r0
    STR r4,[r1]
    ADD r1, r1, r0
    STR r5,[r1]

    bx lr

    .align 1
    .type sys_tick, %function
sys_tick:
    push {r4-r7}    // Saving the context of previous task
    mov r4, r8
    mov r5, r9
    mov r6, r10
    mov r7, r11
    push {r4-r7}

    LDR r0, =TSTACK_BLOCK   // choosing next task to run
    LDR r5, =TTSTACK_LIMIT
    mov r1, sp
    LDR r2, [r0]
    ADD r3, r0, r2
    STR r1, [r3]    // storing current value of sp in task stack block

    ADD r2, r2, #4  
    ADD r3, r0, r2
    SUB r4, r5, r3
    CBNZ r4, load_task
    mov r2, #8     // reseting the pointer to point to t1 stack when it reaches end
    ADD r3, r0, r2
    b load_task

load_task:
    STR r2, [r0]
    LDR r6, [r3]    // Loading next task stack pointer from block
    mov sp, r6

    pop {r4-r7}     // Restoring the context of next task
    mov r8, r4
    mov r9, r5
    mov r10, r6
    mov r11, r7
    pop {r4-r7}

    bx lr


.align 1
.type task1, %function
task1:
    add r4, r4, #1
    b task1
    
.align 1
.type task2, %function
task2:
    add r5, r5, #1
    b task2

.align 1
.type task3, %function
task3:
    add r6, r6, #1
    b task3

.section .data
.align 2
.org 960
.type task_stack1, %function
task_stack1:
    .word 0x18
    .word 0x19
    .word 0x1a
    .word 0x1b
    .word 0x14
    .word 0x15
    .word 0x16
    .word 0x17
    .word 0x10
    .word 0x11
    .word 0x12
    .word 0x13
    .word 0x1c
    .word 0x1e
    .word task1
    .word 0x01000000
    .zero 960
.align 2
.type task_stack2, %function
task_stack2:
    .word 0x28
    .word 0x29
    .word 0x2a
    .word 0x2b
    .word 0x24
    .word 0x25
    .word 0x26
    .word 0x27
    .word 0x20
    .word 0x21
    .word 0x22
    .word 0x23
    .word 0x2c
    .word 0x2e
    .word task2
    .word 0x01000000
    .zero 960

.align 2
.type task_stack3, %function
task_stack3:
    .word 0x38
    .word 0x39
    .word 0x3a
    .word 0x3b
    .word 0x34
    .word 0x35
    .word 0x36
    .word 0x37
    .word 0x30
    .word 0x31
    .word 0x32
    .word 0x33
    .word 0x3c
    .word 0x3e
    .word task3
    .word 0x01000000