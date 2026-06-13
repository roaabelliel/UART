# Hierarchical UART Transmitter & Receiver in Verilog RTL

A hardware implementation of a Universal Asynchronous Receiver-Transmitter (UART) protocol engine, written in synthesizable Verilog RTL. The architecture features a highly modular, decoupled design with independent transmitter (TX) and receiver (RX) sub-systems synchronized to an internal clock-enabling generator.

---

## 1. Architectural Design & Features


```

```
           ┌────────────────────────────────────────┐
           │         Baud Rate Generator            │
           └───────────┬────────────────┬───────────┘
                       │ (rx_tick)      │ (tx_tick)
                       ▼                ▼

```

Parallel  ┌─────────────────────────┐  ┌─────────────────────────┐  Parallel
Data In ──►    UART Transmitter     │  │      UART Receiver      │──► Data Out
│         (TX)            │  │          (RX)           │
└─────────────┬───────────┘  └─────────────▲───────────┘
│                            │
▼ (Serial TX)                ▲ (Serial RX)
[tx]                         [rx]

```

* **Independent Full-Duplex Operation:** Fully decoupled TX and RX datapaths allowing simultaneous, bi-directional serial transmission.
* **Modular Clock-Gating Topology:** Employs an explicit baud-rate generator producing sampling micro-ticks ($16\times$ oversampling for RX, $1\times$ for TX) to preserve a synchronous, single-clock domain across the entire SoC fabric.
* **Robust Noise/Jitter Immunity:** The receiver architecture utilizes a mid-bit majority vote oversampling technique to ensure reliable clock alignment and noise filtering on noisy serial lines.
* **Configurable Protocol Parameters:** Designed with parameters for straightforward adjustment of data bit width (default: 8-bit), parity configuration, and stop-bit constraints.

---

## 2. Hardware Sub-Systems & RTL Topology

The top-level controller coordinates three independent physical hardware blocks instantiated hierarchically:

### A. Baud Rate Generator
Acts as a programmatic digital frequency divider. It tracks input global clock frequencies and scales them down via counter registers to target baud rates (e.g., 9600, 115200 bps), outputting stable enabling pulses (`tick`).

### B. UART Transmitter (TX)
An FSM-driven parallel-to-serial converter. Upon assertion of the transmit load signal, data is latched into an internal shift register. The state machine transitions sequentially through:
1. `IDLE`: Maintains line high.
2. `START`: Pulls serial line low for 1 bit period.
3. `DATA`: Shifts out data bits sequentially synchronized to the baud tick.
4. `STOP`: Assures transmission termination and transitions back to `IDLE`.

### C. UART Receiver (RX)
A serial-to-parallel converter utilizing a $16\times$ oversampling rate. To minimize Bit Error Rate (BER) caused by phase misalignment, the receiver samples the serial input line at the $8^{\text{th}}$ tick of the mid-bit window, shifting data bits into a parallel holding register before raising a data-ready validation flag.

---

## 3. Repository Directory Structure


```

UART/
│
├── rtl/
│   ├── uart_top.v            # Structural top-level module (Instantiations)
│   ├── uart_tx.v             # Transmitter FSM and shift logic
│   ├── uart_rx.v             # Receiver oversampling shift register
│   └── baud_gen.v            # Clock divider and tick generator
│
├── testbenches/
│   ├── tb_uart_top.v         # Full loopback validation bench
│   ├── tb_uart_tx.v          # Standalone TX stimulus generator
│   └── tb_uart_rx.v          # Standalone RX frame generator
│
├── sim/
│   └── wave_config.do        # ModelSim waveform display layout
│
└── README.md

```

---

## 4. Verification & Simulation Strategy

Functional validation was performed using directed verification testbenches in **ModelSim** and **Vivado**:

1. **Standalone Sub-System Testing:** The TX and RX blocks were simulated independently to guarantee precise timing margins during bit-shifting states.
2. **Full Closed-Loop Loopback Testing:** The serial output line (`tx`) was tied directly to the serial input line (`rx`) inside a top-level testbench. Random 8-bit payloads were written continuously to verify data integrity, transient flag assert timings (`tx_done`, `rx_ready`), and protocol edge-case behaviors (e.g., back-to-back packet frames).

---

## 5. Tool Setup & Synthesis

* **Design Entry & Formatting:** VS Code
* **Simulation & RTL Verification:** Mentor Graphics ModelSim / AMD Xilinx Vivado Simulator
* **Target Optimization FPGA Engine:** Intel Quartus Prime (Prime-Lite Edition) / AMD Vivado RTL Compiler
