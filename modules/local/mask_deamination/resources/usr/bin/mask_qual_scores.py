#! /usr/bin/env python3

import pysam
import sys

def main(bamfile, positions):

    #open the files
    infile = pysam.AlignmentFile(bamfile, 'rb')
    outfile = pysam.AlignmentFile(f"masked_{bamfile}", 'wb', template=infile)

    #main loop
    for read in infile:
        #alter quality scores
        qual = read.query_qualities

        bases = list(range(positions))
        bases.extend(list(range(positions*-1,0)))

        for n in bases:
            #set quality to 0
            qual[n] = 0

        read.query_qualities = qual
        outfile.write(read)

    infile.close()
    outfile.close()

if __name__ == "__main__":
    bamfile = sys.argv[1]
    positions = int(sys.argv[2])
    main(bamfile, positions)