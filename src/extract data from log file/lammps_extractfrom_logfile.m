close
clear
clc

%% change only user inputs:

%% dt = timestep of your simulation in picoseconds (metal units in LAMMPS)

%% values = what thermo output you want to plot (make them consistent with
%%% the names you used in LAMMPS input script)

%% merging = how many minimizers + fixes you used in your simulation
%%% here 4 = minimize+NVE+NVT+NVE

%% merging --> true/false; true if you want to see total evolution
%%% (min+equil); false if you want to see just minimization evolution

%% user inputs
dt = 0.0001;
values = ["Step", "v_la", "v_lb",];
merging = true;
mergings = 4;

%% location of file
[file,path] = uigetfile('*.lammps');
if isequal(file,0)
    disp('User did not select a file');
else
    disp(['User selected ', fullfile(path,file)]);
end

linesplit = regexp(fileread(file),'\n','split');
whichline = find(contains(linesplit,'Step'));
mini_headerline = whichline(1);

%% %% getting all lines of data file
fid = fopen(file);
tline = fgetl(fid);
tlines = cell(0,1);

while ischar(tline)
    tlines{end+1,1} = tline;   %listing each line as a separate array
    tline = fgetl(fid);
end

fclose(fid);

tlines = strtrim( tlines );
str = tlines(mini_headerline);
str = split(str);

indices = zeros(length(values),1);

for i=1:length(values)
    isK = cellfun(@(x)isequal(x,values(i)),str);
    [row, col] = find(isK);
    indices(i) = row;
end

dataheader = tlines(whichline(1));
counts = zeros(size(dataheader));

for g = 1 : length(dataheader)
    counts(g) = length(strsplit(dataheader{g}));
end

if merging == false
    [s,~] = readtextfile(file,counts,mini_headerline,'','#');
    step = s{1,indices(1)};
    lx=s{1,indices(2)};
    ly=s{1,indices(3)};
else
    columns = length(values);
    entries = (1:columns);
    
    for j = 1:mergings
        [s,~] = readtextfile(file,counts,whichline(j),'','#');
        for u = 1:length(entries)
            my_field = strcat('v',num2str(j),num2str(u));
            variable.(my_field) = s{1,indices(entries(u))};
        end
    end
    
    A_cell = struct2cell(variable);
    data_cell = cell(0,1);
    data_c = cell(0,1);
    c = 1;
    intervals = (1:length(entries):mergings*length(entries));
    
    for o = 1:length(entries)
        for k = 1:mergings
            data_c{k,o} = [A_cell{intervals(k)+o-c,1}];
        end
    end
end

for y = 1:length(entries)
    data_cell{y,1} = cat(1, data_c{:,y});
end

%% for multiple plots (change if you don't want multiple plots)
cout = 2;

for b = 1:length(values)-1
    plot(data_cell{1,1}.*dt,data_cell{cout,1},'-','LineWidth',2,'DisplayName',values(cout))
    cout = cout+1;
    hold on
end

xline(A_cell{1,1}(end)*dt,'Parent',gca,'--m',...
    'LineWidth',2,...
    'FontName','Garamond',...
    'FontSize',18,...
    'Label',{'Minimization ends here'});
xline(A_cell{intervals(end),1}(end)*dt,'-.m',...
    'LineWidth',2,...
    'FontName','Garamond',...
    'FontSize',18,...
    'Label',{'Equilibration ends here'});

figdecor(gcf,'Time (ps)','Thermodynamic Property (Arb. units)',300);