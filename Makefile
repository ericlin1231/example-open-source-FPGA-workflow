TOP     ?= adder
BOARD   ?= ulx3s
DEVICE  ?= --85k
PACKAGE ?= CABGA381

SRCS := adder.sv debounce.sv
LPF  ?= $(BOARD).lpf

YOSYS   ?= yosys
NEXTPNR ?= nextpnr-ecp5
ECPPACK ?= ecppack
PROG    ?= fujprog

JSON    := $(TOP).json
CFG     := $(BOARD)_out.config
BIT     := $(BOARD).bit

all: $(BIT)

$(JSON): $(SRCS)
	$(YOSYS) -p 'read_verilog -sv $(SRCS); synth_ecp5 -top $(TOP) -json $(JSON)'

$(CFG): $(JSON) $(LPF)
	$(NEXTPNR) $(DEVICE) --package $(PACKAGE) \
		--json $(JSON) --lpf $(LPF) --textcfg $(CFG)

$(BIT): $(CFG)
	$(ECPPACK) --compress $(CFG) $(BIT)

prog: $(BIT)
	$(PROG) $(BIT)

lint:
	verilator --lint-only -Wall $(SRCS)

clean:
	rm -f $(JSON) $(CFG) $(BIT) $(BOARD).svf

.PHONY: all prog lint clean
