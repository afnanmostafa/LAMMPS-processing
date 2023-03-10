## rNEMD (Muller-Plathe) simulation output: temperature profile generator

This directory contains MATLAB function that reads __'e_profile[0-9]*.txt'__ and plots the temperature profile generated in Muller-Plathe method of calculating thermal conductivity in LAMMPS

1. Open MATLAB command window

2. call function **rNEMD_temp_profile.m**, _i.e.,_ rNEMD_temp_profile('e_profile120.txt',120,5,0.0001,0.1,1.65,1)

3. get the image as output (save as you like)

read the function description and modify as you want. The units convention is kept in such a manner that it is consistent with LAMMPS metal unit convention.

modify the *start time* to omit initial data for plotting temperature profile, *end time* to decide where to stop for collecting data. Both are in ns.