% FILE DESCRIPTION:
% Script to generate the results of simulation 1.4 (dynamic WLANs)
% This script plots the results shown in Figure 8 in Section 4.2.3

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
disp('PLOT RESULTS OF SIMULATION 1.4')
disp('----------------------------------------------')

% Generate constants 
constants_sfctmn_framework
% Set specific configurations
configuration_system_sim_test          

%% Max-min throughput experienced in each iteration
load('workspace_sim_1_4_1.mat')
max_min_tpt_per_iteration_1 = zeros(1, totalIterations);
tptEvolutionPerWlan1 = tptEvolutionPerWlan;
load('workspace_sim_1_4_2.mat')
max_min_tpt_per_iteration_2 = zeros(1, totalIterations);
tptEvolutionPerWlan2 = tptEvolutionPerWlan;
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
for i = 1 : initialTotalIterations
    max_min_tpt_per_iteration_1(i) = min(tptEvolutionPerWlan1(i,1), tptEvolutionPerWlan1(i,3));
    max_min_tpt_per_iteration_2(i) = min(tptEvolutionPerWlan2(i,1), tptEvolutionPerWlan2(i,3));
end
for i = initialTotalIterations + 1 : totalIterations
    max_min_tpt_per_iteration_1(i) = min(tptEvolutionPerWlan1(i,:));
    max_min_tpt_per_iteration_2(i) = min(tptEvolutionPerWlan2(i,:));
end
plot(1:totalIterations, max_min_tpt_per_iteration_1)
hold on
plot(1:totalIterations, max_min_tpt_per_iteration_2, 'r')
grid on
grid minor
h1 = plot(1 : initialTotalIterations, min(optimalTptPerWlanWithoutB) * ones(1, initialTotalIterations), 'k--', 'linewidth',2);
h2 = plot(initialTotalIterations + 1 : totalIterations, min(upperBoundTpt) * ones(1, totalIterations - initialTotalIterations), 'k--', 'linewidth',2);
%legend(h1, {'Optimal (Max. Prop. Fairness)'});
legend({'No restart', 'Restart', 'Optimal (Max. Prop. Fairness)'});
set(gca,'FontSize', 22)
xlabel('TS iteration', 'fontsize', 24)
ylabel('Max-min Throughput (Mbps)', 'fontsize', 24)
% Save Figure
save_figure( fig, 'max_min_tpt_1_4', './Output/' )