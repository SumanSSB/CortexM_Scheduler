#include "task.h"

uint32_t task1_val;
uint32_t task2_val;
uint32_t task3_val;

void task1(void){
    task1_val = 0;

    while(1){
        for(uint32_t i=0; i<10000; i++){

        }
        task1_val = task1_val + 1;
    }
}

void task2(void){
    task2_val = 0;

    while(1){
        for(uint32_t i=0; i<10000; i++){

        }
        task2_val = task2_val + 1;
    }
}

void task3(void){
    task3_val = 0;

    while(1){
        for(uint32_t i=0; i<10000; i++){

        }
        task3_val = task3_val + 1;
    }
}

void main(){
    uint32_t res = 0;
    res = taskcreate(task1, 256);
    res = taskcreate(task2, 256);
    res = taskcreate(task3, 256);
    startschedule();

    return; // It should not return from main if task gets created
}