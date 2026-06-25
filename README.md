# Digital Design HDL

A growing collection of SystemVerilog modules, testbenches, synthesis results, and FPGA exercises created while learning digital logic and computer architecture.

The repository follows *Digital Design and Computer Architecture: RISC-V Edition* by Sarah Harris and David Harris.

## Current Focus

The current work covers Chapter 4 topics, including:

- combinational and sequential logic
- structural and behavioral SystemVerilog
- blocking and nonblocking assignments
- registers, counters, and finite state machines
- self-checking testbenches
- simulation with Icarus Verilog
- synthesis and schematic inspection with Vivado.

## Repository Structure

```text
digital-design-hdl/
├── textbook-module-practice/
│   └── chapter04-hdl/
│       ├── combinationalLogic/
│       └── sequentialLogic/
└── README.md
```

### [Combinational Logic](textbook-module-practice/chapter04-hdl/combinationalLogic)

SystemVerilog modules whose outputs depend only on their current inputs. Examples include Boolean functions, reduction operators, function selectors, and a small ALU.

### [Sequential Logic](textbook-module-practice/chapter04-hdl/sequentialLogic)

Clocked modules whose outputs depend on stored state. Examples include resettable registers, sample-history registers, counters, sequence detectors, and finite state machines. This section also includes self-checking testbenches and simulation commands.

Each module folder may contain:

```text
moduleName/
├── src/             # Synthesizable SystemVerilog source
├── testbenches/     # Simulation-only verification code
└── images/          # Vivado synthesized schematics or waveforms
```

The README files inside each topic folder contain module descriptions, source excerpts, testbench behavior, simulation commands, and synthesis images.

## Tools

- **SystemVerilog** - RTL design and testbenches
- **Icarus Verilog** - command-line compilation and simulation
- **GTKWave** - waveform viewing when needed
- **Vivado** - synthesis, implementation, and FPGA programming
- **Basys 3** - physical FPGA demonstrations for modules that benefit from switches, LEDs, clocks, or other board I/O

## Running a Testbench

From a module folder, compile the design and its testbench using SystemVerilog support:

```powershell
iverilog -g2012 -s <testbench_module> -o simulation.vvp src\<module>.sv testbenches\<testbench>.sv
```

Run the compiled simulation:

```powershell
vvp simulation.vvp
```

The self-checking testbenches report whether the tested behavior passed or failed.
