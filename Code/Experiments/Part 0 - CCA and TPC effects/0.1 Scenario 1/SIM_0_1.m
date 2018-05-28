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
constants_thompson_sampling
% Set specific configurations
configuration_system_sim_0           

% Generate wlans object according to the input file
input_file_conf_a = './Input/input_0_1_a.csv';
wlans_conf_a = generate_wlan_from_file(input_file_conf_a, false, false, 1, [], []);
[throughput_conf_a, powerRxStationFromAp_conf_a, powerRxApFromAp_conf_a, SINR_cell_conf_a] = function_main_sfctmn(wlans_conf_a);
disp('Throughput per WLAN in scenario 1 (configuration A):')
disp(throughput_conf_a)

% Generate wlans object according to the input file
input_file_conf_b = './Input/input_0_1_b.csv';
wlans_conf_b = generate_wlan_from_file(input_file_conf_b, false, false, 1, [], []);
[throughput_conf_b, powerRxStationFromAp_conf_b, powerRxApFromAp_conf_b, SINR_cell_conf_b] = function_main_sfctmn(wlans_conf_b);
disp('Throughput per WLAN in scenario 1 (configuration B):')
disp(throughput_conf_b)

% Generate wlans object according to the input file
input_file_conf_c = './Input/input_0_1_c.csv';
wlans_conf_c = generate_wlan_from_file(input_file_conf_c, false, false, 1, [], []);
[throughput_conf_c, powerRxStationFromAp_conf_c, powerRxApFromAp_conf_c, SINR_cell_conf_c] = function_main_sfctmn(wlans_conf_c);
disp('Throughput per WLAN in scenario 1 (configuration C):')
disp(throughput_conf_c)

% Save workspace
save('workspace_sim_0_1.mat')