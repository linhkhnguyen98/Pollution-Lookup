//file header
    .arch armv6     //armv6 architecture
    .arm            //arm 32-bit IS
    .fpu vfp        //floating point co-processor
    .syntax unified //modern syntax

//function imports
    .extern printf

    .section .rodata
.Lmsg1: .string "Total size: %lu\n"
.Lmsg2: .string "Total entries: %lu\n"
.Lmsg3: .string "Longest chain: %lu\n"
.Lmsg4: .string "Shortest chain: %lu\n"
.Lmsg5: .string "Empty buckets: %lu\n"

    //.data         //uncomment if needed

    .text           //start of text segment

    .global print_info               //make print_info global for linking to
    .type   print_info, %function    //define print_info to be a function
    .equ 	FP_OFF, 32// FILL THIS 	 //fp offset distance from sp

print_info:	
// function prologue
    push    {r4-r10, fp, lr}         //save registers to the stack
    add     fp, sp, FP_OFF           //set frame pointer to frame base
// function body
    mov     r4, 0                   // total_entries = 0
    mov     r5, 0                   // longest_chain = 0
    mov     r6, 0x0fffffff          // shortest_chain = the biggest integer
    mov     r7, 0                   // i = 0
    mov     r8, 0                   // *head = 0
    mov     r9, 0                   // chain_size = 0
    mov     r10, 0                  // empty_buckets = 0
.LforBegin:
    cmp     r7, r1                  // if (i < size)
    beq     .LprintOut              // exit for loop
    mov     r3, r7                  // r3 = i
    lsl     r3, 2                   // i = i * 4
    ldr     r8, [r0, r3]            // head = table[i]
    mov     r9, 0                   // chain_size = 0
.LcheckHead:
    cmp     r8, 0                   // while head != 0
    beq     .LtotalEntries          //.
    ldr     r8, [r8, 24]            // head = head->next
    add     r9, r9, 1               // chain_size++
    b       .LcheckHead             //.

.LtotalEntries:
    add     r4, r4, r9              // total_entries += chain_size

.Llongest_chain:
    cmp     r9, r5                  // if chain_size > longest_chain
    blt      .LcompareWithZero      //.
    mov     r5, r9                  //longest_chain = chain_size

.LcompareWithZero:
    cmp     r9, 0                   // if chain_size == 0
    bne     .Lshortest_chain        //.
    add     r10, r10, 1             // empty_bucket++
    beq     .LforNext               //.

.Lshortest_chain:
    cmp     r9, r6                  // if chain_size < shortest chain
    bge     .LforNext               // move to the next iteration
    mov     r6, r9                  // shortest_chain = chain_size

.LforNext:
    add     r7, r7, 1               // i++
    bl      .LforBegin              //.

.LprintOut:
    // Total size
    ldr     r0, =.Lmsg1             // load msg1 to r0
    mov     r1, r1                  // r1 = total_size
    bl      printf                  // .
    // Total entries
    ldr     r0, =.Lmsg2             // load msg2 to r0
    mov     r1, r4                  // r1 = total_entries
    bl      printf                  // .
    // Longest chain
    ldr     r0, =.Lmsg3             // load msg3 to r0
    mov     r1, r5                  // r1 = longest_chain
    bl      printf                  //.
    // Shortest chain
    ldr     r0, =.Lmsg4             // load msg4 to r0
    mov     r1, r6                  // r1 = shortest_chain
    bl      printf                  //.
    // Empty Buckets
    ldr     r0, =.Lmsg5             // load msg5 to r0
    mov     r1, r10                 // r1 = empty_buckets
    bl      printf                  //.

// function epilogue
    sub     sp, fp, FP_OFF          //restore sp
    pop     {r4-r10, fp, lr}        //restore saved registers  
    bx      lr  

// function footer - do not edit below
    .size print_info, (. - print_info) // set size for function
// ==========================================================================

//file footer
    .section .note.GNU-stack,"",%progbits // stack/data non-exec (linker)
.end
