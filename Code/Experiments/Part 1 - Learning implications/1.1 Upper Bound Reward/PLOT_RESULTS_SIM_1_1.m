% FILE DESCRIPTION:
% Script to generate the results of simulation 1.1 (Upper Bound Reward)
% This script plots the results shown in Figures 5b and 5c in Section 4.2.1

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
disp('PLOT RESULTS OF SIMULATION 1.1')
disp('----------------------------------------------')

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

load('configuration_system.mat')
load('configuration_agents.mat')

load('regretEvolutionPerWlanActual.mat');
load('regretEvolutionPerWlanMCS.mat');

load('tptEvolutionPerWlanActual.mat');
load('tptEvolutionPerWlanMCS.mat');

nWlans = size(regretEvolutionPerWlanActual{1},2);
totalIterations = 100;

% Average regret evolution
for i = 1 : size(regretEvolutionPerWlanActual, 2)
    %Actual
    mean_regret_actual(i) = mean(regretEvolutionPerWlanActual{i});
    regret_per_wlan_actual(i, :) = regretEvolutionPerWlanActual{i};
    %MCS
    mean_regret_mcs(i) = mean(regretEvolutionPerWlanMCS{i});
    regret_per_wlan_mcs(i, :) = regretEvolutionPerWlanMCS{i};
end  
% Individual regret evolution
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);  
for i = 1 : nWlans
    if nWlans > 3
        subplot(nWlans/2, nWlans/2, i);
    else
        subplot(nWlans, 1, i);
    end
    for j = 1 : 2
        plot(1 : size(regretEvolutionPerWlanActual, 2), cumsum(regret_per_wlan_actual(:,i)),'blue');
        hold on
        plot(1 : size(regretEvolutionPerWlanMCS, 2), cumsum(regret_per_wlan_mcs(:,i)),'red');
    end
    hold on;
    set(gca, 'FontSize', 22)
    title(['WLAN ' num2str(i)])
    axis([0 totalIterations 0 60])
    xlabel(['TS iteration'], 'fontsize', 24)
    ylabel('Regret', 'fontsize', 24)
end
legend({'Actual', 'Approx'})
save_figure( fig, ['approx_vs_actual_regret'], './Output/' )

%% Throughput evolution experienced by each WLAN
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
num_wlans = 2;
for i = 1 : num_wlans
    if num_wlans > 3
        subplot(num_wlans/2, num_wlans/2, i);
    else
        subplot(num_wlans, 1, i);
    end
    tpt_per_iteration_actual = tptEvolutionPerWlanActual(1 : totalIterations, i);
    plot(1 : totalIterations, tpt_per_iteration_actual);
    title(['WLAN ' num2str(i)]);
    hold on
    tpt_per_iteration_mcs = tptEvolutionPerWlanMCS(1 : totalIterations, i);
    plot(1 : totalIterations, tpt_per_iteration_mcs);
    set(gca, 'FontSize', 18)
    axis([1 totalIterations 0 1.1 * max(max(tptEvolutionPerWlanActual))])
    grid on
end
legend({'Actual', 'Approx'})
% Set Axes labels
AxesH = findobj(fig, 'Type', 'Axes');       
% Y-label
YLabelHC = get(AxesH, 'YLabel');
YLabelH  = [YLabelHC{:}];
set(YLabelH, 'String', 'Throughput (Mbps)')
% X-label
XLabelHC = get(AxesH, 'XLabel');
XLabelH  = [XLabelHC{:}];
set(XLabelH, 'String', 'TS iteration') 
% Save Figure
save_figure( fig, 'approx_vs_actual_tpt', './Output/' )