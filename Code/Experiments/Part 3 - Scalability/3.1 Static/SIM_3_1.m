% FILE DESCRIPTION:
% Script to execute experiment 3.1 (scalability performance, Static)
% This script partially computes the results shown in Figures 12 and 13 in Section 5.2

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
disp('EXPERIMENT 3.1')
disp('----------------------------------------------')

fprintf('Experiment started at time %s\n', datestr(now,'HH:MM:SS.FFF'))

%% DEFINE THE VARIABLES TO BE USED

% Generate constants 
constants_sfctmn_framework
constants_thompson_sampling
% Set configurations
configuration_system
configuration_agents

%% LOAD THE SCENARIO
load('wlans_container.mat')

% Rewarding type
rewardType = REWARD_INDIVIDUAL;             % Type of reward: selfish or cooperative
sharedRewardType = 0;                       % Null shared reward, does not apply in the selfish case
convergenceActivated = false;               % Determine convergence according to "check_ts_convergence" function
convergenceType = CASE_CONVERGENCE_TYPE_1;  % Type of convergence (avg. regret, estimated reward...)

%% RUN THOMPSON SAMPLING IN EACH SCENARIO
for s = 1 : size(wlans_container, 1)

    disp('+++++++++++++++++++++++++++++++')
    disp([' NUMBER OF WLANs: ' num2str(size(wlans_container{s}, 2))])    
    disp('+++++++++++++++++++++++++++++++')

    for r = 1 : size(wlans_container, 2)

        disp([' * Scenario ' num2str(r) ' of ' num2str(size(wlans_container, 2))])        
        tptEvolutionPerWlan{s,r} = function_main_sfctmn(wlans_container{s,r});                
        % Safety save of the results
        tptPerWlan = tptEvolutionPerWlan{s,r};

    end

end

save('./Output/workspace_experiment_3_1_scalability_static.mat')

fprintf('Experiment ended at time %s\n', datestr(now,'HH:MM:SS.FFF'))

if saveConsoleLogs
    diary(['./Output/EXPERIMENT_3_1_' endTextOutputFile '.txt']) % Save logs in a text file
end