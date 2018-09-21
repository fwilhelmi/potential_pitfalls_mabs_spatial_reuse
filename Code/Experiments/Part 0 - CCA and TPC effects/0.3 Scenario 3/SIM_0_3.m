% FILE DESCRIPTION:
% Script to generate the results of simulation 0.3 (CSMA/CA Analysis)
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
disp('GENERATE RESULTS OF SIMULATION 0.3')
disp('----------------------------------------------')

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