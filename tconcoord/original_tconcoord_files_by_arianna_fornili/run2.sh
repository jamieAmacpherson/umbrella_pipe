#!/bin/bash
source ~/.GM333
source /home/apps/tCONCOORD-1.0/tCONCOORDRC.bash

job=$1
nstruct=1000
maxite=5000
maxtrial=500
cfreq=500

tdisco -n $nstruct -nu $maxtrial -top $job'_tdist.ctp' -x $job'_tdisco.xtc' -ref $job'_tdisco_ref.pdb' -log $job'_tdisco.log' -i $maxite -d $job'_tdist.dat' -seed -1 -nice 0 -cfreq $cfreq >& tdisco_$job.log


