// ASM Shell

.section .date 
    prompt: .ascii "\n> "
    prompt_len: .word 3
    buffer: .fill 100, 1, 0 // reserve 100 bytes for prompt
    
.section .text
.global _start

_start:

main_loop:
    bl display_prompt

display_prompt:
    mov r0, #1              // File descriptor 1 (stdout)
    ldr r1, =prompt        // Load address of prompt
    ldr r2, =prompt_len    // Load address of the length word
    ldr r2, [r2]           // Dereference r2 to get the actual value (3)
    mov r7, #4              // syscall number for sys_write (ARM 32-bit is 4)
    swi 0                   // software interrupt (syscall)
    ret

read_input:
    mov r0, #0              // File descriptor 0 (stdin)
    ldr r1, =buffer         // Load address of our buffer
    mov r2, #100            // Max bytes to read
    mov r7, #3              // syscall number for sys_read (ARM 32-bit is 3)
    swi 0                   // software interrupt (syscall)
    ret

execute_command:
    // For now, we will just demonstrate the FORK logic.
    mov r7, #291            // syscall number for sys_fork (ARM 32-bit is 291)
    swi 0                   // software interrupt (syscall)

    // After fork, r0 contains: 0 if child, PID if parent
    cmp r0, #0
    beq child_process
    b   parent_process
