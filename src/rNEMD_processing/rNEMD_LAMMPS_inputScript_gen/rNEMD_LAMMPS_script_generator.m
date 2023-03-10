%% LAMMPS input script for NEMD %%
clear;
close all;
clc;

%% STC = subject to change and we must change them carefully
%%%                     ===============                     %%%
%% $$$$ rng for seed $$$$ %%
rng_shuffle = true;                          %% STC
if rng_shuffle == 1                         
    rng shuffle;
    s = rng(1,'twister');
    seed = s.State(randi(length(s.State),1));
    seed_curtailed = round(seed/1000);
else %% for same set of random numbers (test purposes)
    s = rng(1,'twister');
    seed = s.State(randi(length(s.State),1));
    seed_curtailed = round(seed/1000);
end

%% $$$$ user-defined $$$$ %%
%% simulation starters
runtime = 2;               %ns              %% STC
timestep_in_ps = 0.0001;   %ps              %% STC
sheet_length = 100;        %nm              %% STC
dimension = 3;                              %% STC
filename = 'rdibg_1.25_100x5.data';         %% STC

%% potential file directory and potential settings turn on/off
pot_dir = '/work/afnanmostafa_umass_edu/NEMD/nemd_3D/ab';          %% STC
pot_file = 'CH.airebo';                     %% STC
cutoff = 3;                                 %% STC
lj = 1;                                     %% STC
torsion =0;                                 %% STC

%% potential interaction setup %%
atom_types_in_datafile = 3;                 %% STC
Hydrogen = true;                            %% STC
%
if atom_types_in_datafile == 3 && Hydrogen == true
    atomset = "C C H";
elseif atom_types_in_datafile == 2 && Hydrogen == true
    atomset = "C H";
elseif atom_types_in_datafile == 2 && Hydrogen == false
    atomset = "C C";
else
    atomset = "C";
end

%% minimization
simu_dim = 2;                               %% STC

%% processors to be used
%
if simu_dim == 3
    prcs = '* * *'; %% for 3d calculation
elseif simu_dim == 2
    prcs = '* * 1'; %% for 2d calculation
else
    prcs = '* 1 1'; %% for 1d calculation (1d calculation in 3d system)
end

%% boundary (p = periodic, f = fixed, s = shrink-wrap, m = shrink-wrap with a minimum)
boundary_xlo = 'p';                         %% STC
boundary_xhi = 'p';                         %% STC
boundary_ylo = 'p';                         %% STC
boundary_yhi = 'p';                         %% STC
boundary_zlo = 'p';                         %% STC
boundary_zhi = 'p';                         %% STC

if strcmp(boundary_xlo,boundary_xhi) && strcmp(boundary_ylo,boundary_yhi) && strcmp(boundary_zlo,boundary_zhi)
    boundary = [boundary_xlo ' ' boundary_ylo ' ' boundary_zlo];
elseif strcmp(boundary_xlo,boundary_xhi) && strcmp(boundary_ylo,boundary_yhi)
    boundary = [boundary_xlo ' ' boundary_ylo ' ' boundary_zlo boundary_zhi];
elseif strcmp(boundary_xlo,boundary_xhi) && strcmp(boundary_zlo,boundary_zhi)
    boundary = [boundary_xlo ' ' boundary_ylo boundary_yhi ' ' boundary_zlo];
elseif strcmp(boundary_ylo,boundary_yhi) && strcmp(boundary_zlo,boundary_zhi)
    boundary = [boundary_xlo boundary_xhi ' ' boundary_ylo ' ' boundary_zlo];
elseif strcmp(boundary_xlo,boundary_xhi) && strcmp(boundary_ylo,boundary_yhi)==0 && strcmp(boundary_zlo,boundary_zhi)==0
    boundary = [boundary_xlo ' ' boundary_ylo boundary_yhi ' ' boundary_zlo boundary_zhi];
