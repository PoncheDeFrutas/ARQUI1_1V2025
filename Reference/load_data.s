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
    x20 - temporary register to hold the address of the string
    x8  - syscall number for open
    x9  - file descriptor returned by the syscall
*/

// Global declarations
.global load_data

// External function declarations
.extern while
.extern count_partial
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
    beq .load_data_Close_file

    mov x10, x0             // Number of bytes read
    mov x0, x1              // x0 = address of buffer
    mov x1, x10             // x1 = number of bytes read
    bl count_partial        // Call count_partial to count newlines in the buffer

    add x21, x21, x0        // Add the count of newlines to total count

    b .load_data_Read_File_loop

.load_data_Print:
    mov x0, 1               // File descriptor for stdout
    ldr x1, =file_buffer    // Buffer containing file contents
    mov x2, 1024            // Number of bytes to print (1 KB)
    mov x8, 64              // syscall number for write
    svc 0                   // Make the syscall

// Close the file after reading
.load_data_Close_file:
    mov x0, x9              // File descriptor
    mov x8, 57              // syscall number for close
    svc 0                   // Make the syscall
    b while                 // Go back to the main loop

.section .bss
file_buffer: 
    .skip 1024    // Buffer to hold file contents (1 KB)
