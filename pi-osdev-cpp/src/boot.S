.section ".text.boot"  // Make sure the linker puts this at the start of the kernel image

.global _start  // Execution starts here

_start:
    // Check processor ID is zero (executing on main core), else hang
    mrs     x1, mpidr_el1
    and     x1, x1, #3
    cbz     x1, 2f
    // We're not on the main core, so hang in an infinite wait loop
1:  wfe
    b       1b
2:  // We're on the main core!

    // Set stack to start below our code
    adrp    x1, _start            // Load address of _start into x1 (page address)
    add     x1, x1, :lo12:_start  // Adjust x1 with lower 12 bits offset
    mov     sp, x1                // Move value from x1 to stack pointer (sp)

    // Clean the BSS section
    adrp    x1, __bss_start       // Load address of __bss_start into x1 (page address)
    add     x1, x1, :lo12:__bss_start // Adjust x1 with lower 12 bits offset
    ldr     w2, __bss_size        // Load size of __bss_size into w2
3:  cbz     w2, 4f               // Quit loop if zero
    str     xzr, [x1], #8         // Store zero to memory at address x1, then add 8 to x1
    sub     w2, w2, #1            // Subtract 1 from w2
    cbnz    w2, 3b               // Loop if non-zero

    // Jump to our main() routine in C (make sure it doesn't return)
    bl      main
    // In case it does return, halt the master core too
1:  wfe
    b       1b
4:
