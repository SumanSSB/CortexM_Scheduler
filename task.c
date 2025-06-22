#include "task.h"

#define MAX_MEM_SIZE  4096
uint8_t memory[MAX_MEM_SIZE] = {0};
size_t  mem_ptr = 0;
tcb_t* head = NULL;


void* task_malloc(size_t size){

    size = (size + 3) & (~0x03);    // 4 byte alignment
    if(size + mem_ptr >= MAX_MEM_SIZE){
        return NULL;
    }

    void* mem_addr = &memory[mem_ptr];
    mem_ptr = mem_ptr + size;
    return mem_addr;
}


uint32_t taskcreate(void (*task_ptr)(void), size_t size){

    uint32_t* stack = (uint32_t*)task_malloc(size*4); // 32 bit alignment
    if(stack == NULL){
        return -1;
    }
    tcb_t* tcb = (tcb_t*)task_malloc(sizeof(tcb_t));
    if(tcb == NULL){
        mem_ptr = mem_ptr - size; // free up the memory if tcb was not allocated
        return -1;
    }

    tcb->task = task_ptr;
    tcb->stack_base = stack;
    tcb->stack_pointer = stack + size;

    if(head == NULL){
        tcb->next = tcb;
        head = tcb;
    }
    else{
        tcb_t* temp = head;
        while(temp->next != head){
            temp = temp->next;
        }
        temp->next = tcb;
        tcb->next = head;
    }
    return 0;
}

void startschedule(void){
    SYST_CSR = 0x07;
    __asm(
        "LDR r0, =head      \n"     // &head
        "LDR r0, [r0]       \n"     // head
        "LDR r1, [r0, #0]   \n"     // head->sp
        "MSR psp, r1        \n"     // update sp value
        "MOV r2, #2         \n"
        "MSR CONTROL, r2    \n"     // change stack from msp to psp
        "LDR r1, [r0, #8]   \n"     // head->task
        "BX  r1             \n"
        );
}

void sys_tick(void){
    volatile uint32_t i = 0;
}
