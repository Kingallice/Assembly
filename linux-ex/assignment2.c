#include "cdecl.h"
#include <stdio.h>
#include <string.h>

int PRE_CDECL asm_main( void ) POST_CDECL;

static int global_static_variable = 43980;  //ABCC  #2
static int global_variable = 43979;         //ABCB  #1

void check_static()
{
    static int static_local_variable_in_fun_o_main = 43978; //ABCA  #6
    int local_variable_in_fun_o_main = 43982;               //ABCE  #5  - Memory?
    printf("%d\n\n", global_variable);
}

int main()
{
    printf("In driver");
    static int static_local_variable_in_main = 43983;   //ABCF #4
    int local_variable_in_main = 43984;                 //ABD0  #3  - Stack?
    check_static();

    int ret_status;
    ret_status = asm_main();
    return ret_status;
}

