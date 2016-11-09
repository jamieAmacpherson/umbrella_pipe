#!/bin/bash
if [ $# -ne 3 ]
then
	echo "Incorrect number of arguments..."
	echo "Usage: fes.sh <.xtc> <.tpr> <angle.ndx>"
	exit 1
fi

# Calculate the angle between defined residues
gmx angle -f $1 -s $2 -n $3 -ov angle.xvg

# Calculate the radius of gyration
gmx gyrate -f $1 -s $2 -o gyrate.xvg <<EOF
1
1
EOF

# Generate an input for g_sham using a short perl script
perl sham.pl -i1 angle.xvg -i2 gyrate.xvg -data1 1 -data2 1 -o gsham-input.xvg
$sham -f gsham-input.xvg -ls fes.xpm -tsham 300

# Convert the .xpm output of the g_sham program to a .txt file to read into a plotting environment (ie. matlab/python/R)
python xpm2txt.py -f fes.xpm -o fes.txt
