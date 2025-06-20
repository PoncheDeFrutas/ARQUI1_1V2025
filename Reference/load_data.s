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

// External function declarations

// Function to load data from a file
// x0 contains the address of the string to convert
// Store the address of the string in x20

// Find the first newline character in the string
// Load byte from string and increment pointer
// Check if character is newline (ASCII 10)
// If newline found, go to replace
// Check if end of string (null terminator)
// If end of string, go to open file
// Continue searching for newline

// Replace the first newline character with a null terminator
// Move back to the character before newline
// Replace newline with null terminator
// Store null terminator at the position

// Open the file specified in the string
// Open file
// File name
// Read-only mode
// syscall number for open
// Make the syscall
// File descriptor

// Read the contents of the file
// File descriptor
// Buffer to hold file contents
// Number of bytes to read (1 KB)
// syscall number for read
// Make the syscall

// Print the contents of the file
// File descriptor for stdout
// Buffer containing file contents
// Number of bytes to print (1 KB)
// syscall number for write
// Make the syscall

/*
// Count the number of newlines in the file contents
// Load address of file buffer
// Call count function
*/

// Close the file after reading
// File descriptor
// syscall number for close
// Make the syscall
// Go back to the main loop

// Buffer to hold file contents (1 KB)
