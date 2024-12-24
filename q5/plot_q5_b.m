% plot sensor locations
% figure();
% plot_network(A,[Melbourne_Node.Lat,Melbourne_Node.Long],'-b.')
% hold on
% coloured animation according to hour count
% 
% geoscatter(Melbourne_Node.Lat, Melbourne_Node.Long, 'magenta', 'filled')
% geoscatter(Location_data.Latitude(sel_idx), Location_data.Longitude(sel_idx), 'cyan','filled')
% geoscatter(Melbourne_Node.Lat(new_sel_idx), Melbourne_Node.Long(new_sel_idx), 'yellow', 'filled')
% hold off

figure;
hold on;

% Compute axis limits from node data
padding = 0.0001; % Add some padding to prevent clipping
x_min = min(Melbourne_Node.Long) - padding;
x_max = max(Melbourne_Node.Long) + padding;
y_min = min(Melbourne_Node.Lat) - padding;
y_max = max(Melbourne_Node.Lat) + padding;

% Lock axis limits before plotting
xlim([x_min, x_max]);
ylim([y_min, y_max]);

pos_table = [Melbourne_Node.Lat,Melbourne_Node.Long];
s = '-b.';

% Plot edges (adjacency matrix A)
N = size(A, 2);
for i = 1:N
    for j = i+1:N
        if A(i, j) == 1
            % Extract edge positions
            xx = [Melbourne_Node.Long(i), Melbourne_Node.Long(j)];
            yy = [Melbourne_Node.Lat(i), Melbourne_Node.Lat(j)];
            % Plot the edge
            plot(xx, yy, '-k', 'LineWidth', 0.5); % Blue lines for edges
        end
    end
end

% Plot graph nodes
plot(Melbourne_Node.Long, Melbourne_Node.Lat, 'k.', 'MarkerSize', 10);
% Plot sensor nodes
plot(Location_data.Longitude(sel_sen_id), Location_data.Latitude(sel_sen_id), 'gx', 'MarkerSize', 10);
% Plot closest nodes
plot(Melbourne_Node.Long(new_sel_idx), Melbourne_Node.Lat(new_sel_idx), 'go', 'MarkerSize', 8, 'MarkerFaceColor','g');

% Add labels, legend, and title
xlabel('Longitude');
ylabel('Latitude');
title('Network, Nodes and Sensors');
axis equal; % Maintain aspect ratio
grid on;


% figure;
% pos_table = [Melbourne_Node.Lat,Melbourne_Node.Long];
% s = '-b.';
% 
% geolimits([min(pos_table(:,1)) max(pos_table(:,1))],[min(pos_table(:,2)) max(pos_table(:,2))])
% hold on;
% 
% N = size(A,2); 
% for i = 1 : N
%     for j = i+1 : N
%         if A(i,j) == 1
%             xx = pos_table([i,j],1)';
%             yy = pos_table([i,j],2)';
%             hold on;
%             % geoplot(xx,yy,s,'linewidth',0.5,'MarkerSize',,'MarkerEdgeColor','w','MarkerFaceColor',[0,1,0]);
%             geoplot(xx,yy,s,'linewidth',1);
%         end
%     end
% end
% 
% geoscatter(Melbourne_Node.Lat, Melbourne_Node.Long, 'magenta', 'filled')
% geoscatter(Location_data.Latitude(sel_idx), Location_data.Longitude(sel_idx), 'cyan','filled')
% geoscatter(Melbourne_Node.Lat(new_sel_idx), Melbourne_Node.Long(new_sel_idx), 'yellow', 'filled')
% hold off
% 
% geobasemap streets;

% figure;
% 
% % Define positions (latitude and longitude) of nodes
% pos_table = [Melbourne_Node.Lat, Melbourne_Node.Long];
% s = '-b.'; % Style for edges
% 
% % Set geographic limits based on the node positions
% lat_limits = [min(pos_table(:,1)) - 0.001, max(pos_table(:,1)) + 0.001]; % Add small padding
% lon_limits = [min(pos_table(:,2)) - 0.001, max(pos_table(:,2)) + 0.001];
% geolimits(lat_limits, lon_limits);
% 
% % Set the basemap before plotting
% geobasemap streets;
% 
% hold on;
% 
% % Plot graph edges based on adjacency matrix A
% N = size(A, 2); 
% for i = 1:N
%     for j = i+1:N
%         if A(i, j) == 1
%             % Extract the edge positions
%             xx = pos_table([i, j], 1)'; % Latitudes
%             yy = pos_table([i, j], 2)'; % Longitudes
%             % Plot the edge using geoplot
%             geoplot(xx, yy, s, 'LineWidth', 1); % Blue line with dots
%         end
%     end
% end
% 
% % Scatter plot for nodes
% geoscatter(Melbourne_Node.Lat, Melbourne_Node.Long, 30, 'magenta', 'filled', 'DisplayName', 'Graph Nodes');
% geoscatter(Location_data.Latitude(sel_idx), Location_data.Longitude(sel_idx), 50, 'cyan', 'filled', 'DisplayName', 'Sensor Nodes');
% geoscatter(Melbourne_Node.Lat(new_sel_idx), Melbourne_Node.Long(new_sel_idx), 50, 'yellow', 'filled', 'DisplayName', 'Closest Nodes');
% 
% % Add a legend
% title('Geographic Visualization of Nodes and Edges');
% hold off;


% figure;
% hold on;
% 
% % Plot edges (adjacency matrix A)
% N = size(A, 2);
% for i = 1:N
%     for j = i+1:N
%         if A(i, j) == 1
%             % Extract edge positions
%             xx = [Melbourne_Node.Long(i), Melbourne_Node.Long(j)];
%             yy = [Melbourne_Node.Lat(i), Melbourne_Node.Lat(j)];
%             % Plot the edge
%             plot(xx, yy, '-b', 'LineWidth', 0.5); % Blue lines for edges
%         end
%     end
% end
% 
% % Plot nodes
% plot(Melbourne_Node.Long, Melbourne_Node.Lat, 'm.', 'MarkerSize', 15, 'DisplayName', 'Graph Nodes');
% plot(Location_data.Longitude(sel_idx), Location_data.Latitude(sel_idx), 'c*', 'MarkerSize', 15, 'DisplayName', 'Sensor Nodes');
% plot(Melbourne_Node.Long(new_sel_idx), Melbourne_Node.Lat(new_sel_idx), 'yo', 'MarkerSize', 10, 'DisplayName', 'Closest Nodes');
% 
% % Add labels and legend
% xlabel('Longitude');
% ylabel('Latitude');
% title('Nodes and Edges on Cartesian Axes');
% axis equal; % Maintain aspect ratio
% grid on;
% hold off;
