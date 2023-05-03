#!/bin/bash

ISO=~/tmp/test.iso

mkuzip -A zlib -o test_zlib.izo $ISO
./unuzip -v test_zlib.izo
cmp $ISO test_zlib.iso

mkuzip -A lzma -o test_lzma.izo $ISO
./unuzip -v test_lzma.izo
cmp $ISO test_lzma.iso

mkuzip -A zstd -o test_zstd.izo $ISO
./unuzip -v test_zstd.izo
cmp $ISO test_zstd.iso

rm *.iso
rm *.izo

