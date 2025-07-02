# RTL2SDC_TCL
A TCL-based tool that parses RTL files (Verilog/VHDL/System Verilog) to automatically generate Synopsys Design Constraints (SDC) files for timing analysis. Supports [specific tools, e.g., Yosys, Vivado, Synopsys or OpenTimer]. Ideal for ASIC/FPGA design flows.

## Overview
`RTL2SDC_TCL` is a TCL-based tool that automates the generation of Synopsys Design Constraints (SDC) files from RTL designs (Verilog or VHDL). This tool is designed for ASIC and FPGA designers to streamline timing constraint creation for use in synthesis and static timing analysis (STA) workflows.

## Prerequisites
- **TCL Interpreter**: Ensure a TCL environment is installed (e.g., included with tools like Vivado, Synopsys Design Compiler, or Yosys).
- **RTL Files**: Verilog (`.v`) or VHDL (`.vhd`) or (`.sv`) files as input.
- **EDA Tool**: A compatible EDA tool (e.g., Vivado, Yosys, or Synopsys tools) for processing the generated SDC file.

## Usage
To generate an SDC file from your RTL design, use the following command in your TCL-compatible EDA tool environment:

```tcl
source ./TCL/GEN/RTL2SDC.tcl
