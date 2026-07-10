# AXI4-Lite Slave Interface (Verilog)

## Overview
This project implements a 32-bit AXI4-Lite Slave interface in Verilog. It supports read and write transactions using four internal registers.

## Features
- AXI4-Lite protocol
- 32-bit data bus
- Four 32-bit registers (reg0–reg3)
- Read and Write operations
- Address decoding
- Custom Verilog testbench

## Register Map

| Address | Register |
|---------|----------|
| 0x00 | reg0 |
| 0x04 | reg1 |
| 0x08 | reg2 |
| 0x0C | reg3 |

## Files
- axi4_lite.v
- axi4_lite_tb.v
- Waveform screenshots

## Tools Used
- Verilog HDL
- Xilinx Vivado Simulator

## Author
Aman Trivedi
