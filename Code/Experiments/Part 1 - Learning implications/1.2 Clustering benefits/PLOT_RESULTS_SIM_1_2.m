% FILE DESCRIPTION:
% Script to generate the results of simulation 1.2 (clustering benefits)
% This script plots the results shown in Figure 6b in Section 4.2.2

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
disp('PLOT RESULTS OF SIMULATION 1.2')
disp('----------------------------------------------')

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

load('tptEvolutionNoClustering.mat');
load('tptEvolutionClusteringBySinr.mat');

nWlans = size(tptEvolutionNoClustering,2);
totalIterations = 100;%size(tptEvolutionNoClustering,1);

%% Throughput evolution experienced by each WLAN
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
for i = 1 : nWlans
    if nWlans > 3
        subplot(nWlans/2, nWlans/2, i);
    else
        subplot(nWlans, 1, i);
    end
    tpt_per_iteration_no_clustering = tptEvolutionNoClustering(1 : totalIterations, i);
    tpt_per_iteration_clustering_by_sinr = tptEvolutionClusteringBySinr(1 : totalIterations, i);
    plot(1 : totalIterations, tpt_per_iteration_no_clustering);
    title(['WLAN ' num2str(i)]);
    hold on
    plot(1 : totalIterations, tpt_per_iteration_clustering_by_sinr);
    set(gca, 'FontSize', 18)
    %axis([1 totalIterations 0 1.1 * max(max(max(tptEvolutionNoClustering)), max(upperBoundTpt))])
    grid on
    %grid minor
end
legend({'No clustering', 'Clustering'})
% Set Axes labels
AxesH = findobj(fig, 'Type', 'Axes');       
% Y-label
YLabelHC = get(AxesH, 'YLabel');
YLabelH  = [YLabelHC{:}];
set(YLabelH, 'String', 'Throughput (Mbps)')
% X-label
XLabelHC = get(AxesH, 'XLabel');
XLabelH  = [XLabelHC{:}];
set(XLabelH, 'String', ['TS iteration']) 
% Save Figure
save_figure( fig, ['clustering_benefits'], './Output/' )