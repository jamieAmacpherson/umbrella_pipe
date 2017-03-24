#!/bin/bash
if [ $# -ne 3 ]
then
	echo "Incorrect number of arguments..."
	echo "Usage: split_resid.sh <trjectory (.xtc)> <topology (.pdb)> <index file (.ndx)>"
	exit 1
fi

schlitter='/Users/Jamie/jm.software/development/entropy/GSA_schlitte/entropy_python/src/schlitter.py'
mdconvert='/Users/Jamie/jm.software/development/entropy/GSA_schlitte/entropy_python/ana_scripts/mdconvert.py'


gmx trjconv -f $1 -s $2 -b 0 -e $k -o trajout$k.xtc -n $5 <<EOF
1
EOF

gmx trjconv -f $1 -s $2 -b 0 -e 0 -o topol$k.pdb -n $5 <<EOF
1
EOF

python $mdconvert trajout$k.xtc -o $k.dcd

 
python $native -t $k.dcd -s $1

rm  *.dcd 

