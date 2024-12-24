function plotting2(MSOAdata)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% % plot scatter with predictions vs original 
% Flatten matrices to vectors
observed_flat = MSOAdata.odMatrix(:); % Convert observed matrix to vector
predicted_flat = MSOAdata.gravityU(:); % Convert predictions to vector
% Select every 100th point
observed_flat_100th = observed_flat(1:100:end); % Every 100th point from x
predicted_flat_100th = predicted_flat(1:100:end); % Every 100th point from y

% % Identify the indices of the diagonal elements
% diagonal_indices = 1:(size(UTLAdata.odMatrix, 1) + 1):numel(UTLAdata.odMatrix);
% % Create a logical mask to exclude diagonal elements
% mask = true(size(observed_flat));
% mask(diagonal_indices) = false;
% 
% % Remove diagonal values
% observed_flat_no_diag = observed_flat(mask);
% predicted_origin_flat_no_diag = predicted_origin_flat(mask);
% predicted_destination_flat_no_diag = predicted_destination_flat(mask);

% Plot Model
figure;
scatter(log(predicted_flat_100th), log(observed_flat_100th), 20, 'b', 'filled', 'MarkerFaceAlpha', 0.5); % Scatter plot
hold on;
max_val = max(max(observed_flat_100th), max(predicted_flat_100th)); % Determine range for diagonal line
plot([0, 7], [0, 7], 'k--', 'LineWidth', 1.5); % Diagonal line
hold off;
xlabel('Log of Predicted Flows');
ylabel('Log of Observed Flows');
legend('Predicted vs Observed', 'Perfect Prediction', 'Location', 'best');

% Compute residuals
residuals = observed_flat - predicted_flat;

% Plot residuals
figure;
plot(residuals, 'b.');
xlabel('Observation Index');
ylabel('Residual (Observed - Predicted)');
% title('Residuals for Origin- and Destination-Constrained Models');
% legend('Location', 'best');
end