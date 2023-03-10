## rNEMD (Muller-Plathe) simulation input script generator

This directory contains MATLAB script that writes an input script to be used in LAMMPS

* **runtime** = simulation run time in ns
* **timestep_in_ps** = simulation timestep size in ps
* **sheet_length** = length in nm
* **dimension** = 3
* **filename** = LAMMPS data/structure file that is to be read
* change **pot_dir** and put your potential file directory
* **cutoff** = change as you need
* **lj** = switch on/off
* **torsion** = torsion term in AIREBO (switch on/off)
* **atomset** = atom types (change as you need, in my case, it was C C H or C H or C)
* **simu_dim** = (not equal to dimension, this rather sets how much processor division will be done in x,y,z directions)
	* **simu_dim** = 3 if you have heavy-duty calculation in all 3 directions (3d cubic diamond EMD)
	* **simu_dim** = 2 if you have heavy-duty calculation in all a certain plane (2d graphene EMD)
	* **simu_dim** = 1 if you have heavy-duty calculation in all a certian direction only (2d graphene rNEMD in x direction)
* **boundary_***** = how you want your boundary conditions to be
* **neighbor_dist** = neighbor list cutoff distance
* **neigh_check_update** = how frequently neighbor list is to be updated
* **volm** = volume of the system (monolayer graphene: lx*ly*3.35 units in Angstrom)

read the user-defined variables and modify as you want. The units convention is kept in such a manner that it is consistent with LAMMPS metal unit convention.

