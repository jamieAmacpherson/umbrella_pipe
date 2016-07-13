#! /bin/bash
set -e

trjconv="/mb/apps/gromacs-5.0.2_mpi/bin/trjconv_mpi"
met="../WTmetmd/met1.xtc"
topol="../WTmetmd/topol.tpr"
topol_g4="../../WTmetmd/topol_g455.tpr"
index="../../WTmetmd/umbrella.ndx"

# Generate configurations #
#mkdir structures

#$trjconv -f $met -s $topol -o structures/conf.gro -sep -pbc mol <<EOF
#0
#EOF

# Calculate distances #
cd structures

#last_struct="$(ls *.gro -Art | tail -n 1 | sed 's/[^0-9]*//g')"
# generate a file with the pulling and stationary groups (may have to change numbers here)
#printf "15\n14\n" > groups.txt

#cp ../distances.pl .
#cp ../setupUmbrella.py .
#echo $last_struct $topol_g4 $index

#perl distances.pl $last_struct $topol_g4 $index

# identify structures for umbrella sampling #
#cp ../run-umbrella.sh .
#python setupUmbrella.py summary_distances.dat 0.05 run-umbrella.sh > caught-output.txt

#awk '{print $1}' caught-output.txt > list-selected-structures.dat
#sed -i -e 1,3d list-selected-structures.dat
#awk '{print $1}' summary_distances.dat > all-structures.dat

# move structures for US into new directory
mkdir directory-umbrella-sampling

k=0

while read a ; do
	echo ${a}
	let k=k+1
	echo "Processing structre n..."$k
	cp conf${a}.gro struct-${k}.gro
	mv struct-${k}.gro directory-umbrella-sampling
done <list-selected-structures.dat

# Create run files for each of the structures
cd directory-umbrella-sampling

