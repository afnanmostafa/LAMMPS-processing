#!/bin/bash

# edits the first entry if there are only 3 fields in a line
# good for rNEMD restart run in LAMMPS or any other general purposes

awk '{
	if (NF==3)
	$1=$1+10000000;
	print;
	}' sample.data > edited.data

less edited.data

diff sample.data edited.data > diff_sample_edited.data
