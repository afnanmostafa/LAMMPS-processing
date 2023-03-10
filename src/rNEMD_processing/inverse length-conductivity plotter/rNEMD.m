function [output] = rNEMD(k,slope)
%rNEMD double-axes rNEMD plotter
%   plots 1/k vs. 1/L and k vs. L for rNEMD figures

text(-0.00025, slope, sprintf('%.5f',slope), 'Color','b', 'Horiz','right','FontWeight','Bold',...
    'FontName','Garamond', 'FontSize',24);
figdecor(gcf,'1/L (nm^{-1})', '1/k (mK/W)',600)

ylabel('^{1}/_{k} (mK/W)','FontWeight','bold','FontName','Garamond'); 
xlabel('^{1}/_{L} (nm)^{-1}','FontWeight','bold','FontName','Garamond');
% xlabel('$\frac{1}{L} (nm)^{-1}$','Interpreter','latex','FontWeight','bold','FontName','Garamond');
h = gca; % Get axis to modify
h.XAxis.MinorTick = 'off';
h.XAxis.TickLabelRotation = 15;
h.YAxis.MinorTick = 'off';
legend('off')
box off
xlim([0, 1/38])
ylim([-0.01 0.04]);
plot(0, slope, 'o','MarkerSize', 9, 'MarkerFace', 'b');
set(gca,'Clipping','off','FontName','Garamond','FontSize',24,'FontWeight',...
    'bold','LineWidth',2,'XTick',[0 0.005 0.0083 0.01 0.0125 0.0167 0.02 0.025]);
yl=yline(slope,'--','k_{bulk}','LineWidth',1.5);
yl.LabelHorizontalAlignment = 'center';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [0 0 1];
yl.FontName = 'Garamond';
yl.FontSize = 24;
yl.FontWeight = 'Bold';

axes2 = axes('Parent',gcf,...
    'Position',[0.130316742081448 0.110834371108344 0.775284287806592 0.815356105082132]);

% Create xlabel
xlabel(axes2,'Sheet Length, L (nm)','FontWeight','bold','FontName','Garamond');

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes2,[0 160]);
% Set the remaining axes properties
set(axes2,'Color','none','FontName','Garamond','FontSize',24,'FontWeight',...
    'bold','LineWidth',2,'TickLength',[0.0094 0.0014],'XAxisLocation','top',...
    'XDir','reverse','XGrid','on','XTick',[8 58.5 84 99.3 109.5 160],'XTickLabel',...
    {'40','60','80','100','120','\infty'},'YAxisLocation','right','YGrid','on',...
    'YTick',zeros(1,0),'YTickLabel','','YDir','reverse','YColor','k');
yyaxis left
% n_dig = 2 % number of significant digits you want
% ctick = get(gca, 'xTick');
% xticks(unique(round(ctick,n_dig)));

set(axes2,'YColor',[0 0 0])
yyaxis right

% ytickformat('%.2f')
set(gca,'YColor',[0 0 0],'YMinorTick','off','YScale',...
    'linear','YTick',[102.4 172.4],'YTickLabel',{'172.4','102.4'});
ylim(axes2,[-0.01 0.04]);
grid(axes2,'on');
ylabel('k (W/mK)')

yticks([slope k(1) k(5)])
grid on
yticklabels ({1/slope, 1/k(1), 1/k(5)})

output = gcf;

end