elseif strcmp(boundary_xlo,boundary_xhi)==0 && strcmp(boundary_ylo,boundary_yhi) && strcmp(boundary_zlo,boundary_zhi)==0
    boundary = [boundary_xlo boundary_xhi ' ' boundary_ylo ' ' boundary_zlo boundary_zhi];
elseif strcmp(boundary_xlo,boundary_xhi)==0 && strcmp(boundary_ylo,boundary_yhi)==0 && strcmp(boundary_zlo,boundary_zhi)
    boundary = [boundary_xlo boundary_xhi ' ' boundary_ylo boundary_yhi ' ' boundary_zlo];
else
    boundary = [boundary_xlo boundary_xhi ' ' boundary_ylo boundary_yhi ' ' boundary_zlo boundary_zhi];
end

%% neighbor 
neighbor_dist = 0.3;                        %% STC
neigh_check_update = true;                  %% STC

%% volume
graphene = true;                            %% STC
diamond_3d = false;                         %% STC
n = 2;   %no of layers of graphene          %% STC
cc_height = 3.35;                           %% STC

if diamond_3d == true
    volm = 'lx*ly*lz';
elseif graphene == true
    volm = sprintf('lx*ly*%.4f',n*cc_height);
else
    volm = 'lx*ly*lz';
end

total_steps = (runtime*1e3)/timestep_in_ps;

%% $$$$ input script generator $$$$ %%
fid2 = fopen('in.lmp', 'w');

fprintf(fid2, '#rNEMD (from heat flux to temperature gradient) script LAMMPS\n');
fprintf(fid2, '#STC = Subject to change\n');
fprintf(fid2, '#written by - Afnan Mostafa\n\n');

fprintf(fid2,'##========== simulation parameters ==========##\n\n');
fprintf(fid2,'dimension             %d\n',dimension);
fprintf(fid2,'units                 metal\n');
fprintf(fid2,'processors            %s\n',prcs);
fprintf(fid2,'boundary              %s\n\n',boundary);

fprintf(fid2,'##========== neighbor list ==========##\n\n');

fprintf(fid2,'neighbor              %.2f     bin\n',neighbor_dist);

if neigh_check_update == true
    fprintf(fid2,'neigh_modify      every 1 delay 0 check yes\n\n');
else
    fprintf(fid2,'\n');
end

fprintf(fid2,'##========== define lattice type/read from file ==========##\n\n');

fprintf(fid2,'atom_style            atomic\n');
fprintf(fid2,'read_data             %s\n\n',filename);

fprintf(fid2,'##========== define simulation variables ==========##\n\n');

fprintf(fid2,'variable             V        equal   %s',volm);
fprintf(fid2,'\n');
fprintf(fid2,'variable             dt       equal   %f ##STC',timestep_in_ps);
fprintf(fid2,'\n\n');

fprintf(fid2,'##========== define NEMD variables ==========##\n\n');

