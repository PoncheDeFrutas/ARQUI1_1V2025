/*

    * load_data.s
    * This file contains the assembly code for loading data from a file.
    * It uses the syscall interface to open a file and read its contents.
    * The file name is passed in x0, and the file descriptor will be returned in x9.
    *

*/


/*

    Register usage:
    x0  - pointer to the string containing the file name
    x1  - pointer to the current character in the string
    x2  - length of the string (not used in this code)
    x8  - syscall number for open
    x9  - file descriptor returned by the syscall
    x10 - number of bytes read from the file
    x20 - temporary register to hold the address of the string
    x21 - total count of newlines in the data
*/

// Global declarations
.global load_data

// External function declarations
.extern while
.extern count_partial
.extern atoi_partial
.extern data_array
.extern data_array_size

.section .text

// Function to load data from a file
load_data:
    mov x1, x0              // x0 contains the address of the string to convert
    mov x20, x1             // Store the address of the string in x20
    mov x21, 0              // Initialize x21 to 0 (total count of newlines)

// Find the first newline character in the string
.find_newline:
    ldrb w2, [x1], 1        // Load byte from string and increment pointer
    cmp w2, 10              // Check if character is newline (ASCII 10)
    beq .replace_newline    // If newline found, go to replace
    cmp w2, 0               // Check if end of string (null terminator)
    beq .load_data_Open_file // If end of string, go to open file
    b .find_newline         // Continue searching for newline

// Replace the first newline character with a null terminator
.replace_newline:
    sub x1, x1, 1           // Move back to the character before newline
    mov w2, 0               // Replace newline with null terminator
    strb w2, [x1]           // Store null terminator at the position

// Open the file specified in the string
.load_data_Open_file:
    mov x0, -100            // Open file
    mov x1, x20             // File name
    mov x2, 0               // Read-only mode
    mov x8, 56              // syscall number for open
    svc 0                   // Make the syscall
    mov x9, x0              // File descriptor

// Read the contents of the file
.load_data_Read_File_loop:
    mov x0, x9              // File descriptor
    ldr x1, =file_buffer    // Buffer to hold file contents
    mov x2, 1024            // Number of bytes to read (1 KB)
    mov x8, 63              // syscall number for read
    svc 0                   // Make the syscall

    cmp x0, 0               // Check if read returned 0 (EOF)
    beq .load_data_free_memory

    mov x10, x0             // Number of bytes read
    mov x0, x1              // x0 = address of buffer
    mov x1, x10             // x1 = number of bytes read
    bl count_partial        // Call count_partial to count newlines in the buffer

    add x21, x21, x0        // Add the count of newlines to total count

    b .load_data_Read_File_loop

.load_data_free_memory:
    ldr x0, =data_array
    ldr x1, [x0]            // x1 = actual address
    cbz x1, .load_data_reserve_memory     // If it is 0, there is nothing to free

    ldr x2, =data_array_size
    ldr x1, [x2]            // x1 = previous size in elements
    mov x3, 8
    mul x1, x1, x3          // size in bytes

    mov x0, x1              // original address
    mov x1, x1              // length
    mov x8, 215             // syscall munmap
    svc 0

.load_data_reserve_memory:
    mov x0, 0           // addr
    mov x1, x21         // número de elementos
    mov x2, 8
    mul x1, x1, x2      // x1 = total size (length)
    mov x2, 3           // PROT_READ | PROT_WRITE
    mov x3, 0x22        // MAP_PRIVATE | MAP_ANONYMOUS
    mov x4, -1          // fd
    mov x5, 0           // offset
    mov x8, 222         // mmap syscall
    svc 0


    cmp x0, -1              // Check if mmap failed
    beq .load_data_Close_file // If mmap failed, close the file and exit

.save_new_address:
    ldr x1, =data_array
    str x0, [x1]            // Save new address in data_array

    // Save new size in data_array_size
    ldr x1, =data_array_size
    mov x2, x21
    str x2, [x1]            // Save new size in data_array_size

.reset_file_reading:
    mov x0, x9              // File descriptor
    mov x1, 0               // Offset
    mov x2, 0               // Whence (SEEK_SET)
    mov x8, 62              // syscall number for lseek
    svc 0                   // Make the syscall

    mov x11, 0              // Reset x11 to 0 (used for counting elements)
    mov x12, 0              // Reset x12 to 0 (used for partial value)
    mov x13, 0              // Reset x13 to 0 (used for accumulation flag)

.load_data_Read_File_loop2:
    mov x0, x9              // File descriptor
    ldr x1, =file_buffer    // Buffer to hold file contents
    mov x2, 1024            // Number of bytes to read (1 KB)
    mov x8, 63              // syscall number for read
    svc 0                   // Make the syscall

    cmp x0, 0               // Check if read returned 0 (EOF)
    beq .load_data_Close_file // If EOF, close the file and exit

    mov x10, x0             // Number of bytes read
    mov x0, x1              // x0 = address of buffer
    mov x1, x10             // x1 = number of bytes read

    bl atoi_partial         // Call count_partial to count newlines in the buffer

    b .load_data_Read_File_loop2

/*
// Print the contents of the file
.load_data_Print:
    mov x0, 1               // File descriptor for stdout
    ldr x1, =file_buffer    // Buffer containing file contents
    mov x2, 1024            // Number of bytes to print (1 KB)
    mov x8, 64              // syscall number for write
    svc 0                   // Make the syscall
*/

// Close the file after reading
.load_data_Close_file:
    mov x0, x9              // File descriptor
    mov x8, 57              // syscall number for close
    svc 0                   // Make the syscall
    b while                 // Go back to the main loop

.section .bss
file_buffer: 
    .skip 1024              // Buffer to hold file contents (1 KB)
