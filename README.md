# FSM Sequence Detector (Verilog)

## Description
This project implements a Moore Finite State Machine (FSM) in Verilog to detect multiple predefined 11-bit binary sequences. The design supports overlapping sequences and includes gap control logic between successive detections.

## Features
- Detects multiple binary sequences
- Moore machine-based design
- Supports overlapping sequence detection
- Gap control between detections
- Fully described using state transition logic

## Design Details
- Type: Moore FSM
- Input: Serial binary input (X)
- Output: High when sequence is detected
- Reset and Clock controlled operation

## Working Principle
- The FSM transitions through states corresponding to bits of input sequences
- When a complete sequence is matched, the system enters a detection state (SD)
- Output becomes HIGH only in detection state
- After detection, gap states (G0, G1, G2) ensure spacing before next detection

## States
- S0: Initial state
- A, B, C series: Sequence tracking states
- SD: Sequence detected
- G0, G1, G2: Gap control states

## Tools Used
- Verilog HDL
- Simulation tool -  Vivado