fprintf(fid2,'variable              len         equal   %d\n',sheet_length);
fprintf(fid2,'variable              binlen      equal   ${len}*2\n');
fprintf(fid2,'variable              invbinlen   equal   1/${binlen}\n');
fprintf(fid2,'variable              runtimeNS   equal   %d\n',runtime);
fprintf(fid2,'variable              runtimePS   equal   ${runtimeNS}*1000\n');
fprintf(fid2,'variable              runSteps    equal   ${runtimePS}/${dt}\n');
fprintf(fid2,'variable              STEP        equal   step\n');
fprintf(fid2,'variable              T           equal   temp\n');
fprintf(fid2,'variable              TIME        equal   time\n');
fprintf(fid2,'variable              P           equal   press\n');
fprintf(fid2,'variable              PX          equal   pxx\n');
fprintf(fid2,'variable              PY          equal   pyy\n');
fprintf(fid2,'variable              PZ          equal   pzz\n');
fprintf(fid2,'variable              ETOT        equal   etotal\n');
fprintf(fid2,'variable              PE          equal   pe\n');
fprintf(fid2,'variable              KE          equal   ke\n');
fprintf(fid2,'variable              VOL         equal   vol\n');
fprintf(fid2,'variable              LX          equal   lx\n');
fprintf(fid2,'variable              LY          equal   ly\n');
fprintf(fid2,'variable              tset        equal   300\n');
fprintf(fid2,'variable              kB          equal   8.6173e-5 ### eV/K\n');
fprintf(fid2,'variable              L0          equal   "lx"\n');
fprintf(fid2,'variable              L1          equal   ${L0}\n');
fprintf(fid2,'variable              dx          equal   ${L1}/${binlen}\n');
fprintf(fid2,'variable              xlo         equal   "xlo"\n');
fprintf(fid2,'variable              xl1         equal   ${xlo}\n');
fprintf(fid2,'variable              xl2         equal   ${xl1}+${dx}\n');
fprintf(fid2,'variable              xh1         equal   ${xl1}+${L1}\n');
fprintf(fid2,'variable              xh2         equal   ${xh1}-${dx}\n');
fprintf(fid2,'variable              xc0         equal   ${xl1}+${L1}/2\n');
fprintf(fid2,'variable              xc1         equal   ${xc0}-${dx}\n');
fprintf(fid2,'variable              xc2         equal   ${xc0}+${dx}\n\n');

fprintf(fid2,'##========== define simulation run-related parameters ==========##\n\n');

fprintf(fid2,'variable              nsteps      equal   ${runSteps} ##STC: total steps\n');
fprintf(fid2,'variable              seed        equal   %d ##STC\n',seed_curtailed);
fprintf(fid2,'variable              restpoints  equal   ${nsteps}/10 ##STC\n\n');


fprintf(fid2,'##========== define hot/cold region ==========##\n\n');
fprintf(fid2,'region        x_sink_1 	block       ${xl1}	${xl2}	INF INF INF INF\n');
fprintf(fid2,'region        x_sink_2	block       ${xh2}	${xh1}	INF INF INF INF\n');
fprintf(fid2,'region        source_c	block       ${xc1}	${xc2}	INF INF INF INF\n');
fprintf(fid2,'region        sink_all	union 2 x_sink_1 x_sink_2\n');
fprintf(fid2,'group         source region source_c\n');
fprintf(fid2,'group         sink region sink_all\n\n');

fprintf(fid2,'##========== define interatomic potentials ==========##\n\n');

fprintf(fid2,'variable      pot_dir string "%s" ##potential file directory\n',pot_dir);
fprintf(fid2,'pair_style	airebo %d %d %d ##LJ on (1), torsion off (0)',cutoff, lj, torsion);
fprintf(fid2,'\n');
fprintf(fid2,'pair_coeff 	 * * ${pot_dir}/%s %s\n\n',pot_file,atomset);

fprintf(fid2,'##========== define per-atom variable dumping ==========##\n\n');

fprintf(fid2,'dump equil all xyz 1000 equilibration.xyz\n');
fprintf(fid2,'dump_modify equil sort id\n');
fprintf(fid2,'\n');

fprintf(fid2,'##========== define timestep ==========##\n\n');

fprintf(fid2,'timestep ${dt}\n\n');

fprintf(fid2,'##========== define thermo variable settings ==========##\n\n');

fprintf(fid2,'thermo_style      custom step time temp press pxx pyy pzz pe ke etotal vol lx ly lz\n');
fprintf(fid2,'thermo            5000\n');
fprintf(fid2,'thermo_modify     lost error\n\n');

fprintf(fid2,'##========== Minimization ==========##\n\n');

fprintf(fid2,'min_style         cg\n'); 

if simu_dim == 2
    fprintf(fid2,'fix           1 all box/relax x 0.0 y 0.0 couple xy\n');
elseif simu_dim == 3
    fprintf(fid2,'fix           1 all box/relax x 0.0 y 0.0 z 0.0 couple xyz\n');
end

