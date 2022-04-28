# Processor Checkpoint for ECE 350
## Arjun Peri
###
This project implements a simulated five-stage single-issue 32-bit processor using Verilog. Some of the major components designed to support the processor include: 
- Arithmetic Logic Unit (ALU) that supports:
  - A Two Level Carry Look-Ahead Adder with support for addition & subtraction
  - A 32-bit barrel shifter with both arithmetic and logical shifting
- Signed 32-bit integer multiplier and divider unit that: 
  - Handles signed integers in two’s complement
  - Handles 32-bit integers and correctly asserts a data_exception on overflow
  - Correctly asserts the data_resultRDY signal when a correct result is produced
  - Correctly asserts a data_exception on a division by zero
- Register file that supports: 
  - 2 read ports
  - 1 write port
  - 32 registers (registers are 32-bits wide)


This proccessor uses pipeline latches, implements bypassing to maximize efficiency (i.e. avoid stalls), and handles hazards.










