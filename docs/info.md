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
* A NAND2-based ring oscillator provides high-resolution estimates of logic delay ($t_{logic}$) of NAND2.
* Standard, DICE, LEAP-DICE, and Quatro D flip-flops measure clock-to-Q and setup timing ($t_{clkq} + t_{setup}$).
* Clock skew timing ($t_{skew}$) is determined using XOR-based pulse width detection between two clock signals.

High-speed counters driven by the ring oscillators convert these delays into digital values, enabling precise evaluation of process, voltage, and temperature variations on a fully digital, open-access platform.

To meet TinyTapeout’s requirements, no standard cells from the GF180MCU D process are used, and the design passes all strict error and warning checks.

## How to test

Explain how to use your project

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
