function hot_SGbase = plot_edgeheatmap(G, s_v, t_v)
    %%% this function takes inputs of your network graph (G)
    %%% source vector (s_v)
    %%% target vector (t_v)

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
end