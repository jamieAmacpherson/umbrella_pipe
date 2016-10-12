#!/bin/bash
if [ $# -ne 2 ]
then
    echo "Incorrect number of arguments..."
    echo "Usage: 03_Add_POSRES.sh <molname> <counterion name>"
    exit 1
fi

mol=$1
cion=$2

NLINES=`wc -l $mol"_ions.top" | cut -f 1 -d ' '`
POSLINE=`egrep -n 'ifdef POSRES$' $mol"_ions.top" | cut -f 1 -d :`

SPLITLINE=$(($POSLINE + 2))
TAILLINE=$(($NLINES - $SPLITLINE))

head -n $SPLITLINE $mol"_ions.top" > $mol"_ions_posre.top"
echo "
#ifdef POSRES2000
#include \"$mol.posre2000.itp\"
#endif
#ifdef POSRES1000
#include \"$mol.posre1000.itp\"
#endif
#ifdef POSRES500
#include \"$mol.posre500.itp\"
#endif
#ifdef POSRES250
#include \"$mol.posre250.itp\"
#endif" >> $mol"_ions_posre.top"
tail -n $TAILLINE $mol"_ions.top" >> $mol"_ions_posre.top"

# Make .ndx if you need special groups (Protein-H_MG in this case)

make_ndx_mpi -f $mol"_ions.pdb" -o $mol"_ions.pre.ndx"<<EOF
q
EOF

PROTHIDX=`egrep '\[' $mol"_ions.pre.ndx"  | nl -v 0 | grep Protein-H | cut -f 1 -d '['`
PROTHIDX=$(echo $PROTHIDX)
PROTIDX=`egrep '\[' $mol"_ions.pre.ndx"  | nl -v 0 | grep ' Protein ' | cut -f 1 -d '['`
PROTIDX=$(echo $PROTIDX)
WATIDX=`egrep '\[' $mol"_ions.pre.ndx"  | nl -v 0 | grep ' Water ' | cut -f 1 -d '['`
WATIDX=$(echo $WATIDX)
CIONIDX=`egrep '\[' $mol"_ions.pre.ndx" | nl -v 0 | grep $cion | cut -f 1 -d '[' | head -1`
CIONIDX=$(echo $CIONIDX)
MGIDX=`egrep '\[' $mol"_ions.pre.ndx" | nl -v 0 | grep MG | cut -f 1 -d '[' | head -1`
MGIDX=$(echo $MGIDX)
IDX1STRING="$PROTHIDX|$MGIDX"
IDX2STRING="$PROTIDX|$MGIDX"
IDX3STRING="$WATIDX|$CIONIDX"

make_ndx_mpi -f $mol"_ions.pdb" -o $mol"_ions.pre.pre.ndx"<<EOF
$IDX1STRING
$IDX2STRING
$IDX3STRING
q
EOF

WATCIONIDX=`egrep '\[' $mol"_ions.pre.pre.ndx"  | nl -v 0 | grep $cion | grep Water | cut -f 1 -d '['`
RENSTRING="name $WATCIONIDX Water_and_counterions"
echo $RENSTRING

make_ndx_mpi -f $mol"_ions.pdb" -n $mol"_ions.pre.pre.ndx" -o $mol"_ions.ndx"<<EOF
$RENSTRING
q
EOF

genrestr_mpi -f $mol"_ions.pdb" -fc 2000 -o $mol.posre2000.itp -n $mol"_ions.ndx" <<EOF
Protein-H_MG
EOF
genrestr_mpi -f $mol"_ions.pdb" -fc 1000 -o $mol.posre1000.itp -n $mol"_ions.ndx" <<EOF
Protein-H_MG
EOF
genrestr_mpi -f $mol"_ions.pdb" -fc 500 -o $mol.posre500.itp -n $mol"_ions.ndx" <<EOF
Protein-H_MG
EOF
genrestr_mpi -f $mol"_ions.pdb" -fc 250 -o $mol.posre250.itp -n $mol"_ions.ndx" <<EOF
Protein-H_MG
EOF

echo "---------------------------------------------------------------"
echo The following part has been added to the $mol"_ions_posre.top:"
diff $mol"_ions.top" $mol"_ions_posre.top"
echo
echo Please double-check the newly generated topology file!!!

echo "---------------------------------------------------------------"
echo The following new groups have been added to the $mol"_ions.ndx":
echo Protein_MG Protein-H_MG Water_and_counterions
echo
echo Please double-check the newly generated index file!!!
echo "---------------------------------------------------------------"
