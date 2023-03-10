function [k] = fourier_heat(heatFlux_perStep,time_ps,sheet_width,sheet_height,slope)
%   This code uses the Fourier law to compute thermal conductivity using
%   Non-equilibrium Molecular Dynamics (NEMD)
%   input: heatFlux_perStep(ev/ps), time_ps(ps), width(nm), 
%   height (nm), slope (K/nm) --> units are constructed this way to
%   keep them consistent with LAMMPS metal unit
%   %%

%% Q
totFlux = heatFlux_perStep*time_ps;
totFlux_SI = (totFlux*1.6e-19);
heat_in_one_direction_SI = totFlux_SI/2;

%% A
area = sheet_width*sheet_height;
area_SI = area*(1e-18);

%% dT/dx
slope_SI = slope/1e-9;

%% k = (Q/A)*(dx/dT) (W/mK)
k = ((heat_in_one_direction_SI)/(area_SI*time_ps*1e-12))*(1/slope_SI);

end

