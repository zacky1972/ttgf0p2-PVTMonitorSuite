<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

PVTMonitorSuite integrates ring oscillators and flip-flop-based measurement circuits to quantify the timing characteristics of digital logic.

The suite supports the following measurements:

* An Inverter-based ring oscillator provides high-resolution estimates of gate propagation delay ($t_{pd}$).
* A NAND2-based ring oscillator provides high-resolution estimates of logic delay ($t_{pd}$) of NAND2.
* Standard, DICE, LEAP-DICE, and Quatro D flip-flops measure clock-to-Q and setup timing ($t_{clkq} + t_{setup}$).
* Clock skew timing ($t_{skew}$) is determined using XOR-based pulse width detection between two clock signals.

High-speed counters driven by the ring oscillators convert these delays into digital values, enabling precise evaluation of process, voltage, and temperature variations on a fully digital, open-access platform.

To meet TinyTapeout’s requirements, no standard cells from the GF180MCU D process are used, and the design passes all strict error and warning checks.

## How to test

### Measure $t_{pd}$ of an inverter

1. Connect `uo_out[0]` to your equipment to measure frequency.
2. Turn on `ui_in[0]`.
3. Measure the frequency.
4. Calculate $t_{pd, inv} = \frac{1}{32 N f}$.

### Measure $t_{pd}$ of a NAND2

1. Connect `uo_out[1]` to your equipment to measure frequency.
2. Turn on `ui_in[0]`.
3. Measure the frequency.
4. Calculate $t_{pd, NAND2} = \frac{1}{32 N f}$.

### Measure $t_{clkq} + t_{setup}$ of standard D-FF

1. Connect `ui_in[1]` to the oscillator that generates exactly 50 MHz.
2. Set `ui_in[7:5]` to 3'b000, to choose measurement of $t_{clkq} + t_{setup}$.
3. Turn off `ui_in[3]`.
4. Turn off `ui_in[2]` to reset.
5. Turn on `ui_in[2]`.
6. Turn on `ui_in[3]` to start.
7. Read `uio`.
8. Calculate $t_{clkq} + t_{setup} = \frac{uio \times 20}{16} - 2 \times t_{pd, NAND2}$, where $t_{pd, NAND2}$ is the result value of $t_{pd}$ of a NAND2.

### Measure $t_{clkq} + t_{setup}$ of DICE D-FF

1. Connect `ui_in[1]` to the oscillator that generates exactly 50 MHz.
2. Set `ui_in[7:5]` to 3'b001, to choose measurement of $t_{clkq} + t_{setup}$.
3. Turn off `ui_in[3]`.
4. Turn off `ui_in[2]` to reset.
5. Turn on `ui_in[2]`.
6. Turn on `ui_in[3]` to start.
7. Read `uio`.
8. Calculate $t_{clkq} + t_{setup} = \frac{uio \times 20}{16}$.

### Measure $t_{clkq} + t_{setup}$ of Leap DICE D-FF

1. Connect `ui_in[1]` to the oscillator that generates exactly 50 MHz.
2. Set `ui_in[7:5]` to 3'b011, to choose measurement of $t_{clkq} + t_{setup}$.
3. Turn off `ui_in[3]`.
4. Turn off `ui_in[2]` to reset.
5. Turn on `ui_in[2]`.
6. Turn on `ui_in[3]` to start.
7. Read `uio`.
8. Calculate $t_{clkq} + t_{setup} = \frac{uio \times 20}{16}$.

### Measure $t_{skew}$

1. Connect `ui_in[1]` to the oscillator that generates exactly 50 MHz.
2. Connect `ui_in[4]` to the oscillator of the target clock.
2. Set `ui_in[7:5]` to 3'b100, to choose measurement of $t_{skew}$.
3. Turn off `ui_in[2]` to reset.
4. Turn on `ui_in[2]` to start.
5. Read `uio`.
6. Calculate $t_{skew} = uio \times t_{pd, inv}$, where $t_{pd, inv}$ is the result value of $t_{pd}$ of an inverter.

## External hardware

* An equipment to measure frequency.
* An oscillator that generates exactly 50 MHz.
* An oscillator that generates the target clock.
