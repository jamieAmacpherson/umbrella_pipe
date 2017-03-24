#!/bin/bash
if [ $# -ne 3 ]
then
	echo "Incorrect number of arguments..."
	echo "Usage: fes.sh <.xtc> <.tpr> <angle.ndx>"
	exit 1
fi
gmx covar -f $1 -s $2 

gmx anaeig -s $1 -f $2 -v  eigenvectors.trr -eig eigenvalues.xvg -proj proj-ev1.xvg -extr ev1.pdb -rmsf rmsf-ev1.xvg -first 1 -last 1 -nframes 50 << EOF
1
1
EOF

gmx anaeig -s $1 -f $2 -v eigenvectors.trr -eig eigenvalues.xvg -proj proj-ev2.xvg -extr ev2.pdb -rmsf rmsf-ev2.xvg -first 2 -last 2 -nframes 50 << EOF
1
1
EOF
