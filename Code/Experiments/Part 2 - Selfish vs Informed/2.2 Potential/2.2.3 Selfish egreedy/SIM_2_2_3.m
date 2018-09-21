% FILE DESCRIPTION:
% Script to execute experiment 2.2.3 (Potential in WLANs, Selfish approach with e-greedy)
% This script partially computes the results shown in Figures 10b and 10c in Section 5.1.2

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
disp('EXPERIMENT 2.2.3')
disp('----------------------------------------------')

% Generate constants 
constants_sfctmn_framework
constants_thompson_sampling
% Set specific configurations
configuration_system_sim_2_2
configuration_agents_sim_2_2

% Rewarding type
rewardType = REWARD_INDIVIDUAL;
sharedRewardType = 0;    
convergenceActivated = false;                               
convergenceType = 0;                 

% Generate wlans object according to the input file
input_file = './Input/input_2_2.csv';
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []);
% Compute the upper bound of each WLAN, according to the type of reward
optimalType = OPTIMAL_SELFISH;
optimalTptPerWlan = compute_optimal_throughput(wlans, optimalType, 'sim_2_2');
for w = 1 : size(wlans,2), wlans(w).upper_bound = optimalTptPerWlan(w); end

% Display simulation's information
display_experiment_information(wlans);

% Apply Thompson sampling
[tptEvolutionPerWlan, timesArmHasBeenPlayed, estimatedRewardEvolutionPerWlan, ...
    regretEvolutionPerWlan, rewardEvolutionPerWlan, convergenceTime] ...
    = egreedy(wlans, totalIterations, totalIterations, rewardType, sharedRewardType, convergenceActivated, 0, 0);

% Display results
disp([' * Mean tpt. evolution: ' num2str(mean(tptEvolutionPerWlan)) ' Mbps'])
disp([' * Mean JFI: ' num2str(mean(jains_fairness(tptEvolutionPerWlan)))])

% Plot results
plot_mabs_performance( wlans, tptEvolutionPerWlan, timesArmHasBeenPlayed, ...
    regretEvolutionPerWlan, rewardEvolutionPerWlan, rewardType, totalIterations, '\epsilon-greedy' )

% Save workspace
save('workspace_sim_2_2_3.mat')