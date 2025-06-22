.equ SYST_CSR,   0xE000E010     // SysTick Control and Status Register
.equ SYST_RVR,   0xE000E014     // SysTick Reload Value Register
.equ SYST_CVR,   0xE000E018     // SysTick Current Value
.equ SYST_CALIB, 0xE000E01C
.equ SYST_RELOAD, 0x00FFFFFF


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
    LDR r2, =SYST_RVR
    str r0, [r2]
    bl main
    b .

hard_fault:
    b .




    