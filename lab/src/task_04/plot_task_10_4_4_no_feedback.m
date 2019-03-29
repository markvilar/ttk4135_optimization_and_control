%% Clear
clear all
close all
clc

%% Plotting variables

results_folder = '../../results/task_04/results_04_04_no_feedback/q1=1_q2=1/';

travel_ylim = [0 220];
pitch_ylim = [-50 80];
elev_ylim = [-35 25];

opt_color = 'r';
meas_color = 'b';

time_start = 0;
time_stop = 18;

fig_size = [0 0 800 500];
title_font_size = 20;
legend_font_size = 18;
label_font_size = 18;

title_string = 'Task 10.4.4, $p_1 = p_2 = 1$ (without feedback)';

%% Files

load(strcat(results_folder,'states_plot.mat'));
load(strcat(results_folder,'travel_plot.mat'));
load(strcat(results_folder,'u_star_elev_plot.mat'));
load(strcat(results_folder,'u_star_pitch_plot.mat'));

%% Plotting

sampling_time = travel_plot(1,2) - travel_plot(1,1);
n_start = floor(time_start/sampling_time) + 1; 
n_stop = floor(time_stop/sampling_time);

% Travel plot
travel_fig = figure('Position', fig_size);
hold on
plot(travel_plot(1,:), travel_plot(2,:), meas_color);
ylim(travel_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle, $[Deg]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$\lambda$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

% Pitch plot
pitch_fig = figure('Position', fig_size);
hold on
plot(u_star_pitch_plot(1,:), (180/pi)*u_star_pitch_plot(2,:), opt_color);
plot(states_plot(1,:), (180/pi)*states_plot(4,:), meas_color);
ylim(pitch_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle, $[Deg]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$p_c^*$', '$p$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

% Elevation plot
elev_fig = figure('Position', fig_size);
hold on
plot(u_star_elev_plot(1,:), (180/pi)*u_star_elev_plot(2,:), opt_color);
plot(states_plot(1,:), (180/pi)*states_plot(6,:), meas_color);
ylim(elev_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle, $[Deg]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$e_c^*$', '$e$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

%% Save figures as files
figures_folder = strcat(results_folder, 'figures/');
mkdir(figures_folder);

travel_fig_name = strcat(figures_folder, '10_4_4_no_feedback_travel.eps');
pitch_fig_name = strcat(figures_folder, '10_4_4_no_feedback_pitch.eps');
elev_fig_name = strcat(figures_folder, '10_4_4_no_feedback_elevation.eps');

saveas(travel_fig, travel_fig_name, 'epsc');
saveas(pitch_fig, pitch_fig_name, 'epsc');
saveas(elev_fig, elev_fig_name, 'epsc');