fprintf(fid2,'fix               1 all box/relax x 0.0 y 0.0 z 0.0 couple xyz\n');
fprintf(fid2,'minimize          1e-10 1e-10 200000 400000\n');
fprintf(fid2,'unfix             1\n\n'); 

fprintf(fid2,'##========== Initialize velocities ==========##\n\n');

fprintf(fid2,'velocity          all create ${tset} ${seed} mom yes rot yes dist gaussian units box\n\n'); 

fprintf(fid2,'##========== thermal equilibration ==========##\n\n');

fprintf(fid2,'##========== ave/time ==========##\n\n');

fprintf(fid2,'fix               fluct all ave/time 100 5 1000 v_TIME c_thermo_temp c_thermo_press v_ETOT v_PE v_KE v_LX v_LY v_VOL file fluct_ini.txt\n\n'); 

fprintf(fid2,'##========== NPT ==========##\n\n');

fprintf(fid2,'fix               NPT all npt temp ${tset} ${tset} 0.1 x 0.0 0.0 1.0 y 0.0 0.0 1.0 couple xy\n'); 
fprintf(fid2,'run				50000\n'); 
fprintf(fid2,'unfix             NPT\n\n');

fprintf(fid2,'##========== NVE ==========##\n\n');

fprintf(fid2,'fix				NVE all nve\n'); 
fprintf(fid2,'fix				ts all temp/rescale 1 ${tset} ${tset} 0.01 1.0\n'); 
fprintf(fid2,'run				50000\n'); 
fprintf(fid2,'unfix             ts\n');
fprintf(fid2,'unfix             NVE\n\n'); 

fprintf(fid2,'##========== NVT ==========##\n\n');

fprintf(fid2,'fix				NVT all nvt temp ${tset} ${tset} 0.1\n'); 
fprintf(fid2,'run				50000\n'); 
fprintf(fid2,'unfix             NVT\n\n'); 

fprintf(fid2,'##========== NVE ==========##\n\n');

fprintf(fid2,'fix				NVE all nve\n'); 
fprintf(fid2,'run				50000\n'); 
fprintf(fid2,'unfix             fluct\n'); 
fprintf(fid2,'undump            1\n\n'); 

fprintf(fid2,'##========== NEMD calculation ==========##\n\n');

fprintf(fid2,'fix				H1  sink     heat   1     -0.4\n'); 
fprintf(fid2,'fix				H2  source   heat   1     0.4\n\n'); 

fprintf(fid2,'reset_timestep          0\n\n'); 
fprintf(fid2,'dump              nemdZip         all         custom/gz %d pre.atom.gz id type x y z\n',total_steps/10); 
fprintf(fid2,'dump_modify       nemdZip         sort        id\n\n'); 

fprintf(fid2,'dump              nemd            all         xyz 500000 nemd.xyz\n'); 
fprintf(fid2,'dump_modify       nemd            sort        id\n\n'); 

fprintf(fid2,'compute                 ke        all         ke/atom\n'); 
fprintf(fid2,'variable                temp      atom        c_ke/(1.5*${kB})\n'); 
fprintf(fid2,'compute                 g_chunk   all         chunk/atom bin/1d x lower ${invbinlen} units reduced\n\n'); 
fprintf(fid2,'fix                     g_avg     all         ave/chunk 100 500 50000 g_chunk v_temp file e_profile%d.txt\n\n',sheet_length); 
fprintf(fid2,'fix                     fluct     all         ave/time 100 50 10000 v_TIME c_thermo_temp c_thermo_press v_PX v_PY v_PZ v_ETOT v_PE v_KE file fluct_nve.txt\n\n'); 

fprintf(fid2,'##========== run simulation ==========##\n\n');

fprintf(fid2,'restart                 ${restpoints}         file.restart\n\n'); 
fprintf(fid2,'run                     ${runSteps}\n\n'); 
fprintf(fid2,'write_restart           save.%dns\n',runtime);
fprintf(fid2,'write_data              post_%dns.data\n',runtime);

fclose(fid2);
fclose('all')

