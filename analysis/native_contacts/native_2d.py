import MDAnalysis as mda
from MDAnalysis.analysis import contacts
from MDAnalysisTests.datafiles import PSF, DCD
import matplotlib.pyplot as plt
import numpy as np

u = mda.Universe(PSF, DCD)
q1q2 = contacts.q1q2(u, 'name CA', radius=8)
q1q2.run()

f, ax = plt.subplots(1, 2, figsize=plt.figaspect(0.5))
ax[0].plot(q1q2.timeseries[:, 0], q1q2.timeseries[:, 1], label='q1')
ax[0].plot(q1q2.timeseries[:, 0], q1q2.timeseries[:, 2], label='q2')
ax[0].legend(loc='best')
ax[1].plot(q1q2.timeseries[:, 1], q1q2.timeseries[:, 2], '.-')
f.show()
f.savefig("test.pdf", bbox_inches='tight')
