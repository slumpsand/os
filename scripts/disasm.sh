#!/bin/bash

ndisasm -u out/all.bin | sed -re "s/^[0-9A-F]+\s+[0-9A-F]+\s+(.*)$/\1/g" > out/disasm.asm
code out/disasm.asm
