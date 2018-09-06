%%% ***********************************************************************
%%% * Selfish vs Oblivious MABs to Enhance Spatial Reuse in Dense WLANs   *
%%% * Submission to                                                       *
%%% * Authors:                                                            *
%%% *   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *
%%% *   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *
%%% *   - Boris Bellalta (boris.bellalta@upf.edu)                         *
%%% *   - Cristina Cano (ccanobs@uoc.edu)                                 *
%%% * 	- Anders Jonsson (anders.jonsson@upf.edu)                         *
%%% *   - Gergely Neu (gergely.neu@upf.edu)                               *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *
%%% * Repository:                                                         *
%%% *  bitbucket.org/wireless_networks/selfish_vs_oblivious_spatial_reuse *
%%% ***********************************************************************
clear
clc

% Generate constants 
constants_sfctmn_framework
% Set specific configurations
configuration_system_sim_test          

cca_levels = -82:1:-62;
tx_power_levels = 1:1:20;

avg_tpt_per_tpc_and_cca_value = NaN*ones(size(cca_levels, 2), size(tx_power_levels, 2));
ind_tpt_per_tpc_and_cca_value = NaN*ones(size(cca_levels, 2), size(tx_power_levels, 2));

% Generate wlans object according to the input file
input_file_conf_a = './Input/test.csv';
wlans_conf_a = generate_wlan_from_file(input_file_conf_a, false, false, 1, [], []);
for cca_ix = 1 : size(cca_levels, 2)
    for tx_power_ix = 1 : size(tx_power_levels, 2)
        
        disp('---------------------------')
        disp([' CCA = ' num2str(cca_levels(cca_ix)) ' / Tx Power = ' num2str(tx_power_levels(tx_power_ix))])        
        wlans_conf_a(1).cca = cca_levels(cca_ix);
        wlans_conf_a(1).tx_power = tx_power_levels(tx_power_ix);        
        [throughput_conf_a] = function_main_sfctmn(wlans_conf_a);
        disp(['Average throughput in scenario 1 (legacy): ' num2str(mean(throughput_conf_a))])
        disp(['Throughput WLAN A in scenario 1 (legacy): ' num2str(throughput_conf_a(1))])
        avg_tpt_per_tpc_and_cca_value(cca_ix, tx_power_ix) = mean(throughput_conf_a);
        ind_tpt_per_tpc_and_cca_value(cca_ix, tx_power_ix) = throughput_conf_a(1);      
    end
end

%% Plot results
% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');

% Plot average throughput
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
surf(avg_tpt_per_tpc_and_cca_value)
set(gca, 'FontSize', 22)
xlabel('CCA (dBm)','fontsize', 18)
ylabel('Tx Power (dBm)','fontsize', 18)
zlabel('Avg. throughput (Mbps)','fontsize', 18)
axis([0, size(cca_levels, 2), 1, size(tx_power_levels, 2), 0, 50])
xticks(1:4:size(cca_levels, 2))
xticklabels(cca_levels(1:4:size(cca_levels,2)))
hold on
%surf(average_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
% Save Figure
save_figure( fig, 'results_average_throughput_toy_scenarios_case_1_legacy', './output/' )
    
% Plot individual throughput
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
surf(ind_tpt_per_tpc_and_cca_value)
set(gca, 'FontSize', 22)
xlabel('CCA (dBm)','fontsize', 18)
ylabel('Tx Power (dBm)','fontsize', 18)
zlabel('Ind. throughput (Mbps)','fontsize', 18)
axis([0, size(cca_levels, 2), 1, size(tx_power_levels, 2), 0, 110])
xticks(1:4:size(cca_levels, 2))
xticklabels(cca_levels(1:4:size(cca_levels,2)))
hold on
%h2=surf(individual_legacy_tpt, 'FaceAlpha', 0.1, 'EdgeColor', 'r', 'LineWidth', 1.0);
grid on
grid minor
% Save Figure
save_figure( fig, 'results_individual_throughput_toy_scenarios_case_1_legacy', './output/' )

% Save workspace
save('workspace_sim_0_1.mat')