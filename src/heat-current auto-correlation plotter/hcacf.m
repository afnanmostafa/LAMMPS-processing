function [z,intervals] = hcacf(file,Nrepeat,Nevery,count,time_in_steps,isNormalized)
%   heat-current auto-correlation plotter
%   takes file, Nrepeat, Nevery, count (# lines), time in steps, and
%   normalized or not (boolean) and gives normalized heat-flux values
%   at certain time steps.
%   %  

headerline=4:Nrepeat+1:count-Nrepeat;   %list of numbers representing headerlines
intervals = (time_in_steps)/(Nrepeat*Nevery);

Jxx = cell(1,intervals+1);
Jyy = cell(1,intervals+1);
Jzz = cell(1,intervals+1);

for i=1:intervals+1
    fid = fopen(file);
    s = textscan(fid,'%f %f %f %f %f %f',Nrepeat,'headerlines',headerline(i));
    fclose(fid);
    
    a=s{1,4};
    Jxx{1,i}=a;
    b=s{1,5};
    Jyy{1,i}=b;
    c=s{1,6};
    Jzz{1,i}=c;
end

%% adding Jxx Jyy Jzz %% %%
z=zeros(intervals+1,1);

for k=1:intervals+1
    c = Jxx{1,k}+Jyy{1,k}+Jzz{1,k};
    z(k,1) = mean(c);
end

if isNormalized == 1
    z = z./z(1);            % normalization
end
end


