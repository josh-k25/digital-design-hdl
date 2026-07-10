# Digital Design HDL

SystemVerilog modules and testbenches created while working through *Digital Design and Computer Architecture: RISC-V Edition* by Sarah Harris and David Harris.

The repository is mainly used to practice digital design concepts before building a RISC-V processor.

## Topics

Current work includes:

- combinational and sequential logic
- arithmetic circuits
- registers and finite state machines
- register files and memories
- SystemVerilog RTL
- self-checking testbenches
- RISC-V architecture and CPU preparation


- src: synthesizable SystemVerilog
- testbenches: simulation and verification code
- images: schematics or waveforms when useful

## Tools

- SystemVerilog
- Icarus Verilog
- GTKWave
- Vivado
- Basys 3 FPGA

## Running a Testbench

From a module folder:

```powershell
iverilog -g2012 -s <module>_tb -o <module>_tb src\<module>.sv testbenches\<module>_tb.sv
vvp <module>_tb
```

Some modules depend on additional source files, which must also be included in the compile command.

The testbenches are self-checking and report whether the tested behavior passed or failed.
