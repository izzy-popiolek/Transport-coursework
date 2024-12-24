function plotting5(UTLAdata)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% plot scatter with predictions vs original 
% Flatten matrices to vectors
observedFlat = UTLAdata.odMatrix(:);
predictedOriginFlat = UTLAdata.gravityOcentres(:);
predictedDestinationFlat = UTLAdata.gravityDcentres(:);

% % Plot 1: Origin-Constrained Model
% figure;
% scatter(log(predictedOriginFlat), log(observedFlat), 20, 'b', 'filled', 'MarkerFaceAlpha', 0.5); % Scatter plot
% hold on;
% max_val = max(max(observed_flat_100th), max(predicted_flat_100th)); % Determine range for diagonal line
% plot([0, 7], [0, 7], 'k--', 'LineWidth', 1.5); % Diagonal line
% hold off;
% xlabel('Predicted Flows');
% ylabel('Observed Flows');
% legend('Predicted vs Observed', 'Perfect Prediction', 'Location', 'best');

figure;
scatter(log(predictedOriginFlat), log(observedFlat), 'b', 'filled', ...
    'DisplayName', 'Origin-Constrained', 'MarkerFaceAlpha', 0.5);
hold on;
scatter(log(predictedDestinationFlat), log(observedFlat), 'g', 'filled', ...
    'DisplayName', 'Destination-Constrained', 'MarkerFaceAlpha', 0.5);
plot([0, 12], [0, 12], 'k--', 'LineWidth', 1.5, 'DisplayName', 'Perfect Prediction'); % Diagonal line
ylabel('Log of Observations');
xlabel('Log of Predictions');
hold off;
legend('Location','best');

% Create the subplot figure
figure;

% Plot residuals for Origin-Constrained Model (subplot 1)
subplot(1, 2, 1); % 1 row, 2 columns, first subplot
scatter(log(predictedOriginFlat), log(observedFlat), 'b', 'filled', ...
    'DisplayName', 'Origin-Constrained', 'MarkerFaceAlpha', 0.5);
hold on;
plot([0, 12], [0, 12], 'k--', 'LineWidth', 1.5, 'DisplayName', 'Perfect Prediction'); % Diagonal line
ylabel('Log of Observations');
xlabel('Log of Predictions');
hold off;
% xlabel('Observation Index');
% ylabel('Residual (Observed - Predicted)');
% title('Origin-Constrained Model Residuals');
grid on;
legend('Location', 'best');

% Plot residuals for Destination-Constrained Model (subplot 2)
subplot(1, 2, 2); % 1 row, 2 columns, second subplot
scatter(log(predictedDestinationFlat), log(observedFlat), 'g', 'filled', ...
    'DisplayName', 'Destination-Constrained', 'MarkerFaceAlpha', 0.5);
hold on;
plot([0, 12], [0, 12], 'k--', 'LineWidth', 1.5, 'DisplayName', 'Perfect Prediction'); % Diagonal line
ylabel('Log of Observations');
xlabel('Log of Predictions');
hold off;
% xlabel('Observation Index');
% ylabel('Residual (Observed - Predicted)');
% title('Destination-Constrained Model Residuals');
grid on;
legend('Location', 'best');

% Compute residuals
residuals_origin = observedFlat - predictedOriginFlat;
residuals_destination = observedFlat - predictedDestinationFlat;

% Plot residuals
figure;
plot(residuals_origin, 'b.', 'DisplayName', 'Origin-Constrained Residuals');
hold on;
plot(residuals_destination, 'g.', 'DisplayName', 'Destination-Constrained Residuals');
hold off;
xlabel('Observation Index');
ylabel('Residual (Observed - Predicted)');
% title('Residuals for Origin- and Destination-Constrained Models');
legend('Location', 'best');

% Create the subplot figure
figure;

% Plot residuals for Origin-Constrained Model (subplot 1)
subplot(1, 2, 1); % 1 row, 2 columns, first subplot
plot(residuals_origin, 'b.', 'MarkerSize', 10, 'DisplayName', 'Origin-Constrained Residuals');
xlabel('Observation Index');
ylabel('Residual (Observed - Predicted)');
title('Origin-Constrained Model Residuals');
grid on;
legend('Location', 'best');

% Plot residuals for Destination-Constrained Model (subplot 2)
subplot(1, 2, 2); % 1 row, 2 columns, second subplot
plot(residuals_destination, 'g.', 'MarkerSize', 10, 'DisplayName', 'Destination-Constrained Residuals');
xlabel('Observation Index');
ylabel('Residual (Observed - Predicted)');
title('Destination-Constrained Model Residuals');
grid on;
legend('Location', 'best');
end