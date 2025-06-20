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
    x20 - pointer to any string to print
    x21 - length of the string to print
    x22 - temporary register
    x23 - temporary register
    x24 - temporary register
    x25 - temporary register
    x26 - temporary register
    x27 - temporary register
    x28 - temporary register
    x29 - frame pointer
    x30 - link register (return address)
    x31 - stack pointer
*/

// Global declarations

// External function declarations

// Section declarations

// Load address of welcome message
// Length of welcome message
// Call print function    

// Main loop of the TUI application
// Load address of menu options
// Length of menu options
// Call print function

// Load address of choose option message
// Length of choose option message
// Call print function

// Read user input
// Load address of buffer
// Convert input string to integer

// Compare input with 2 (predictions option)

// Compare input with 3 (set file option)
// If input is 3, go to set file

// Compare input with 5 (exit option)
// If input is 5, exit the application
// Repeat the loop

// Function to handle set file option
// This function prompts the user to set the file name and loads data from that file 
// Load address of set file message
// Length of set file message
// Call print function
// Read user input for file name
// Load address of buffer
// Load data from the file specified in buffer

// Function to print a string
// File descriptor for stdout
// Address of the string to print
// Length of the string
// syscall number for write
// Make the syscall
// Return from print function (x30 will be the return address)

// Function to read user input
// File descriptor for stdin
// Address of the buffer to read into
// Size of the buffer
// syscall number for read
// Make the syscall
// Return from read function (x30 will be the return address)

// Function to exit the application
// Exit code
// syscall number for exit
// Make the syscall

// Strings for the TUI application

// Buffer for user input
