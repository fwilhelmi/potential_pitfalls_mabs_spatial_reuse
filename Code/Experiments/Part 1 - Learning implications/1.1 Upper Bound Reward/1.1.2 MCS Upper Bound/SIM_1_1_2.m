% FILE DESCRIPTION:
% Script to generate the results of simulation 1.1.2 (Upper Bound Reward - Unknown)
% This script partially computes the results shown in Figures 5b and 5c in Section 4.2.1

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
disp('GENERATE RESULTS OF SIMULATION 1.1.2')
disp('----------------------------------------------')

% Generate constants 
constants_sfctmn_framework
constants_thompson_sampling
% Set specific configurations
configuration_system_sim_1_1
configuration_agents_sim_1_1

% Rewarding type
rewardType = REWARD_INDIVIDUAL;
sharedRewardType = 0;    
convergenceActivated = false;                               
convergenceType = 0;                 

% Generate wlans object according to the input file
input_file = './Input/input_1_1.csv';
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []);
% Compute the upper bound of each WLAN, according to the type of reward
optimalType = OPTIMAL_SELFISH;

% Modify the optimal throughput in order to assign the actual one
tx_time = SUtransmission80211ax(PACKET_LENGTH, NUM_PACKETS_AGGREGATED, ...
    CHANNEL_WIDTH_MHz, SINGLE_USER_SPATIAL_STREAMS, MODULATION_1024QAM_5_6);  

upper_bound_tpt = (1 - PACKET_ERR_PROBABILITY) * NUM_PACKETS_AGGREGATED *...
    PACKET_LENGTH * (1/tx_time) ./ 1E6;  

for w = 1 : size(wlans,2), wlans(w).upper_bound = upper_bound_tpt; end

% Display simulation's information
display_experiment_information(wlans);

% Apply Thompson sampling
[tptEvolutionPerWlan, timesArmHasBeenPlayed, estimatedRewardEvolutionPerWlan, ...
    regretEvolutionPerWlan, rewardEvolutionPerWlan, convergenceTime] ...
    = thompson_sampling(wlans, rewardType, sharedRewardType, convergenceActivated, 0, 0);

% Display results
disp([' * Mean tpt. evolution: ' num2str(mean(tptEvolutionPerWlan)) ' Mbps'])
disp([' * Mean JFI: ' num2str(mean(jains_fairness(tptEvolutionPerWlan)))])

% Plot results
plot_mabs_performance( wlans, tptEvolutionPerWlan, timesArmHasBeenPlayed, ...
    regretEvolutionPerWlan, rewardEvolutionPerWlan, rewardType, 'TS' )

% Save workspace
save('workspace_sim_1_1_2.mat')