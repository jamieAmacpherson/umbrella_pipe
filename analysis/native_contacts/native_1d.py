## Calculate the percentage of native contacts in an MD trajectory
#
#____________________________________________________________________________
# Imports
#____________________________________________________________________________
import MDAnalysis as mda
from MDAnalysis.analysis import contacts
import matplotlib.pyplot as plt
import numpy as np
import argparse
import os.path
import sys

#____________________________________________________________________________
# Parse commandline arguments
#____________________________________________________________________________
# check if input file exists
# there are two inputs: trajectory (.dcd) and topology (.pdb)
# if either of those inputs are not supplied, or if the user doesn't invoke the
# help flag the program will display an error message.
def is_valid_file(arg):
    if not os.path.exists(arg):
        parser.error("The file %s does not exist! Use the --help flag for input options." % arg)
    else:
	return arg

# command line argument parser
parser = argparse.ArgumentParser(description='Calculate entropy of MD trajectory')

# the first argument is the trajectory file (.dcd) supplied after the -t flag
# the trajectory file is saved as an object with the variable args.dcdfile
parser.add_argument("-t", dest="dcdfile", required=True,
                    help="Free trajectory file (format: .dcd)",
                    type=lambda x: is_valid_file(x))

# the second argument is the topology file (.pdb) supplied after the -s flag
# this is saved an an obect with the variable args.pdbfile
parser.add_argument("-s", dest="pdbfile", required=True,
                    help="Free structure file (format: .pdb)",
                    type=lambda x: is_valid_file(x))

# the arguments are parsed 
args = parser.parse_args()

#____________________________________________________________________________
# Calculation of native contacts
#____________________________________________________________________________

# example trajectory (transition of AdK from closed to open)
u = mda.Universe(args.pdbfile,args.dcdfile)

# crude definition of salt bridges as contacts between NH/NZ in ARG/LYS and
# OE*/OD* in ASP/GLU. You might want to think a little bit harder about the
# problem before using this for real work.
sel_basic = "(resname ARG LYS) and (name NH* NZ)"
sel_acidic = "(resname ASP GLU) and (name OE* OD*)"

# reference groups (first frame of the trajectory, but you could also use a
# separate PDB, eg crystal structure)
acidic = u.select_atoms(sel_acidic)
basic = u.select_atoms(sel_basic)

# set up analysis of native contacts ("salt bridges"); salt bridges have a
# distance <6 A
ca1 = contacts.Contacts(u, selection=(sel_acidic, sel_basic),
		                        refgroup=(acidic, basic), radius=6.0)
# iterate through trajectory and perform analysis of "native contacts" Q
ca1.run()
# print number of averave contacts
average_contacts = np.mean(ca1.timeseries[:, 1])
print('average contacts = {}'.format(average_contacts))
# plot time series q(t)
f, ax = plt.subplots()
ax.plot(ca1.timeseries[:, 0], ca1.timeseries[:, 1])
ax.set(xlabel='frame', ylabel='fraction of native contacts',
		       title='Native Contacts, average = {:.2f}'.format(average_contacts))
f.show()
f.savefig("native_contact.pdf", bbox_inches='tight')
