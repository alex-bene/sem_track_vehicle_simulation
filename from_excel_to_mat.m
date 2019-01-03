% Create New Variables Named elevation and slope and Copy the Data From Excel

% For an example of slope and elevation you can load slope_2016 and elevation_2016 by uncommenting the following code
% elevation = load('elevation_2016');
% slope = load('slope_2016');

% Then Run the Script
in_sampled_elevation = elevation(:,2);
in_sampled_elevation = in_sampled_elevation';
in_sampled_positions_elevation = elevation(:,1);
in_sampled_positions_elevation = in_sampled_positions_elevation';

in_sampled_slope = slope(:,2);
in_sampled_slope = in_sampled_slope';
in_sampled_positions_slope = slope(:,1);
in_sampled_positions_slope = in_sampled_positions_slope';

load('track_data.mat');
track_length=2244;

number_of_elevation_sampled_points = length(in_sampled_positions_elevation);
number_of_slope_sampled_points = length(in_sampled_positions_slope);

save('track_data.mat', 'in_sampled_elevation', 'in_sampled_positions_elevation', 'in_sampled_slope', 'in_sampled_positions_slope', 'number_of_elevation_sampled_points', 'number_of_slope_sampled_points', 'track_length');
