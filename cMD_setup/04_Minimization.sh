#!/bin/bash
if [ $# -ne 1 ]
then
    echo "Incorrect number of arguments..."
    echo "Usage: 04_Minimization.sh <molname>"
    exit 1
fi


mol=$1

# MINIMIZATION with positional restraints (fc=4000) on Protein-H (steep)
runtyp="min_sd_posre"

grompp -p $mol"_ions.top" -c $mol"_ions.pdb" -f $runtyp.mdp -o $job.tpr 
mdrun -s $job.tpr -v -deffnm em_posre

#### MINIMIZATION on Protein (steep)
runtyp="min_sd"

grompp -p $mol"_ions.top" -c em_posre.gro -f $runtyp.mdp -o em_free.tpr
mdrun -s $job.tpr -v -deffnm em_free
