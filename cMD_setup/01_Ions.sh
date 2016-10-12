#!/bin/bash
if [ $# -ne 3 ]
then
    echo "Incorrect number of arguments..."
    echo "Usage: 01_Ions <molname> <n_pos_ions> <n_neg_ions>"
    exit 1
fi

# Define variables
mol=$1
nnp=$2
nnn=$3

cp $mol".top" $mol"_ions.top"

genion -s $mol"_genion".tpr -n index.ndx -pname NA -nname CL -nn $nnn -np $nnp -o $mol"_ions.pdb" -p $mol"_ions.top" 
