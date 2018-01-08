# FPGA Designs and Resources used in CorteXlab testbed

## Overview

- Here you can find all CorteXlab HDL resources, mainly Xilinx ISE and Xilinx Platform Studio (XPS) projects along with IPs written in VHDL targeting [PicoSDR](https://www.nutaq.com/products/picosdr) devices from Nutaq _(FPGA target : Virtex-6)_

## Requirements

### Hardware

- PicoSDR nodes (2x2 and 4x4) within the CorteXlab testbed.

_Please have a look at the [CorteXlab Wiki](https://wiki.cortexlab.fr) to have access to the Awesome and totally free testbed, and try some pretty neat tutorials as well._

### Software

- Windows 7, 64 bits and 10 GB of RAM
- Nutaq ADP software tool _(have a look at Nutaq [software architecture](https://www.nutaq.com/blog/nutaqs-adp-software-architecture))
- Xilinx ISE 13.4 with Xilinx Platform Studio for FPGA VHDL design
- Optional : MATLAB R2011b + Simulink for FPGA model based design (MBDK layer. _In the future_)

## Directory tree

There is two main directories :
- 'fpga' : contains all HDL libraries such as vhdl source code, testbench and simulation files
- 'design' : contains ISE and XPS _(and, in the future, Simulink)_ projects using the 'fpga' libraries and Nutaq ADP software tools. 

Currently, this repository looks as following :

```shell
+- fpga
¦    + ieee802_15_4_rx3_v1_00_a
¦    ¦   + data
¦    ¦   + doc
¦    ¦   + hdl
¦    ¦   ¦   + simulation
¦    ¦   ¦   + testbench
¦    ¦   ¦   + vhdl
¦    ¦   ¦   ¦   + (VHDL source code)
¦    ¦   + simulation
¦    ¦   + testbench
¦    + ieee802_15_4_rx12_v1_00_a
¦    + ieee802_15_4_tx3_v1_00_a
¦    + ieee802_15_4_tx12_v1_00_a
¦    + options_switch_v1_00_b
¦    + rtdex_rx_if_v1_00_a
¦    + rtdex_tx_if_v1_00_a
¦     ...
¦
+- design
¦    + ieee802_15_4_rx3_v1_00_a
¦    ¦   + host
¦    ¦   + xilinx
¦    ¦   ¦   + ise
¦    ¦   ¦   ¦   + (Xilinx ISE compatible project)
¦    ¦   ¦   + xps 
¦    ¦   ¦   ¦   + (XPS compatible project)
¦    + ieee802_15_4_rx12_v1_00_a
¦    + ieee802_15_4_tx3_v1_00_a
¦    + ieee802_15_4_tx12_v1_00_a
¦    + options_switch_v1_00_b
```

## License

See the LICENSE file for license rights and limitations
