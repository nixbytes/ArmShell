// ASM Shell

.section .date 
    prompt: .ascii "\n@> "
    prompt_len: .word 3
    buffer: .fill 100, 1, 0 // reserve 100 bytes for prompt
    

_start:

main_loop:
    bl display_prompt

display_prompt:
    
