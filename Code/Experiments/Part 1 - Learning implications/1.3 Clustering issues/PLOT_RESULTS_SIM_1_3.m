% FILE DESCRIPTION:
% Script to generate the results of simulation 1.3 (clustering issues)
% This script plots the results shown in Figure 7b in Section 4.2.2

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
disp('PLOT RESULTS OF SIMULATION 1.3')
disp('----------------------------------------------')

load('tptNoClustering.mat');
load('tptClustering.mat');

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

nWlans = size(tptNoClustering,2);
totalIterations = size(tptNoClustering,1);

% Average tpt experienced per WLAN
mean_tpt_per_wlan_clustering = mean(tptClustering(1:totalIterations,:),1);
mean_tpt_per_wlan_no_clustering = mean(tptNoClustering(1:totalIterations,:),1);
std_per_wlan_clustering = std(tptClustering(1:totalIterations,:),1);
std_per_wlan_no_clustering = std(tptNoClustering(1:totalIterations,:),1);

maxmin = 20.547;

fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
data = [mean_tpt_per_wlan_clustering; mean_tpt_per_wlan_no_clustering]';
hBar = bar(1:nWlans, data, 0.5, 'FaceColor','flat');
for k1 = 1:size(data,2)
ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
ydt(k1,:) = hBar(k1).YData;
end
hold on
std_error = [std_per_wlan_clustering; std_per_wlan_no_clustering];
errorbar(ctr, ydt, std_error, '.r') 
hBar(1).CData = 1;
hBar(2).CData = 2;
set(gca, 'FontSize', 22)
xlabel('WLAN id','fontsize', 24)
ylabel('Mean throughput (Mbps)','fontsize', 24)
hold on
axis([0 nWlans+1 0 1.2 * max(max(max(tptClustering)), max(max(std_per_wlan_no_clustering)))])
opt = plot(0 : nWlans+1, mean(maxmin) * ones(1, nWlans+2), 'k--', 'linewidth',2);
grid on
grid minor
legend([hBar opt],{'Clustering', 'No clustering', 'Optimal (max-min)'});
% Save Figure
save_figure( fig, 'mean_tpt_TS', './Output/' )