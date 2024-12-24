function [A] = makedeadends(Adj,vector)
% Adj is the adjacency matrix
% vector is the n by 2 list of node connections to cut entirely 
%   Detailed explanation goes here
% Process the connections
n1 = vector(:, 1); % Source nodes
n2 = vector(:, 2); % Target nodes

% Set the connections in the adjacency matrix to zero
Adj(sub2ind(size(Adj), n1, n2)) = 0; % Set connection (n1 -> n2) to zero
Adj(sub2ind(size(Adj), n2, n1)) = 0; % Set connection (n2 -> n1) to zero, if the graph is undirected

A = Adj;
end