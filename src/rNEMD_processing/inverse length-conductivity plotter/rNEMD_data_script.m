%% RD-IBG
x = [1/120, 1/100,1/80, 1/60, 1/40];
y = [1/93.5, 1/88.69, 1/75.4, 1/61.5, 1/56.12];

plot(x,y,'ro','MarkerEdge', 'r','MarkerFace', 'w','MarkerSize',9);
hold on

P = polyfit(x, y, 1);
m = P(1);
c = P(2);
k_INF = c^-1;
yfit = P(1)*x+P(2);

hold on;
x1 = [0, x];
plot(x1, m.*x1+c, 'r-','LineWidth',1.5);
plot(x,y,'ro','MarkerEdge', 'r','MarkerFace', [1 1 1],'MarkerSize',9);

%% error
err = errorbar(x(1), y(1), std([1/96.9,1/105.49]));
err.Color = 'r';
err.LineWidth = 1.5;
err = errorbar(x(2), y(2), std([1/79.9,1/87.49]));
err.Color = 'r';
err.LineWidth = 1.5;
err = errorbar(x(3), y(3), std([1/67.9,1/72.49]));
err.Color = 'r';
err.LineWidth = 1.5;
err = errorbar(x(4), y(4), std([1/58.9,1/63.49]));
err.Color = 'r';
err.LineWidth = 1.5;
err = errorbar(x(5), y(5), std([1/51.9,1/59.49]));
err.Color = 'r';
err.LineWidth = 1.5;
figdecor(gcf,'1/L (nm^{-1})', '1/k (mK/W)',300);
newfig = rNEMD(y,c);
annotation(gcf,'textbox',...
    [0.629294036061027 0.882739212007504 0.229929264909848 0.0365853658536589],...
    'String','f_{sp^{3}} = 1.25% AB-Stacked RD-IBG',...
    'FontWeight','bold',...
    'FontSize',16,...
    'FontName','garamond',...
    'FitBoxToText','off',...
    'BackgroundColor',[0.941176470588235 0.941176470588235 0.941176470588235]);
% set(gcf, 'Position', get(0, 'Screensize'));