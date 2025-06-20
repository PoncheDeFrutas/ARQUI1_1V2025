/*

    This file is the main entry point for the TUI application.
    It initializes the application and starts the main event loop.
    Contains:
        - Welcome message
        - Menu options
        - User input handling
        - Print and read functions
        - Exit function

*/

/*

    Register usage:
    xzr - zero register (always 0)
    x0  - syscall return value or first argument
    x1  - first argument for syscall (file descriptor, address of string, etc.)
    x2  - second argument for syscall (length of string, size of buffer, etc.)
    x3  - third argument for syscall (optional, depends on syscall)
    x4  - fourth argument for syscall (optional, depends on syscall)
    x5  - fifth argument for syscall (optional, depends on syscall)
    x6  - sixth argument for syscall (optional, depends on syscall)
    x7  - seventh argument for syscall (optional, depends on syscall)
    x8  - syscall number
    x9  - temporary register
    x10 - temporary register
    x11 - temporary register
    x12 - temporary register
    x13 - temporary register
    x14 - temporary register
    x15 - temporary register
    x16 - temporary register
    x17 - temporary register
    x18 - temporary register
    x19 - temporary register
    x20 - temporary register
    x21 - Total count of newlines in the data
    x22 - Min
    x23 - Max
    x24 - temporary register
    x25 - temporary register
    x26 - temporary register
    x27 - temporary register
    x28 - temporary register
    x29 - frame pointer
    x30 - link register (return address)
    x31 - stack pointer
*/

.global _start
.global while
.global data_array
.global data_array_size

.extern atoi
.extern load_data

.section .text

_start:
    ldr x1, =welcome_message   // Load address of welcome message
    mov x2, 33                 // Length of welcome message
    bl print                    // Call print function    

// Main loop of the TUI application
while:
    ldr x1, =menu_options      // Load address of menu options
    mov x2, 64                 // Length of menu options
    bl print                    // Call print function

    ldr x1, =choose_option     // Load address of choose option message
    mov x2, 26                 // Length of choose option message
    bl print                    // Call print function

    bl read                     // Read user input
    ldr x0, =buffer             // Load address of buffer
    bl atoi                     // Convert input string to integer

    //cmp x0, 1                   // Compare input with 1 (statistics option)
    //beq statistics              // If input is 1, go to statistics

    cmp x0, 2                   // Compare input with 2 (predictions option)
    //beq predictions             // If input is 2, go to predictions

    cmp x0, 3                   // Compare input with 3 (set file option)
    beq set_file                // If input is 3, go to set file

    //cmp x0, 4                   // Compare input with 4 (set limits option)
    //beq set_limits              // If input is 4, go to set limits

    cmp x0, 5                   // Compare input with 5 (exit option)
    beq end                     // If input is 5, exit the application
    b while                     // Repeat the loop

// Function to handle set file option
// This function prompts the user to set the file name and loads data from that file 
set_file:
    ldr x1, =set_file_message  // Load address of set file message
    mov x2, 45                 // Length of set file message
    bl print                    // Call print function
    bl read                     // Read user input for file name
    ldr x0, =buffer             // Load address of buffer
    bl load_data                // Load data from the file specified in buffer

// Function to print a string
print:
    mov x0, 1                   // File descriptor for stdout
    mov x8, 64                  // syscall number for write
    svc 0                       // Make the syscall
    ret                         // Return from print function (x30 will be the return address)

// Function to read user input
read:
    mov x0, 0                   // File descriptor for stdin
    ldr x1, =buffer             // Address of the buffer to read into
    mov x2, 256                 // Size of the buffer
    mov x8, 63                  // syscall number for read
    svc 0                       // Make the syscall
    ret                         // Return from read function (x30 will be the return address)

// Function to exit the application
end:
    mov x0, 0                   // Exit code
    mov x8, 93                  // syscall number for exit
    svc 0                       // Make the syscall


// Strings for the TUI application
.section .data
welcome_message:
    .ascii "\nWelcome to the TUI application!\n"
menu_options:
    .ascii "\n1. Statistics\n2. Predictions\n3. Set File\n4. Set Limits\n5. Exit\n"
choose_option:
    .ascii "\nPlease choose an option: "
set_file_message:
    .ascii "\nSet the name of the file to load data from: "
newline:
    .ascii "aaaaaaaaaaaaaaaaaaaaaaaa\n"

// Buffer for user input
.section .bss
buffer:
    .space 256                  // Buffer for user input
file_name:
    .space 32                   // Buffer for file name input


.section .bss
    .align 3                    // Align to 8-byte boundary
data_array:                     
    .skip 8                     // Reserve space for data array (8 bytes for a pointer)

data_array_size:
    .skip 8                     // Reserve space for data array size (8 bytes for a size_t)