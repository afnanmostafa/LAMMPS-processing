%% input map file for Phana (fix-phonon) to be used in LAMMPS
% Afnan Mostafa
% 01/01/2023

clear;
close all;
clc;
rng('shuffle');

%% crystal info
nx = 10;        % unit cell in x
ny = 10;        % unit cell in y
nz = 1;         % unit cell in z
noAtom = 4;     % 4 atoms per unit cell
totatom = nx*ny*noAtom;

%% set up fields
atom_id = (0:noAtom-1)';
lz = zeros(totatom,1);
indx = (1:totatom)';

%% mapping atoms
k = repmat(atom_id,length(lz)/noAtom,1);
lx = repelem((0:nx-1),noAtom)';
lx = repmat(lx,ny,1);
ly = repelem((0:ny-1),1)';
ly = repelem(ly,nx*noAtom);

%% storing into a cell
c = cell(1,5);
c{1,1} = lx;
c{1,2} = ly;
c{1,3} = lz;
c{1,4} = k;
c{1,5} = indx;

%% write to output map file
filetowrite = fopen('map.data', 'w');
fprintf(filetowrite, '%d %d %d %d\n', nx,ny,nz,noAtom);
fprintf(filetowrite, sprintf('LAMMPS input map file for fix-phonon: %dx%dx%d Graphene unit cells: (above) 10=nx, 10=ny, 10=nz, 4=atoms in a unit cell; (below) lx ly lz k index \n',nx,ny,nz));

for i =1:length(k)
    fprintf(filetowrite, '%d %d %d %d %d\n', lx(i),ly(i),lz(i),k(i),indx(i));
end
fclose(filetowrite);
