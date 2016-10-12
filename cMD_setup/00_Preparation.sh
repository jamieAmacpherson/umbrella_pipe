#!/bin/bash
if [ $# -ne 1 ]
then
    echo "Incorrect number of arguments..."
    echo "Usage: 00_Preparation <molname>"
    exit 1
fi


mol=$1

# Create the topology file of the pkm2 monomer without the FBP ligand bound
pdb2gmx -f $mol.pdb -p $mol.top -ff gromos53a6 -water spc -o $mol"_gmx".pdb -i $mol.posre.itp  -ignh 


# Define the unit cell
editconf -f $mol"_gmx.pdb" -o $mol"_econf.pdb" -bt octahedron -d 0.9 -c 


# Fill the unit cell with water
genbox -cp $mol"_econf.pdb" -cs spc216.gro -o $mol"_solv".pdb -p $mol.top 

# Create an index file
make_ndx -f $mol"_solv".pdb -o index.ndx

# Use grompp to assemble a .tpr file, using any .mdp file (we use em.mdp in this case because it requires the fewest parameters).
grompp -p $mol".top" -c $mol"_solv.pdb" -f ../mdps/em.mdp -o $mol"_genion.tpr" -po $mol"_genion.mdout" -maxwarn 2 
