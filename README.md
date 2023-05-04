# unuzip - Decompress FreeBSD UZIP images

UZIP is a compressed image format created by `mkuzip` on FreeBSD.

See: https://github.com/deadsy/mkuzip

`mkuzip` is typically used to compress ISO file system images.

`unuzip` decompresses these files to return to the original ISO file.

`unuzip` is written in Python 3 and has been tested on Linux and Mac OS X.

## Usage

    usage: unuzip [-h] [-v] infile [outfile]

    Decompress FreeBSD UZIP/IZO images

    positional arguments:
    infile      input file
    outfile     output file (default: <infile>.iso)

    options:
    -h, --help  show this help message and exit
    -v          be verbose

    visit: https://github.com/deadsy/unuzip

Note: `unuzip` will silently overwrite a pre-existing output file.

Once the file is decompressed, you can mount it on a Linux system using a command like:

    sudo mount -o loop file.iso /mnt/somewhere

## UZIP file format

All integers are big endian.

    Magic:  128 bytes (shell script)
    Header: 8 bytes (uint32 block_size, uint32 num_blocks)
    TOC:    8 bytes * (num_blocks + 1)
    Compressed blocks

The magic value is a 128 byte string that makes the file a valid shell script to mount the image on FreeBSD.

The header declares the block size (size of decompressed blocks) and total number of blocks.
Block size must be a multiple of 512 and defaults to 16384 in `mkuzip`.

The TOC is a list of 64 bit unsigned offsets into the file for each block.
 * The length of a compressed block is determined by subtracting consecutive offsets.
 * Each block is decompressed using a compression method specific to the input file version.
 * The compressed block decompresses to `block_size` bytes (the last block may be smaller).
 * A compressed block with 0 length generates `block_size` zero bytes in the uncompressed output.

## About `unuzip`

 * Originally written by Mike Ryan of [ICE9 Consulting](https://ice9.us).
 * Updated by Jason Harris to support python 3 and add support for UZIP versions 3 and 4.
 * Shares no code with FreeBSD.
