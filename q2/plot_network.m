function [G, h] = plot_network(A, n, v)
    % Plot grid networks, removing repeated lines of code from main
    % A = adjacency matrix
    figure;
    G = digraph(A, 'omitselfloops');
    h = plot(G);
    [x, y] = meshgrid(1:n, 1:n);
    for i = v
        x(i) = [];
        y(i) = [];
    end
    h.XData = x(:);
    h.YData = y(:);
    axis equal
end