#!/bin/bash
source ~/.GM333
source /home/apps/tCONCOORD-1.0/tCONCOORDRC.bash
job=$1
echo $job " pdb2gmx..."
pdb2gmx -f $job.pdb -o $job"_addH.pdb" -p $job.top -ff oplsaa -ignh  >& pdb2gmx_$job.log
echo $job " grompp (1)..."
grompp -p $job.top -c $job"_addH.pdb" -f em.mdp -o $job.tpr >& grompp1_$job.log
echo $job " mdrun..."
mdrun -s $job.tpr -o $job.trr -g $job.log -e $job.edr -c $job"_min.pdb" >& mdrun_$job.log
echo $job " grompp (2)..."
grompp -p $job.top -c $job"_min.pdb" -f em.mdp -o $job"_min.tpr" >& grompp2_$job.log
echo $job " tdist (1)..."
tdist -s $job"_min.tpr" -inp input.cpf -od $job'_tdist.dat' -top $job'_tdist.ctp' -log $job'_tdist.log' -op $job'_tdist.pdb' >& tdist_$job.log
