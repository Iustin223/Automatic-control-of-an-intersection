## Intersection Traffic Control System (Verilog)

This project implements a digital control system for a standard 4-way intersection (North, South, East, West) using **Verilog HDL**.
The system is built upon a hierarchical Finite State Machine (FSM) architecture to efficiently manage both vehicular and pedestrian traffic flows.

Traffic access rotates through the intersection in a specific priority order: **South ➞ North ➞ East ➞ West**.

* Parameterizable Timing: The duration for Green and Yellow lights can be configured individually for every direction via parameters.

* On-Demand Pedestrian Crossing: Pedestrian phases are skipped unless the button (`pietoni_btn_i`) is pressed during the active cycle
* Service Mode: Asynchronous input (`service_i`) forces all lights to "Blinking Yellow" (cars) and "Blinking Green" (pedestrians)
* Custom Timings: Parameterized durations for Green (24s-29s), Yellow (2s), and Pedestrian Walk (12s)

### Simulation Scenarios (Testbench)

The system behavior is verified through the following test cases:

1. Standard Cycle (No Pedestrians)
* **Action:** System runs freely without inputs.
* **Result:** Cycles S-N-E-V. Pedestrian states are **skipped** for efficiency.

### 2. Pedestrian Request
* **Action:** Button pressed during the Green light phase.
* **Result:** System waits for the Yellow phase to end, then activates **Pedestrian Green (12s)** + **Blinking (6s)** before switching directions[cite: 101].

### 3. Service/Emergency Mode
* **Action:** `service_i` set to High.
* **Result:** Immediate override to **Blinking Mode** regardless of current state. Returns to IDLE when released.

### System Reset
* **Action:** `rst_n` (Active Low) applied.
* **Result:** Instant reset to default Red state.

### Source Files
- `semaforConexiuni.v` - Top Module.
- `logicaControlFSM.v` - Main Priority Controller.
- `autoSem.v` - Individual Traffic Light Logic.
- `testbench.v` - Simulation & Verification.
  
Project developed for the Programmable Logic Circuits course
