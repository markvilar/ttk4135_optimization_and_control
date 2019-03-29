%% Clear
clear all
close all
clc

%% Variables

% File
results_folder = '../../results/task_04/results_04_06/rcons=5_econs=inf/';
file_extension = 'rcons';

% Plot
travel_ylim = [-10 220];
travel_rate_ylim = [-60 10];
pitch_ylim = [-60 90];
elev_ylim = [-35 25];
elev_rate_ylim = [-5 25];

opt_color = 'r'; % Color of optimal values
lqr_color = 'k'; % Color of controller values
meas_color = 'b'; % Color of measured values

time_start = 7;
time_stop = 17.5;

fig_size = [0 0 800 500];
title_font_size = 20;
legend_font_size = 18;
label_font_size = 18;

title_string = 'Task 10.4.6, $|\dot{\lambda}| \leq 5$';

%% Files

load(strcat(results_folder,'states_plot.mat'));
load(strcat(results_folder,'travel_plot.mat'));
load(strcat(results_folder,'u_star_elev_plot.mat'));
load(strcat(results_folder,'u_star_pitch_plot.mat'));
load(strcat(results_folder,'u_pitch_plot.mat'));
load(strcat(results_folder,'u_elev_plot.mat'));

figures_folder = strcat(results_folder, 'figures/');
mkdir(figures_folder);

%% Plotting

sampling_time = states_plot(1,2) - states_plot(1,1);

n_start = floor(time_start/sampling_time) + 1; 
n_stop = floor(time_stop/sampling_time);

% Travel plot
travel_fig = figure('Position', fig_size);
hold on
plot(travel_plot(1,n_start:n_stop), travel_plot(2,n_start:n_stop), meas_color);
ylim(travel_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle, $[Deg]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$\lambda$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

% Travel rate plot
travel_rate_fig = figure('Position', fig_size);
hold on
plot(states_plot(1,n_start:n_stop), (180/pi)*states_plot(3,n_start:n_stop), meas_color);
ylim(travel_rate_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle rate, $[\frac{Deg}{s}]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$\dot{\lambda}$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

% Pitch plot
pitch_fig = figure('Position', fig_size);
hold on
plot(u_pitch_plot(1,n_start:n_stop), (180/pi)*u_pitch_plot(2,n_start:n_stop), lqr_color);
plot(u_star_pitch_plot(1,n_start:n_stop), (180/pi)*u_star_pitch_plot(2,n_start:n_stop), opt_color);
plot(states_plot(1,n_start:n_stop), (180/pi)*states_plot(4,n_start:n_stop), meas_color);
ylim(pitch_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle, $[Deg]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$p_c$', '$p_c^*$', '$p$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

% Elevation plot
elev_fig = figure('Position', fig_size);
hold on
plot(u_elev_plot(1,n_start:n_stop), (180/pi)*u_elev_plot(2,n_start:n_stop), lqr_color);
plot(u_star_elev_plot(1,n_start:n_stop), (180/pi)*u_star_elev_plot(2,n_start:n_stop), opt_color);
plot(states_plot(1,n_start:n_stop), (180/pi)*states_plot(6,n_start:n_stop), meas_color);
ylim(elev_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle, $[Deg]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$e_c$', '$e_c^*$', '$e$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

% Elevation rate plot
elev_rate_fig = figure('Position', fig_size);
hold on
plot(states_plot(1,n_start:n_stop), (180/pi)*states_plot(7,n_start:n_stop), meas_color);
ylim(elev_rate_ylim);
xlim([time_start time_stop]);
xlabel('Time, $[s]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
ylabel('Angle rate, $[\frac{Deg}{s}]$', 'Interpreter', 'latex', 'FontSize', label_font_size);
legend('$\dot{e}$', 'Interpreter', 'latex', 'FontSize', legend_font_size);
title(title_string, 'Interpreter', 'latex', 'FontSize', title_font_size);

%% Save figures as files

travel_fig_name = strcat(figures_folder, '10_4_6_travel_', file_extension, '.eps');
travel_rate_fig_name = strcat(figures_folder, '10_4_6_travel_rate_', file_extension, '.eps');
pitch_fig_name = strcat(figures_folder, '10_4_6_pitch_', file_extension, '.eps');
elev_fig_name = strcat(figures_folder, '10_4_6_elevation_', file_extension, '.eps');
elev_rate_fig_name = strcat(figures_folder, '10_4_6_elevation_rate_', file_extension, '.eps');

saveas(travel_fig, travel_fig_name, 'epsc');
saveas(travel_rate_fig, travel_rate_fig_name, 'epsc');
saveas(pitch_fig, pitch_fig_name, 'epsc');
saveas(elev_fig, elev_fig_name, 'epsc');
saveas(elev_rate_fig, elev_rate_fig_name, 'epsc');