% FILE DESCRIPTION:
% Script to generate the results of simulation 1.3.1 (Clustering issues)
% This script partially computes the results shown in Figure 7b in Section 4.2.2

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
disp('GENERATE RESULTS OF SIMULATION 1.3.1')
disp('----------------------------------------------')

% Generate constants 
constants_sfctmn_framework
constants_thompson_sampling
% Set specific configurations
configuration_system_sim_1_3
configuration_agents_sim_1_3_1

% Rewarding type
rewardType = REWARD_JOINT;
sharedRewardType = SHARED_REWARD_MAX_MIN;    
convergenceActivated = false;                               
convergenceType = 0;                 

% Generate wlans object according to the input file
input_file = './Input/input_1_3.csv';
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []);

% Compute the upper bound of each WLAN, according to the type of reward
optimalType = OPTIMAL_MAXMIN;
optimalTptPerWlan = compute_optimal_throughput(wlans, optimalType, 'sim_1_3_1');
for w = 1 : size(wlans,2), wlans(w).upper_bound = optimalTptPerWlan(w); end

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
save('workspace_sim_1_3_1.mat')