# Performance Modeling & Design of Pipelined MIPS Processor

This repository contains a Verilog **simulation model** that emulates the behavior of a simplified 32-bit, **5-stage pipelined MIPS-like processor** optimized for a **dot product** workload. Two versions are implemented:

- **Without forwarding**: illustrates how RAW hazards degrade performance without bypassing
- **With forwarding**: adds forwarding paths and a load-use stall mechanism to mitigate hazards and improve performance

> This project is a behavioral **pipeline simulation**, not a complete hardware MIPS CPU implementation.

---

## Pipeline Overview

Both versions follow the classic 5-stage pipeline:

1. **IF**: Instruction Fetch  
2. **ID**: Instruction Decode  
3. **EX**: Execute  
4. **MEM**: Memory Access  
5. **WB**: Write Back  

---

## Implemented Instruction Subset

The implemented subset (used for the dot product program) includes:

- **R-type**: `add`, `mul`
- **Immediate**: `addi`, `subi`
- **Memory**: `lw`, `sw`
- **Control flow**: `beq`, `j`, `jr`

### Minor Sequence Change (per report)

To simplify unsigned arithmetic handling, the following substitution was made:

```asm
# original
addi $7, $7, -1

# replaced by
subi $7, $7, 1
```

Instruction ordering was also adjusted to reduce/control hazards around loop behavior.

---

## Version A: Pipeline Without Forwarding (`pipe_MIPS32_noforward`)

- No hardware forwarding paths are provided
- RAW hazards must be avoided by **manual NOP insertion** in the instruction stream / testbench
- Control-flow instructions (`beq`, `j`, `jr`) are resolved in the **IF stage** using long combinational logic
- A **one-cycle flush** is applied on control transfer (control penalty)

---

## Version B: Pipeline With Forwarding (`pipe_MIPS32`)

This version adds combinational forwarding paths into the EX stage to reduce stalls:

- Forward from **EX/MEM** for ALU results
- Forward from **MEM/WB** for ALU results
- Forward from **MEM/WB** for `lw` results (available after MEM)

### Load-Use Stall

A **1-cycle stall (bubble)** is still required for load-use hazards, because load data is not available until after the MEM stage.

### Forwarding Control Signals (as described in the report)

Examples of forwarding/bypass flags used conceptually in the design:

- `bypassAfromMEM`, `bypassBfromMEM`
- `bypassAfromALUinWB`, `bypassBfromALUinWB`
- `bypassAfromLWinWB`, `bypassBfromLWinWB`

---

## Testbenches

Two testbenches are used:

- `test_mips32_noforwarding`  
  - Designed for the **no-forwarding** pipeline  
  - Includes manual NOP insertions to avoid hazards  
  - Dumps waveform: `test_mips32_noforwarding.vcd`

- `test_MIPS32`  
  - Designed for the **forwarding** pipeline  
  - Relies on forwarding + load-use stall logic (no manual NOP padding)  
  - Dumps waveform: `test_MIPS32.vcd`

---

## Dot Product Workload

The dot product program computes the dot product of two vectors:

- Vector A: `[0, 1, 7, 5, 1, 5, 0, 0, 4]`
- Vector B: `[4, 5, 1, 9, 5, 9, 4, 4, 8]`

Expected result:

- Dot Product = **139**

Correctness is verified by observing the accumulation register reaching **139** in simulation waveforms.

---

## Performance Results (From Waveforms)

Completion times reported from waveform markers:

- **Without forwarding**: completes at **1525 ns**
- **With forwarding**: completes at **985 ns**
- Pipeline cycle time: **10 ns**

Performance improvement:

- Forwarding version finishes **54 cycles earlier**
- Speedup: **1525 / 985 ≈ 1.548×**

---

## Notes and Limitations

- This is a **Verilog behavioral simulation** of a pipelined MIPS-like processor, not a full hardware CPU
- Control-flow resolution is simplified by resolving `beq`, `j`, and `jr` in the IF stage and applying a flush
- The **2-bit branch predictor** originally required by the assignment is **not implemented**

---

## Repository Layout 

```text
.
├── src/
│   ├── pipe_MIPS32_noforward.v
│   └── pipe_MIPS32.v
├── tb/
│   ├── test_mips32_noforwarding.v
│   └── test_MIPS32.v
└── report/
    └── EE271_Project2_Report_Yu-Kuan_Lin_#017515004.pdf
```

---

## Author

Yu-Kuan Lin
