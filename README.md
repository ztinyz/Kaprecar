# Kaprecar

> A 16-bit assembly program that calculates how many steps you need to get from a given number to the Kaprecar constant.

## Description

Kaprecar is a small assembly-language project written in 16-bit x86 (or similar) that computes, for a given integer input, how many iterations (steps) are needed to reach the so-called “Kaprecar constant.” It demonstrates low-level programming and algorithmic logic with raw assembly code.  

This can be useful for:  
- learning (or teaching) assembly programming;  
- exploring number theory / iterative numeric processes;  
- practicing low-level coding and build workflows;  
- experimenting with input handling, loops, conditionals and integer arithmetic at the assembly level.

## Repository Contents (at a glance)
Kaprecar/
├── main.asm # Main assembly source file
├── test.asm # Sample / test inputs or example usage
├── *.obj / *.lst # Assembler output / listing / object files (after build)
├── *.exe / *.map # Compiled binaries / map files (after linking)
└── (other build-related files)

## Requirements / Tools

- A 16-bit capable assembler / linker (e.g. MASM, TASM, NASM with 16-bit mode, or other x86 assembler that supports 16-bit code)  
- A DOS / emulator or environment capable of running 16-bit executables (or equivalent compatibility layer)  
- Basic knowledge of assembly language and command-line build tools  

## Building & Running

Example (assuming use of TASM assembler):
assembler main.asm          # assemble to object file
link main.obj               # link to produce executable (or use appropriate commands)

Then run:
./main.exe                  # or, in DOS / emulator environment

##Usage

Provide an integer (input) to the program (e.g. via command-line prompt or by modifying source / input handling).
The program will compute how many iterations are needed to reach the “Kaprecar constant”.
The result (number of steps) will be output accordingly.
Note: Because this is a 16-bit program, ensure your environment supports 16-bit execution (DOS, emulator, or compatible setup).
