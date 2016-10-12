#!/bin/bash
if [ $# -ne 1 ]
then
    echo "Incorrect number of arguments..."
    echo "Usage: 05_Equilibration.sh <molname>"
    exit 1
fi

# Define variables
mol=$1

## NVT ensemble equilibration:

# Protein-ligand complex NVT equilibration 50K bonds restrained at fc=10000
runtyp="equil-50K-nvt-restr-prot"
job=$mol"_"$runtyp
jobname=$mol"eqv1"

grompp_mpi -p $mol"_ions.top" -c em.gro -f $runtyp.mdp -o nvt50.tpr -n index.ndx -maxwarn 1

mpirun -np 2 mdrun_mpi -ntomp 8 -s nvt50.tpr -deffnm nvt50 -v -pin on 

# Protein-ligand complex NVT equilibration 100K bonds restrained at fc=5000
runtyp="equil-100K-nvt-restr-prot"
job_p=$job
job=$mol"_"$runtyp
jobname=$mol"eqv2"

grompp_mpi -p $mol"_ions.top" -c nvt50.gro -f $runtyp.mdp -o nvt100.tpr -n index.ndx

mpirun -np 2 mdrun_mpi -ntomp 8 -s nvt100.tpr -deffnm nvt100 -pin on

# Protein-ligand complex NVT equilibration 200K bonds restrained at fc=4000
runtyp="equil-200K-nvt-restr-prot"
job_p=$job
job=$mol"_"$runtyp
jobname=$mol"eqv2"


grompp_mpi -p $mol"_ions.top" -c nvt100.gro -f $runtyp.mdp -o nvt200.tpr -n index.ndx 

mpirun -np 2 mdrun_mpi -ntomp 8 -deffnm nvt200 -s nvt200.tpr -pin on 

# Protein-ligand complex NVT equilibration 300K bonds restrained at fc=1000
runtyp="equil-300K-nvt-restr-prot"
job_p=$job
job=$mol"_"$runtyp
jobname=$mol"eqv2"

grompp_mpi -p $mol"_ions.top" -c nvt200.gro -f $runtyp.mdp -o nvt300.tpr -n index.ndx

mpirun -np 2 mdrun_mpi -ntomp 8 -deffnm nvt300 -s nvt300.tpr -pin on
