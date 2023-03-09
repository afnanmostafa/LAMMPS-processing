%% Afnan Mostafa
%% 06/08/2021
%% This code uses 'J0Jt.data' file dumped from LAMMPS to plot the
%% heat-current auto-correlation function (HCACF or HACF or ACF)
%% w.r.to time or lag (normalized/not)
clear;
clc;
close all;
%% getting user-inputs %%
Nevery=3500;                % s (sampling interval)
Nrepeat=100;                % p (correlation data points)
runtime_ns = 5.25;          % ns
timeSeries = 0.0001;        % ps
time_in_steps=(runtime_ns*1000)/timeSeries;
file = 'J0Jt.data';
isNormalized = true;       % normalized HCACF --> 1

%% collect data from file
fid = fopen(file);
count = 0;
while true
  if ~ischar(fgetl(fid)); break; end
  count = count + 1;
end
fclose(fid);

%% calling hcacf function (separate file -- hcacf.m) %%
[z,intervals] = hcacf(file,Nrepeat,Nevery,count,time_in_steps,isNormalized);

%% plotting HCACF w.r.to time (CUSTOM) %%
timeSeries=0:runtime_ns/(intervals):runtime_ns;
timeSeries=timeSeries';
acf=autocorr(double(z),'NumLags',intervals);

%% plotting features
plot(timeSeries, acf,'-r','LineWidth',2)
hold on
yline(0,'Parent',gca,'Color',[0 0 1],'FontWeight','bold','LineStyle',...
    '--',...
    'LineWidth',1.5,...
    'FontName','Garamond',...
    'FontSize',18,...
    'Label',{'Fluctuations about this'});
if isNormalized == true
    figdecor(gcf,'Time (ns)','Normalized Heat-Current Auto-Correlation Function (HCACF)',300)
else
    figdecor(gcf,'Time (ns)','Heat-Current Auto-Correlation Function (HCACF)',300)
end
set(gca,'FontSize',16)
