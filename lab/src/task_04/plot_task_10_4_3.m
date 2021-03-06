load('u_star_pitch_plot.mat');
load('u_star_elev_plot.mat');
load('travel_plot.mat');
load('states_plot.mat');

figure;
hold on
plot(u_star_pitch_plot(1,:),u_star_pitch_plot(2,:));
xlabel('Time [s]');
ylabel('Angle [Rad]');
legend('Pitch optimal');
title('Task 10.4.3 (without feedback)');

figure;
hold on
plot(u_star_elev_plot(1,:),u_star_elev_plot(2,:));
xlabel('Time [s]');
ylabel('Angle [Rad]');
legend('Elevation optimal');
title('Task 10.4.3 (without feedback)');

figure;
hold on
plot(travel_plot(1,:),travel_plot(2,:));
xlabel('Time [s]');
ylabel('Angle [deg]');
legend('Travel angle');
title('Task 10.4.3 (without feedback)');

% figure;
% hold on
% plot(Time,pitch_ref,Time,pitch);
% xlabel('Time [s]');
% ylabel('Angle [Rad]');
% legend('Pitch reference','Pitch');
% title('Task 10.4.3 (without feedback)');
% 
% figure;
% hold on
% plot(Time,travel);
% xlabel('Time [s]');
% ylabel('Angle [rad]');
% title('Task 10.4.3 (without feedback)');