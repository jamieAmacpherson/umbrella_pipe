#! /bin/bash
set -e

if [ $# -eq 0 ]
  then
    printf "Need to supply the following arguments:\ndirectory to pulling files\nbase directory to gromacs (eg. /usr/bin/gormacs-5.0.2)"
fi

trjconv=${0}"bin/trjconv_mpi"
met=${1}"met1.xtc"
topol=${1}"topol.tpr"
topol_g4=${1}"topol_g455.tpr"
index=${1}"umbrella.ndx"

# Generate configurations #
mkdir structures

$trjconv -f $met -s $topol -o structures/conf.gro -sep -pbc mol <<EOF
0
EOF

# Calculate distances #
cd structures

last_struct="$(ls *.gro -Art | tail -n 1 | sed 's/[^0-9]*//g')"
# generate a file with the pulling and stationary groups (may have to change numbers here)
printf "15\n14\n" > groups.txt

cp ../distances.pl .
cp ../setupUmbrella.py .
echo $last_struct $topol_g4 $index

perl distances.pl $last_struct $topol_g4 $index

# identify structures for umbrella sampling #
cp ../run-umbrella.sh .
python setupUmbrella.py summary_distances.dat 0.05 run-umbrella.sh > caught-output.txt

awk '{print $1}' caught-output.txt > list-selected-structures.dat
sed -i -e 1,3d list-selected-structures.dat
awk '{print $1}' summary_distances.dat > all-structures.dat

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

cp ../../sub.zip .
unzip sub.zip

let k=1
let nst="$(ls *.gro -Art | tail -n 1 | sed 's/[^0-9]*//g')"

while [ $k -le $nst ]
do
	echo "Processing structure n..."$k
	mkdir ${k}-struct
	cp struct-${k}.gro ${k}-struct
	cd ${k}-struct/
	mv struct-${k}.gro struct.gro
	cp ../submit.sh . 
	cd ..
	
	if [ -e ${k}-struct/struct.gro ]
	then
		rm struct-${k}.gro 
		echo "done"
	fi
let k=k+1
done

# Submit the run files
let k=1
let nst=51

while [ $k -le $nst ]
do
  cd $k-struct
  ./submit.sh
  cd ..
let k=k+1

done
