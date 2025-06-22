.equ SYST_CSR,   0xE000E010
.equ SYST_RVR,   0xE000E014
.equ SYST_CVR,   0xE000E018
.equ SYST_CALIB, 0xE000E01C
.equ SYST_RELOAD, 0x00FFFFFF
.equ TSTACK_BLOCK, 0x20001FEC
.equ TTSTACK_LIMIT, 0x20002000

.extern task1
.extern task2
.extern task3

.section .vectors
vector_table:
    .word 0x20002000
    .word reset_handler
    .word 0
    .word hard_fault
    .zero 44
    .word sys_tick
    .zero 440
    .section .text
    .align 1
    .type reset_handler, %function

reset_handler:

    LDR r0, =SYST_RELOAD  // Configuring SysTick 
    LDR r1, =SYST_CSR
    LDR r2, =SYST_RVR
    str r0, [r2]
    bl main
    //mov r0, #7
    //str r0, [r1]
    b .


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


hard_fault:
    b .


    