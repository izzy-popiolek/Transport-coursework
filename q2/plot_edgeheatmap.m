function plot_edgeheatmap(G, streets, corners, n, v)
    %%% this function takes inputs of your network graph (G)
    %%% source vector (s_v)
    %%% target vector (t_v)

    s_v = repmat(corners, 1, length(streets)); % repeat %number of streetnodes% times
    t_v = repmat(streets', 1, 4); % repeat 4 times because there are always four corners

    % finds the shortest path for each s-t pair and finds which edges in
    % the network are used the most.
    [P, d, ep] = arrayfun(@(s,t) shortestpath(G,s,t,'Method','positive'), s_v, t_v, UniformOutput=false);

    function count_arr = count_edge_hot(edges, num_edges)
    % generate zero basic count_arr
    count_arr = zeros(num_edges,1);
    % zero check
    if isempty(edges)
    else
        count_arr(edges{:}) = 1;
    end
    end
    % edge count
    e_c = arrayfun(@count_edge_hot, ep, height(G.Edges).*ones(size(d)), UniformOutput=false);
    % this is currently an cell array
    
    % converting into a normal array
    e_c_arr = zeros(height(G.Edges), length(s_v)^2);

    for i = 1:length(s_v)
        e_c_arr(:,i) = cell2mat(e_c(i));
    end
    
    hot_SGbase = sum(e_c_arr, 2);
    
    % normalise this
    max_hot = max(hot_SGbase);
    min_hot = min(hot_SGbase);
    
    norm_e_hot = (hot_SGbase - min_hot)./(max_hot-min_hot);

    [x, y] = meshgrid(1:n, 1:n);
    for i = v
        x(i) = [];
        y(i) = [];
    end
    figure;
    colormap('turbo'); 
    h = plot(G, EdgeCData=norm_e_hot);
    colorbar()
    h.XData = x(:);
    h.YData = y(:);
    axis equal
end