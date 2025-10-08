# example of open source FPGA workflow

## Tools

- yosys: Synthesis tool
- nextpnr: Place & Routing tool
- fujprog: Flash bit stream to FPGA through JTAG


## Usage

Use verilator to check syntax

```shell
$ make lint
```

Generate bit stream then flash to FPGA

```shell
$ make prog
```
