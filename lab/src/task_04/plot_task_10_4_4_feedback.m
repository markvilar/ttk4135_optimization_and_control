%% Clear
clear all
close all
clc

%% Files
results_folder = '../../results/task_04/results_04_04_feedback/q1=1_q2=1/';

load(strcat(results_folder,'states_plot.mat'));
load(strcat(results_folder,'travel_plot.mat'));
load(strcat(results_folder,'u_star_elev_plot.mat'));
load(strcat(results_folder,'u_star_pitch_plot.mat'));
load(strcat(results_folder,'u_pitch_plot.mat'));
load(strcat(results_folder,'u_elev_plot.mat'));

%% Plotting variables
travel_ylim = [-20 220];
pitch_ylim = [-75 75];
elev_ylim = [-35 35];

opt_color = 'r';
lqr_color = 'k';
meas_color = 'b';

fig_size = [0 0 800 500];

%% Plotting

% Travel plot
travel_fig = figure('Position', fig_size);
hold on
plot(travel_plot(1,:), travel_plot(2,:), meas_color);
ylim(travel_ylim);
xlabel('Time [s]');
ylabel('Angle [Deg]');
legend('\lambda');
title('Task 10.4.4 (with feedback)');

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
title('Task 10.4.4 (with feedback)');

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
title('Task 10.4.4 (with feedback)');

%% Save figures as files
figures_folder = strcat(results_folder, 'figures/');
mkdir(figures_folder);

travel_fig_name = strcat(figures_folder, '10_4_4_feedback_travel.eps');
pitch_fig_name = strcat(figures_folder, '10_4_4_feedback_pitch.eps');
elev_fig_name = strcat(figures_folder, '10_4_4_feedback_elevation.eps');

saveas(travel_fig, travel_fig_name, 'epsc');
saveas(pitch_fig, pitch_fig_name, 'epsc');
saveas(elev_fig, elev_fig_name, 'epsc');