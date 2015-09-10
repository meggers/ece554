#!/bin/bash
iverilog -o SPART -c file_list.txt
vvp SPART
gtkwave test.vcd traces.gtkw