function viable_route(G, vec1, vec2)
    % G: MATLAB graph object
    % vec1: Vector of starting nodes
    % vec2: Vector of target nodes

    % Compute the distance matrix
    D = distances(G);

    % Check if every node in vec1 can reach any node in vec2
    forward = all(all(D(vec1, vec2) < Inf, 2));

    % Check if every node in vec2 can reach any node in vec1
    backward = all(all(D(vec2, vec1) < Inf, 2));

    disp(['Can travel from all street nodes to all corner nodes: ', mat2str(forward)]);
    disp(['Can travel from all corner nodes to all street nodes: ', mat2str(backward)]);
end