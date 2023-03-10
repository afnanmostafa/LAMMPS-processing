function [final_fig] = figdecor(gcf,xlab,ylab,dpi)
%   decorates figure handle
%   in: gcf, xlabel, ylabel, dpi

ax = gca;
box(ax,'on');
set(ax,'FontName','Garamond','FontWeight','bold',...
    'LineWidth',2,'XMinorTick','on','YMinorTick','on');
legend1 = legend(ax,'show');
set(legend1,...
    'LineWidth',2,...
    'FontSize',12,...
    'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
    'FontWeight','normal');
% ylabel
ylabel(ylab,'FontWeight','bold',...
    'FontSize',20,...
    'FontName','Garamond');

% xlabel
xlabel(xlab,...
    'FontWeight','bold',...
    'FontSize',20,...
    'FontName','Garamond');

% uncomment and edit to your need
% legend([pblgaa,pblgab,pintaa,pintab,p2h,p2h2,],'AA-stacked BG','AB-stacked BG','AA-stacked RD-IBG','AA-stacked RD-IBG','2D Lonsdaleite','2D Cubic Diamond','Location','southeast')

print('resized_fig.png','-dpng',['-r' num2str(dpi)]);

final_fig = gcf;
end

