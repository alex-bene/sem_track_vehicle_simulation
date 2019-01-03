clc;
clear all;
load('track_data.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters Initialization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation Parameters
Ts=1e-3; % time step
% only one of them can be '1' and that means that the simulation will run that way
[vehicle_speed_control, vehicle_acceleration_control, motor_torque_control] = deal(1,0,0);

kp = 3;
ki = 0.01;

% Vehicle parameters
vehicle_mass = 90;
wheel_radius = 0.239;
rolling_resistance_factor = 0.0024; % rolling resistance with 5bar pressure for 40km/h speed
gravity_acceleration = 9.78;
coefficient_regarding_air = 0.0331; % multiply this with speed^2 in m/s for pyrforos total air drag force
%inv_efficiency = 0.92; % inverter efficiency
%trans_efficiency = 0.9; % transmission efficiency
max_torque = 15;
min_torque = 0;

%Interpolation Parameters
interpolated_points_per_meter = 100;
extra_points_for_interpolation = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters Initialization End %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Speed and Acceleration Lookup Tables %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
desired_speed_samples_positions = linspace(0, track_length-1, track_length);
desired_acceleration_samples_positions = linspace(0, track_length-1, track_length);
desired_torque_samples_positions = linspace(0, track_length-1, track_length);
desired_speed = 7 + desired_speed_samples_positions*0;
desired_acceleration = 0.1 + desired_acceleration_samples_positions*0;
desired_torque = 8 + desired_torque_samples_positions*0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Speed and Acceleration Lookup Tables End %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%
% Interpolation %
%%%%%%%%%%%%%%%%%
% Add 'extra_points_for_interpolation' Before and After Our Sampled Inputs for Beter Interpolation
% Elevation
positions_elevation_increased = [(in_sampled_positions_elevation(number_of_elevation_sampled_points-extra_points_for_interpolation:number_of_elevation_sampled_points-1)-track_length) in_sampled_positions_elevation (in_sampled_positions_elevation(2:1+extra_points_for_interpolation)+track_length)];
elevation_increased = [in_sampled_elevation(number_of_elevation_sampled_points-extra_points_for_interpolation:number_of_elevation_sampled_points-1) in_sampled_elevation in_sampled_elevation(2:1+extra_points_for_interpolation)];
% Slope
positions_slope_increased = [(in_sampled_positions_slope(number_of_slope_sampled_points-extra_points_for_interpolation:number_of_slope_sampled_points-1)-track_length) in_sampled_positions_slope (in_sampled_positions_slope(2:1+extra_points_for_interpolation)+track_length)];
slope_increased = [in_sampled_slope(number_of_slope_sampled_points-extra_points_for_interpolation:number_of_slope_sampled_points-1) in_sampled_slope in_sampled_slope(2:1+extra_points_for_interpolation)];

% Calculate Interpolated Data
interpolated_positions = linspace(-extra_points_for_interpolation,track_length+extra_points_for_interpolation, (track_length+2*extra_points_for_interpolation)*interpolated_points_per_meter);
interpolated_elevation = interp1(positions_elevation_increased, elevation_increased, interpolated_positions,'pchip');
interpolated_slope = interp1(positions_slope_increased, slope_increased, interpolated_positions,'pchip');

% Limit Interpolated Data Within Track Length
interpolated_elevation = interpolated_elevation((extra_points_for_interpolation*interpolated_points_per_meter)+1:(track_length+extra_points_for_interpolation)*interpolated_points_per_meter);
interpolated_slope = interpolated_slope((extra_points_for_interpolation*interpolated_points_per_meter)+1:(track_length+extra_points_for_interpolation)*interpolated_points_per_meter);
interpolated_positions = linspace(0,track_length, track_length*interpolated_points_per_meter);
%%%%%%%%%%%%%%%%%%%%%
% Interpolation End %
%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%
% Plot Everything %
%%%%%%%%%%%%%%%%%%%
% Plot Interpolated Elevation
%figure;
%plot(in_sampled_positions_elevation, in_sampled_elevation, 'DisplayName', 'Origina Elevation' );
%hold on;
%plot(interpolated_positions, interpolated_elevation, 'DisplayName', 'Interpolated Elevation' );
%xlim([0 track_length]);
%title('Elevation - Position Diagram');
%xlabel('Position [m]');
%ylabel('Elevation [m]');
%legend;
%grid;

% Plot Slope (Original and Intepolated)
%figure;
%plot(in_sampled_positions_slope, in_sampled_slope, 'DisplayName', 'Origina Slope' );
%hold on;
%plot(interpolated_positions, interpolated_slope, 'DisplayName', 'Interpolated Slope' );
%xlim([0 track_length]);
%title('Slope x100 - Position Diagram');
%xlabel('Position [m]');
%ylabel('Slope x100 [degrees]');
%legend;
%grid;
%%%%%%%%%%%%%%%%%%%%%%%
% Plot Everything End %
%%%%%%%%%%%%%%%%%%%%%%%
