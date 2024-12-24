function [MSOAdata] = makegravity(MSOAdata, c, alpha)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Vectorized computation
originSums = MSOAdata.originSums(:); % Ensure column vector
destinationSums = MSOAdata.destinationSums(:)'; % Ensure row vector
numerator = originSums * destinationSums * c; % Outer product
denominator = MSOAdata.distanceMatrix .^ alpha; % Element-wise power
MSOAdata.gravityU = numerator ./ denominator; % Element-wise division
% disp('Diagonal of gravity predictions:');
% disp(diag(MSOAdata.gravityU));

%find and print rmse error
% Get indices of diagonal
diagonalIndices = eye(size(MSOAdata.odMatrix)) == 1;

% Flatten observed and modeled matrices
observedFlows = full(MSOAdata.odMatrix(:));
modeledFlows = full(MSOAdata.gravityU(:));

% Exclude diagonal values
observedFlows(diagonalIndices(:)) = [];
modeledFlows(diagonalIndices(:)) = [];

% Compute RMSE only for off-diagonal flows
errors = observedFlows - modeledFlows;
rmse = sqrt(mean(errors .^ 2));
% fprintf('Root Mean Square Error (RMSE): %.4f\n', rmse);
% disp('Root Mean Square Error (RMSE), c, alpha:');
% disp(rmse);
% disp(c);
% disp(alpha);
% fprintf('RMSE: %.4f, c: %.4f, alpha: %.4f\n', rmse, c, alpha);
end