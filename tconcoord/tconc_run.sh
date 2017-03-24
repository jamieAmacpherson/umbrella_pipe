#!/bin/bash
if [ $# -ne 1 ]
then
    echo "Incorrect number of arguments..."
    echo "Usage: 00_Preparation <molname>"
    exit 1
fi



export GMXLIB='/apps/prod/gromacs-3.3.3/share/gromacs/top'
export CNCLIB='/apps/prod/tCONCOORD-1.0/lib'

source /apps/prod/gromacs-3.3.3/bin/GMXRC.bash
source /apps/prod/tCONCOORD-1.0/tCONCOORDRC.bash

mol=$1

nstruct=1000
maxite=5000
maxtrial=500
cfreq=500

tdist -s $mol".pdb" -inp input.cpf -od $mol'_tdist.dat' -top $mol'_tdist.ctp' -log $mol'_tdist.log' -op $mol'_tdist.pdb' >& tdist_$mol.log

srun -J tconc -p long -N 1 -n 8 -o output.o -e error.e tdisco -n $nstruct -nu $maxtrial -top $mol"_tdist.ctp" -x $mol'_tdisco.xtc' -ref $mol'_tdisco_ref.pdb' -log $mol'_tdisco.log' -i $maxite -d $mol'_tdist.dat' -seed -1 -nice 0 -cfreq $cfreq >& tdisco_$mol.log

