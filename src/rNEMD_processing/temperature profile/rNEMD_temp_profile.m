function [len,temp,bins] = rNEMD_temp_profile(filename,sheet_length,width,timestep,start_time,final_time,isNondim)
%   rNEMD temperature profile generator
%   this function plots the temperature profile of rNEMD simulation. It
%   takes 7 inputs: file, length(nm), width(nm), timestep size(ps), time 
%   to start collecting data(ns), time to stop collecting data(ns),
%   and whether to non dimensionalize(1) or not(0).
%   stc = subject-to-change.
%   %%

start_step = (start_time*1000)/timestep;
final_step = (final_time*1000)/timestep;          
colorlist = [1 0 1];                %stc

[len,temp,bins]=temp_profile(filename,start_step,final_step);

binlen = 2*sheet_length;

if isNondim == 1
    factor = binlen;
    len=len./factor;
    non_dim_length = max(len);
elseif isNondim == 0
    factor = 1;
    len=len./factor;
    non_dim_length = max(len);
end

points = linspace(1,100,bins);      %stc
scatterplot = scatter(len, temp, [], points, 'filled');
scatterplot.MarkerFaceColor = colorlist;
len=len';

%% PLOT linear FIT %stc-- change 15,20 or 5,4 to move slopes (try)

if sheet_length > 50
    right_start = (3/5)*non_dim_length+ 15/(factor);
    right_end = (4/5)*non_dim_length+ 20/(factor);
    left_start = (1/5)*non_dim_length - 20/(factor);
    left_end = (2/5)*non_dim_length - 15/(factor);
else
    right_start = (3/5)*non_dim_length+ 5/(factor);
    right_end = (4/5)*non_dim_length+ 5/(factor);
    left_start = (1/5)*non_dim_length - 4/(factor);
    left_end = (2/5)*non_dim_length - 4/(factor);
end

ft_left = polyfit(len(left_start*factor:left_end*factor), temp(left_start*factor:left_end*factor),1);
ft_right = polyfit(len(right_start*factor:right_end*factor), temp(right_start*factor:right_end*factor),1);

fitx_left = linspace(left_start,left_end,25);
fity_left = (ft_left(1)).*fitx_left+ft_left(2);

fitx_right = linspace(right_start,right_end,25);
fity_right = ft_right(1).*fitx_right+ft_right(2);

avg_slope = (abs(ft_right(1)) + abs(ft_left(1)))/2;
avg_slope = avg_slope/factor;

hold on
plot(fitx_left,fity_left,'-b','LineWidth',3);
plot(fitx_right,fity_right,'-b','LineWidth',3);

xline(left_start,'Parent',gca,'Color',[0 0 0],'FontWeight','bold','LineStyle',...
    '--',...
    'LineWidth',1,...
    'FontName','Garamond',...
    'FontSize',14,...
    'Label',{'Data collection starts (left slope)'});

xline(left_end,'Parent',gca,'Color',[0 0 0],'FontWeight','bold','LineStyle',...
    '--',...
    'LineWidth',1,...
    'FontName','Garamond',...
    'FontSize',14,...
    'Label',{'ends (left slope)'});

xline(right_start,'Parent',gca,'Color',[0 0 0],'FontWeight','bold','LineStyle',...
    '--',...
    'LineWidth',1,...
    'FontName','Garamond',...
    'FontSize',14,...
    'Label',{'starts (right slope)'});

xline(right_end,'Parent',gca,'Color',[0 0 0],'FontWeight','bold','LineStyle',...
    '--',...
    'LineWidth',1,...
    'FontName','Garamond',...
    'FontSize',14,...
    'Label',{'ends (right slope)'});
%% Decor
if isNondim == 1
    figdecor(gcf, 'Non-dimensionalized Length, x/L', 'Temperature (K)', 300);
elseif isNondim == 0
    figdecor(gcf, 'Spatial Bin (2*Length)', 'Temperature (K)', 300);
end

legend(scatterplot(1),...
    sprintf('%d nm \\times %d nm',sheet_length,width),...
    'FontSize', 20, 'Location','north');

if isNondim == 0
    xlim([0-10,sheet_length*2+10]);
    ylim([min(temp)-4, max(temp)+4]);
elseif isNondim == 1
    xlim([(0-10)/(sheet_length*2),(sheet_length*2+10)/(sheet_length*2)]);
    ylim([min(temp)-4, max(temp)+4]);
end

axes2 = axes('Parent',gcf,...
    'Position',[0.130316742081448 0.110834371108344 0.775284287806592 0.815356105082132]);

if isNondim == 0
    xlabel(axes2,'Sheet Length, L (nm)','FontWeight','bold','FontName','Garamond');
    xlim(axes2,[0-5 sheet_length+5]);
    set(axes2,'Color','none','FontName','Garamond','FontSize',16,'FontWeight',...
    'bold','LineWidth',2,'TickLength',[0.0094 0.0014],'XAxisLocation','top',...
    'XDir','normal','XGrid','off','YAxisLocation','right','YGrid','on',...
    'YTick',zeros(1,0),'YTickLabel','','YDir','reverse','YColor','k');
elseif isNondim == 1
    xlabel(axes2,'Spatial Bin (2*Length)','FontWeight','bold','FontName','Garamond');
    xlim(axes2,[0-10 (sheet_length*2)+10]);
    set(axes2,'Color','none','FontName','Garamond','FontSize',16,'FontWeight',...
    'bold','LineWidth',2,'TickLength',[0.0094 0.0014],'XAxisLocation','top',...
    'XDir','normal','XGrid','off','YAxisLocation','right','YGrid','on',...
    'YTick',zeros(1,0),'YTickLabel','','YDir','reverse','YColor','k');
end

%% function for getting data to plot temperature profile
    function [len,temp,bins] = temp_profile(filename,start_step,final_step)
        
        A = regexp(fileread(filename),'\n','split');
        whichline = find(contains(A,num2str(final_step)));
        init_header=4;
        whichline0 = find(contains(A,num2str(start_step)));
        start=whichline0(1);
        ending=whichline;
        first_instance = find(contains(A,' 1 '));
        first_instance = first_instance(2)-1-1-init_header;
        diff = first_instance+1;
        bins = first_instance;
        intervals = (start:diff:ending);
        iterations=((ending-start)/diff)+1;
        x = zeros(bins*iterations,1);
        y = zeros(bins*iterations,1);
        
        for i = 1:iterations
            fid = fopen(filename);
            s = textscan(fid,'%d %f %f %f',bins,'headerlines',intervals(i));
            fclose(fid);
            x(bins*(i-1)+1:bins*i,1) = s{1};
            y(bins*(i-1)+1:bins*i,1)=s{4};
        end
        
        temp = zeros(bins,1);
        
        for i=1:bins
            indices = x==i;
            result = mean(y(indices));
            temp(i) = result;
        end
        
        len = (1:bins);
    end
end

