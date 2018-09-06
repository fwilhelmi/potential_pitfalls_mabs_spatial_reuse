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
configuration_system_sim_0           

% Generate wlans object according to the input file
input_file_conf_a = './Input/test.csv';
wlans_conf_a = generate_wlan_from_file(input_file_conf_a, false, false, 1, [], []); 
[throughput_conf_a] = function_main_sfctmn(wlans_conf_a);
disp('Average Throughput in scenario 1 (legacy):')
disp(mean(throughput_conf_a))
disp('Throughput per WLAN A in scenario 1 (legacy):')
disp(throughput_conf_a(1))   

throughput_conf_a