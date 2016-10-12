#!/bin/bash
#if [ $# -ne 1 ]
#then
#    echo "Incorrect number of arguments..."
#    echo "Usage: 05_Equilibration.sh <molname>"
#    exit 1
#fi

# Define variables
GMXPREFIX="/apps/prod/gromacs-5.0.2_mpi"
mol=3BJT
source /apps/prod/bin/GMXRC.bash


## NPT ensemble equilibration:

# Protein-ligand complex NPT equilibration 50K
runtyp="equil-50K-npt-prot"
job=$mol"_"$runtyp
jobname=$mol"eqv1"

grompp_mpi -p $mol"_ions.top" -c nvt300.gro  -f $runtyp.mdp -o npt50.tpr -n index.ndx 


mpirun -np 2 mdrun_mpi -ntomp 8 -s npt50.tpr -deffnm npt50 -pin on 

# Protein-ligand complex NPT equilibration 100K
runtyp="equil-100K-npt-prot"
job_p=$job
job=$mol"_"$runtyp
jobname=$mol"eqv2"

grompp_mpi -p $mol"_ions.top" -c npt50.gro  -f $runtyp.mdp -o npt100.tpr -n index.ndx 


mpirun -np 2 mdrun_mpi -ntomp 8 -s npt100.tpr -deffnm npt100 -pin on 

# Protein-ligand complex NPT equilibration 200K
runtyp="equil-200K-npt-prot"
job_p=$job
job=$mol"_"$runtyp
jobname=$mol"eqv2"

grompp_mpi -p $mol"_ions.top" -c npt100.gro  -f $runtyp.mdp -o npt200.tpr -n index.ndx 


mpirun -np 2 mdrun_mpi -ntomp 8 -s npt200.tpr -deffnm npt200 -pin on 

# Protein-ligand complex NVT equilibration 300K bonds restrained at fc=1000
runtyp="equil-300K-npt-prot"
job_p=$job
job=$mol"_"$runtyp
jobname=$mol"eqv2"

grompp_mpi -p $mol"_ions.top" -c npt200.gro  -f $runtyp.mdp -o npt300.tpr -n index.ndx 

mpirun -np 2 mdrun_mpi -ntomp 8 -s npt300.tpr -deffnm npt300 -pin on 
