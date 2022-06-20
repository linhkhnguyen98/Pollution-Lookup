//file header
    .arch armv6     //armv6 architecture
    .arm            //arm 32-bit IS
    .fpu vfp        //floating point co-processor
    .syntax unified //modern syntax


    //.data         //uncomment if needed

    .text           //start of text segment

    .global node_lookup               //make node_lookup global for linking to
    .type   node_lookup, %function    //define node_lookup to be a function
    .equ 	FP_OFF, 28//FILL THIS 	  // fp offset distance from sp (#saved reg -1)*4
node_lookup:	
// function prologue
    push    {r4-r9, fp, lr}          //save registers to the stack
    add     fp, sp, FP_OFF            //set frame pointer to frame base
//function body
            ldr r4, [fp, 4]             // load the 5th parameter
.LreadStruct:
            cmp r0, 0                   //while front != NULL
            beq .LreturnZero            //.
            ldr r5, [r0, 0]             // r5 = front->year
            ldr r6, [r0, 4]             // r6 = front -> month
            ldr r7, [r0, 8]             // r7 = front -> day
            ldr r8, [r0, 12]            // r8 = front -> hour
            ldr r9, [r0, 24]            // r9 = front -> next


            cmp r5, r1                  //if front->year = year
            blt .LNext                  // .
            cmp r6, r2                  //if front->month = month
            blt .LNext                  // .
            cmp r7, r3                  // if front->day = day
            blt .LNext                  // .
            cmp r8, r4                  // if front->hour = hour
            beq .Lreturn                // .
.LNext:
            mov r0, r9                  // front = front->next
            b .LreadStruct              // .
.LreturnZero:
            mov r0, 0                   // return NUll
.Lreturn:
    
// function epilogue
    sub     sp, fp, FP_OFF              //restore sp
    pop     {r4-r9, fp, lr}             //restore saved registers  
    bx      lr                          //function return
// function footer - do not edit below
    .size node_lookup, (. - node_lookup) // set size for function

//file footer
    .section .note.GNU-stack,"",%progbits // stack/data non-exec (linker)
.end
