#!/bin/bash
iverilog -o SPART -c file_list.txt testbench.v
vvp SPART
gtkwave test.vcd traces.gtkw