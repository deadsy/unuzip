# unuzip - Decompress FreeBSD UZIP images

UZIP is a compressed image format created by `mkuzip` on FreeBSD.

See: https://github.com/deadsy/mkuzip

`mkuzip` is generally used to compress ISO file system images.

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

If no output file is given, the output filename defaults to `<infile>.iso`.

Note: `unuzip` will silently overwrite a pre-existing output file.

Once the file is decompressed, you can mount it on a Linux system using a command like:

    sudo mount -o loop file.iso /mnt/somewhere

# UZIP file format

UZIP does not appear to be formally documented anywhere, so for the
benefit of others interested in this format, this section is a brief
overview of how the file is structured. All integers are big endian.

    Magic:  128 bytes (shell script)
    Header: 8 bytes (uint32_t block_size, uint32_t num_blocks)
    TOC:    8 bytes * (num_blocks + 1)
    Compressed blocks

UZIP magic is a 128 byte string that also makes the file a valid shell script that will mount the image on FreeBSD.

For version 2 images, the magic string is:

    #!/bin/sh
    #V2.0 Format
    m=geom_uzip
    (kldstat -m $m 2>&-||kldload $m)>&-&&mount_cd9660 /dev/`mdconfig -af $0`.uzip $1
    exit $?

The header declares the block size (size of decompressed blocks) and total number of blocks.
Block size must be a multiple of 512 and defaults to 16384 in `mkuzip`.

The TOC is a list of 64 bit unsigned offsets into the file for each block.
 * The length of a compressed data block is determined by subtracting consecutive offsets.
 * Each block is compressed using a compression method specific to the input file version.
 * The compressed data block is decompressed to `block_size` bytes (the last block may be smaller).
 * A compressed data block with 0 length generates `block_size` zero bytes in the uncompressed output.

# About `unuzip`

 * Originally written by Mike Ryan of [ICE9 Consulting](https://ice9.us).
 * Updated by Jason Harris to support python 3 and add support for UZIP versions 3 and 4.
 * Not part of FreeBSD and shares no code with FreeBSD.
