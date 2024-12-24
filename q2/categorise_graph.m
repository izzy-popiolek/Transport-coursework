function [cornerNodes, degree3or4Nodes, streetNodes, allNodes, G] = categorise_graph(G, h, n)
    %CATEGORISEGRAPH creates vectors containing the street and corner nodes,
    % classifies edges inside G.Edges table
    

    % G = graph
    % h = plot with x and y coordinates
    % n = key parameter in size of graph
    
    % categorise nodes
    smallhalf = floor(n/2);
    bighalf = ceil(n/2);
    cornerNodes = [1, n, ((n*smallhalf) + (bighalf*smallhalf) + 1), (n*bighalf) + (bighalf*smallhalf)];
    totalDegree = indegree(G) + outdegree(G);
    % Logical indexing
    isCornerNode = ismember(1:numnodes(G), cornerNodes);
    isDegree3or4 = totalDegree == 6 | totalDegree == 8;
    isStreetNode = totalDegree == 4 & ~isCornerNode';
    degree3or4Nodes = find(isDegree3or4);
    streetNodes = find(isStreetNode);
    allNodes = 1:numnodes(G); 
    
    % Categorise edges
    edgeRows = strings(numedges(G), 1);
    edgeCols = strings(numedges(G), 1);
    edgeDirections = strings(numedges(G), 1);
    for k = 1:numedges(G)
        src = G.Edges.EndNodes(k, 1); % Source node
        tgt = G.Edges.EndNodes(k, 2); % Target node
    
        % Get the coordinates of the source and target nodes
        x1 = h.XData(src);
        y1 = h.YData(src);
        x2 = h.XData(tgt);
        y2 = h.YData(tgt);
    
        % Classify the edge based on the coordinates
        if y1 == y2  % Same row -> Horizontal edge (Row)
            % The edge belongs to the row determined by y1 (or y2)
            edgeRows(k) = num2str(y1);  % Row number (Y-coordinate as string)
            edgeCols(k) = [num2str(x1) '->' num2str(x2)];  % Not applicable for columns
    
            % Determine the direction: left to right or right to left
            if x1 < x2
                edgeDirections(k) = "Left to Right";
            elseif x1 > x2
                edgeDirections(k) = "Right to Left";
            end
        elseif x1 == x2  % Same column -> Vertical edge (Column)
            % The edge belongs to the column determined by x1 (or x2)
            edgeCols(k) = num2str(x1);  % Column number (X-coordinate as string)
            edgeRows(k) = [num2str(y1) '->' num2str(y2)];  % Not applicable for rows
    
            % Determine the direction: up to down or down to up
            if y1 < y2
                edgeDirections(k) = "Down to Up";
            elseif y1 > y2
                edgeDirections(k) = "Up to Down";
            end
        end
    end
    
    % Add the row, column, and direction information as new columns in the G.Edges table
    G.Edges.y = edgeRows;
    G.Edges.x = edgeCols;
    G.Edges.direction = edgeDirections;
end