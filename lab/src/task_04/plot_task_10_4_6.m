%% Clear
clear all
close all
clc

%% Files
results_folder = '../../results/task_04/results_04_06/rcons=5_econs=inf/';

load(strcat(results_folder,'states_plot.mat'));
load(strcat(results_folder,'travel_plot.mat'));
load(strcat(results_folder,'u_star_elev_plot.mat'));
load(strcat(results_folder,'u_star_pitch_plot.mat'));
load(strcat(results_folder,'u_pitch_plot.mat'));
load(strcat(results_folder,'u_elev_plot.mat'));

figures_folder = strcat(results_folder, 'figures/');
mkdir(figures_folder);

extension = 'r_cons';

%% Plotting variables
travel_ylim = [-20 220];
travel_rate_ylim = [-55 20];
pitch_ylim = [-75 200];
elev_ylim = [-35 35];

opt_color = 'r';
lqr_color = 'k';
meas_color = 'b';

fig_size = [0 0 800 500];

title_extension = 'r \leq 5';

title_string = strcat('Task 10.4.6 (with feedback), ', title_extension);

%% Plotting

% Travel plot
travel_fig = figure('Position', fig_size);
hold on
plot(travel_plot(1,:), travel_plot(2,:), meas_color);
ylim(travel_ylim);
xlabel('Time [s]');
ylabel('Angle [Deg]');
legend('\lambda');
title(title_string);

travel_rate_fig = figure('Position', fig_size);
hold on
plot(states_plot(1,:), (180/pi)*states_plot(3,:), meas_color);
ylim(travel_rate_ylim);
xlabel('Time [s]');
ylabel('Angle rate [Deg/s]');
legend('r');
title(title_string);

% Pitch plot
pitch_fig = figure('Position', fig_size);
hold on
plot(u_pitch_plot(1,:), (180/pi)*u_pitch_plot(2,:), lqr_color);
plot(u_star_pitch_plot(1,:), (180/pi)*u_star_pitch_plot(2,:), opt_color);
plot(states_plot(1,:), (180/pi)*states_plot(4,:), meas_color);
ylim(pitch_ylim);
xlabel('Time [s]');
ylabel('Angle [Deg]');
legend('p_c', 'p_c^*', 'p');
title(title_string);

% Elevation plot
elev_fig = figure('Position', fig_size);
hold on
plot(u_elev_plot(1,:), (180/pi)*u_elev_plot(2,:), lqr_color);
plot(u_star_elev_plot(1,:), (180/pi)*u_star_elev_plot(2,:), opt_color);
plot(states_plot(1,:), (180/pi)*states_plot(6,:), meas_color);
ylim(elev_ylim);
xlabel('Time [s]');
ylabel('Angle [Deg]');
legend('e_c', 'e_c^*', 'e');
title(title_string);

%% Save figures as files

travel_fig_name = strcat(figures_folder, '10_4_6_travel_', extension, '.eps');
travel_rate_fig_name = strcat(figures_folder, '10_4_6_travel_rate_', extension, '.eps');
pitch_fig_name = strcat(figures_folder, '10_4_6_pitch_', extension, '.eps');
elev_fig_name = strcat(figures_folder, '10_4_6_elevation_', extension, '.eps');

saveas(travel_fig, travel_fig_name, 'epsc');
saveas(travel_rate_fig, travel_rate_fig_name, 'epsc');
saveas(pitch_fig, pitch_fig_name, 'epsc');
saveas(elev_fig, elev_fig_name, 'epsc');