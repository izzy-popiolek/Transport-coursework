%% load the primary source data from Melbourne Pedestrian Count
% for June 2024
% for sensor locations
PCount_data = readtable("June_2024.csv", VariableNamingRule='preserve');
Location_data = readtable("pedestrian-counting-system-sensor-locations.csv");

% process data to be in smaller chunks
tot_hrs = 300;
% selected sensors (same as week 5 exercise)
% sel_sen_id = [20 72 36 45 65 67 68 39 63 69 84 117 52 56];
sel_sen_id = [20 30 45 52 56 1 3 47 63 72 36 24 25 18 2 58];

% extract selected data
% need to get sensor description
sel_idx = zeros(0,length(sel_sen_id));
sel_sen_sd = strings(0,length(sel_sen_id));
j = 1;

for i = sel_sen_id
    idx = find(Location_data.Location_ID==i); % can be multiple locations listed
    sel_sen_sd(j) = Location_data.Sensor_Description(idx(1));
    sel_idx(j) = idx(1);
    j = j+1;
end

%% 
% adjust 114 Flinders street name (not same in PCount data as in Location
% data)
idx_114F = find(sel_sen_sd == '114 Flinders Street Car Park Footpath');
sel_sen_sd(idx_114F) = '114 Flinders St';

% extract 300 hrs of counts for locations
sel_sen_cts = zeros(tot_hrs, length(sel_sen_id));
j = 1;
for i = sel_sen_sd
    sel_sen_cts(:,j) = PCount_data.(i)(1:tot_hrs);
    j = j+1;
end

clear i j

%% 
Load_Melbourne_StData

%% 
new_sel_idx = zeros(1, length(sel_sen_id)); 

for i = 1:length(sel_sen_id)
    
    sensor_lat = Location_data.Latitude(sel_sen_id(i));
    sensor_lon = Location_data.Longitude(sel_sen_id(i));
    distances = distance([sensor_lat.*ones(height(Melbourne_Node),1),sensor_lon.*ones(height(Melbourne_Node),1)], [Melbourne_Node.Lat, Melbourne_Node.Long]);
    
    % Find the closest node
    [~, new_sel_idx(i)] = min(distances);
end

%% Create data structure with all the importand stuff innit

sen_data = struct('count', sel_sen_cts, 'Lat', Location_data.Latitude(sel_idx), 'Lon', Location_data.Longitude(sel_idx), 'Raw_idx', sel_idx, 'Node_idx', new_sel_idx, 'name', sel_sen_sd);
