import vmd
from vmd import molecule
import numpy as np
import sys


prm = sys.argv[1]
nc  = sys.argv[2]
cutoff = 3 # Angstrom
n_max  = 0 # maximum water number 

# start
molid = molecule.load("parm7",prm)
molecule.read(molid, "netcdf", nc,waitfor=-1)
last_frame = molecule.numframes(molid) - 1
water_resid_list = [np.array] * molecule.numframes(0)

with open('interface_water.dat','w') as write:

    for i_frame, frame in enumerate(range(molecule.numframes(0))):
        molecule.set_frame(molid,frame)
        water = vmd.atomsel(f"same resid as water and (within {cutoff} of fragment 0) and ( within {cutoff} of fragment 1)")
        water_resid_list[frame] = np.unique(water.resid)
        if len(np.unique(water.resid)) > n_max:
            n_max = len(np.unique(water.resid))
        print(','.join(list(np.unique(water.resid).astype(str) ) ), file=write) 
print(n_max)
