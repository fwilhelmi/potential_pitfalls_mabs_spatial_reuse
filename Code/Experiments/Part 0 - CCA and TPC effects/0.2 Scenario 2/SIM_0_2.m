% FILE DESCRIPTION:
% Script to generate the results of simulation 0.2 (CSMA/CA Analysis)
% This script partially fills Table 1 in Section 3.3

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
disp('GENERATE RESULTS OF SIMULATION 0.2')
disp('----------------------------------------------')

% Generate constants 
constants_sfctmn_framework
constants_thompson_sampling
% Set specific configurations
configuration_system_sim_0           

% Generate wlans object according to the input file
input_file_conf_b = './Input/input_0_2_b.csv';
wlans_conf_b = generate_wlan_from_file(input_file_conf_b, false, false, 1, [], []);
[throughput_conf_b, powerRxStationFromAp_conf_b, powerRxApFromAp_conf_b, SINR_cell_conf_b] = function_main_sfctmn(wlans_conf_b);
disp('Throughput per WLAN in scenario 2 (configuration B):')
disp(throughput_conf_b)

% Generate wlans object according to the input file
input_file_conf_d = './Input/input_0_2_d.csv';
wlans_conf_d = generate_wlan_from_file(input_file_conf_d, false, false, 1, [], []);
[throughput_conf_d, powerRxStationFromAp_conf_d, powerRxApFromAp_conf_d, SINR_cell_conf_d] = function_main_sfctmn(wlans_conf_d);
disp('Throughput per WLAN in scenario 2 (configuration D):')
disp(throughput_conf_d)

% Save workspace
save('workspace_sim_0_2.mat')