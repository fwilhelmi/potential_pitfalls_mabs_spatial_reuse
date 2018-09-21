% FILE DESCRIPTION:
% Script to plot the results of experiment 2.2 (Potential in WLANs)
% This script plots article's figures 10b and 10c in Section 5.1.2

clc
clear all

disp('***********************************************************************')
disp('*         Potential and Pitfalls of Multi-Armed Bandits for           *')
disp('*               Decentralized Spatial Reuse in WLANs                  *')
disp('*                                                                     *')
disp('* Submission to Journal on Network and Computer Applications          *')
disp('* Authors:                                                            *')
disp('*   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *')
disp('*   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *')
disp('*   - Boris Bellalta (boris.bellalta@upf.edu)                         *')
disp('*   - Cristina Cano (ccanobs@uoc.edu)                                 *')
disp('*   - Anders Jonsson (anders.jonsson@upf.edu)                         *')
disp('*   - Gergely Neu (gergely.neu@upf.edu)                               *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *')
disp('* Repository:                                                         *')
disp('*  https://github.com/fwilhelmi/potential_pitfalls_mabs_spatial_reuse *')
disp('***********************************************************************')

disp('----------------------------------------------')
disp('PLOT RESULTS OF EXPERIMENT 2.2')
disp('----------------------------------------------')

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Load results from experiments in 2.2
load('results_experiment_2_2_1.mat');
load('results_experiment_2_2_2.mat');
load('results_experiment_2_2_3.mat');
load('results_experiment_2_2_4.mat');

% Determine the number of WLANs and iterations
num_wlans = size(tpt_evolution_2_2_1, 2);
total_iterations = size(tpt_evolution_2_2_1, 1);

% Average tpt experienced per WLAN
mean_tpt_per_wlan_selfish = mean(tpt_evolution_2_2_1(1:total_iterations,:), 1);
mean_tpt_per_wlan_shared = mean(tpt_evolution_2_2_2(1:total_iterations,:), 1);
mean_tpt_per_wlan_selfish_egreedy = mean(tpt_evolution_2_2_3(1:total_iterations,:), 1);
mean_tpt_per_wlan_shared_egreedy = mean(tpt_evolution_2_2_4(1:total_iterations,:), 1);
std_per_wlan_selfish = std(tpt_evolution_2_2_1(1:total_iterations,:), 1);
std_per_wlan_shared = std(tpt_evolution_2_2_2(1:total_iterations,:), 1);
std_per_wlan_selfish_egreedy = std(tpt_evolution_2_2_3(1:total_iterations,:), 1);
std_per_wlan_shared_egreedy = std(tpt_evolution_2_2_4(1:total_iterations,:), 1);

% Upper bounds
shared_upper_bound = [113.2326 113.2326 113.2326 113.2326];
selfish_upper_bound = shared_upper_bound;
max_min = 113.2326;

% Average throughput experienced per WLAN 
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);    
ctrs = 1:num_wlans;
data = [mean_tpt_per_wlan_selfish(:) mean_tpt_per_wlan_shared(:) mean_tpt_per_wlan_selfish_egreedy(:) mean_tpt_per_wlan_shared_egreedy(:)];
figure(1)
hBar = bar(ctrs, data);
for k1 = 1 : size(data, 2)
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end
hold on
errorbar(ctr', ydt', [std_per_wlan_selfish(:) std_per_wlan_shared(:) std_per_wlan_selfish_egreedy(:) std_per_wlan_shared_egreedy(:)], '.r')      
xlabel('WLAN id','fontsize', 24)
ylabel('Mean throughput (Mbps)','fontsize', 24)
set(gca,'FontSize', 22)
axis([0 num_wlans+1 0 1.2 * max(selfish_upper_bound)])
b2 = bar(1 : num_wlans, [selfish_upper_bound; shared_upper_bound; selfish_upper_bound; shared_upper_bound]', 0.5, 'LineStyle', '--', ...
     'FaceColor', 'none', 'EdgeColor', 'red', 'LineWidth', 1.5); % 
%h2 = plot(0 : num_wlans+1, mean(max_min) * ones(1, num_wlans+2), 'k--', 'linewidth',2);
legend([hBar, b2],{'Selfish (TS)', 'Env.-aware (TS)', 'Selfish (\epsilon-greedy)', ...
    'Env.-aware (\epsilon-greedy)', 'Optimal (selfish)', 'Optimal (shared)'});
% Save Figure
figName = 'experiment_2_2_mean_tpt';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')

% Throughput experienced by WLAN A
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
subplot(2,1,1)
tpt_per_iteration_thompson = mean(tpt_evolution_2_2_1(1 : total_iterations, 1), 2);
plot(1 : total_iterations, tpt_per_iteration_thompson);
hold on
xlabel('Iteration','fontsize', 24)
legend('Thompson sampling')
set(gca,'FontSize', 22)
subplot(2,1,2)
tpt_per_iteration_egreedy = mean(tpt_evolution_2_2_3(1 : total_iterations, 1), 2);
plot(1 : total_iterations, tpt_per_iteration_egreedy, 'r');
xlabel('Iteration','fontsize', 24)
ylabel('Throughput WLAN_{A} (Mbps)','fontsize', 24)
legend('\epsilon-greedy')
set(gca,'FontSize', 22)
% Save Figure
figName = 'experiment_2_2_variability';
savefig(['./Output/' figName '.fig'])
saveas(gcf,['./Output/' figName],'png')