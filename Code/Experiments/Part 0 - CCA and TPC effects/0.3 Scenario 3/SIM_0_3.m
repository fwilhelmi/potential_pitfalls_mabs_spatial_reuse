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
input_file_conf_a = './Input/input_0_3_a.csv';
wlans_conf_a = generate_wlan_from_file(input_file_conf_a, false, false, 1, [], []);
[throughput_conf_a, powerRxStationFromAp_conf_a, powerRxApFromAp_conf_a, SINR_cell_conf_a] = function_main_sfctmn(wlans_conf_a);
disp('Throughput per WLAN in scenario 3 (configuration A):')
disp(throughput_conf_a)

% Generate wlans object according to the input file
input_file_conf_a_e = './Input/input_0_3_a_e.csv';
wlans_conf_a_e = generate_wlan_from_file(input_file_conf_a_e, false, false, 1, [], []);
[throughput_conf_a_e, powerRxStationFromAp_conf_a_e, powerRxApFromAp_conf_a_e, SINR_cell_conf_a_e] = function_main_sfctmn(wlans_conf_a_e);
disp('Throughput per WLAN in scenario 3 (configuration A & E):')
disp(throughput_conf_a_e)

% Save workspace
save('workspace_sim_0_3.mat')