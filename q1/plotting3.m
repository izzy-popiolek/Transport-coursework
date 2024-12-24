function plotting3(mdl,x,y,c,alpha)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Display the estimated parameters
% fprintf('C: %f\n', MSOAdata.c);
% fprintf('Alpha: %f\n', MSOAdata.alpha);
% % Display R-squared value
% fprintf('R-squared: %f\n', mdl.Rsquared.Ordinary);
% Plot the data and fitted line
figure;
% Scatter plot of the data points
scatter(x, y, 10, 'color', 'b', 'DisplayName', 'UTLA data');  
hold on;
% Plot the fitted line
plot(x, mdl.Fitted, '-', 'color', 'y', 'LineWidth', 1, 'DisplayName', 'Linear Fit');
% Customize axis labels and title
xlabel('Log of Distance, ln(d_{ij})', 'FontSize', 12);
ylabel('Log of Scaled Demand, ln(F_{ij} / (O_i \cdot D_j))', 'FontSize', 12);
title('Fitting linear model to OD data', 'FontSize', 14);
% Display legend and grid
legend('Location', 'best');
grid on;
% % Add equation annotation to the plot
% equation_str = sprintf('y = %.4f %+.4f x', beta0, beta1);
% xpos = min(x) + 0.05 * (max(x) - min(x));
% ypos = max(y) - 0.1 * (max(y) - min(y));
% text(xpos, ypos, equation_str, 'FontSize', 12, 'Color', 'black', 'BackgroundColor', 'white');
fprintf('C: %f\n', c);
fprintf('Alpha: %f\n', alpha);
hold off;
end