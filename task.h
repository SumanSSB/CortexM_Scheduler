
#include <stdint.h>

#define NULL            ((void*)0)
typedef uint16_t        size_t;

typedef struct TCB{
    uint32_t* stack_pointer; // value of stack pointer
    uint32_t* stack_base;  // base of allocated stack 
    void (*task)(void); // function
    struct TCB* next;  // pointer to next task
}tcb_t;


uint32_t taskcreate(void (*task_ptr)(void), size_t size);
void startschedule(void);

