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
