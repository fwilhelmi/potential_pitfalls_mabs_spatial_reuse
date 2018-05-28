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

% EXPERIMENT EXPLANATION:
%

clc
clear all

disp('***********************************************************************')
disp('* Selfish vs Oblivious MABs to Enhance Spatial Reuse in Dense WLANs   *')
disp('* Submission to                                                       *')
disp('* Authors:                                                            *')
disp('*   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *')
disp('*   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *')
disp('*   - Boris Bellalta (boris.bellalta@upf.edu)                         *')
disp('*   - Anders Jonsson (anders.jonsson@upf.edu)                         *')
disp('*   - Gergely Neu (gergely.neu@upf.edu)                               *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *')
disp('* Repository:                                                         *')
disp('*  bitbucket.org/wireless_networks/selfish_vs_oblivious_spatial_reuse *')
disp('***********************************************************************')

disp('----------------------------------------------')
disp('EXPERIMENT 3-2 SCALABILITY SELFISH LEARNING')
disp('----------------------------------------------')

fprintf('Experiment started at time %s\n', datestr(now,'HH:MM:SS.FFF'))

%% DEFINE THE VARIABLES TO BE USED

% Generate constants 
constants_sfctmn_framework
constants_thompson_sampling
% Set configurations
configuration_system_sim_4
configuration_agents_sim_4_2

%% LOAD THE SCENARIO
load('wlans_container_good.mat')

% Rewarding type
rewardType = REWARD_INDIVIDUAL;             % Type of reward: selfish or cooperative
sharedRewardType = 0;                       % Null shared reward, does not apply in the selfish case
convergenceActivated = false;               % Determine convergence according to "check_ts_convergence" function
convergenceType = CASE_CONVERGENCE_TYPE_4;  % Type of convergence (avg. regret, estimated reward...)

% Initialize output variables to store TS results
% tptEvolutionPerWlan = cell(size(wlans_container, 1), size(wlans_container, 2));
% timesArmHasBeenPlayed = cell(size(wlans_container, 1), size(wlans_container, 2));
% totalMeanReward = cell(size(wlans_container, 1), size(wlans_container, 2));
% totalestimatedReward = cell(size(wlans_container, 1), size(wlans_container, 2));

%% RUN THOMPSON SAMPLING IN EACH SCENARIO
for s = 1 : size(wlans_container, 1)

    disp('+++++++++++++++++++++++++++++++')
    disp([' NUMBER OF WLANs: ' num2str(size(wlans_container{s}, 2))])    
    disp('+++++++++++++++++++++++++++++++')
    
    %upperBoundPerWlan = zeros(1, size(wlans_container{s},2));

    for r = 1 : 1%size(wlans_container, 2)

        disp([' * Scenario ' num2str(r) ' of ' num2str(size(wlans_container, 2))])
        
        [tptEvolutionPerWlan{s,r}, timesArmHasBeenPlayed{s,r}, totalestimatedReward{s,r}, ...
            regretEvolutionPerWlan{s,r}, rewardEvolutionPerWlan{s,r}, convergenceTime(s,r)] ...
            = thompson_sampling(wlans_container{s,r}, rewardType, 0, convergenceActivated, convergenceType, 0);
                
        % Safety save of the results
        tptPerWlan = tptEvolutionPerWlan{s,r};
        armsPerWlan = timesArmHasBeenPlayed{s,r};
        estimatedRewardPerWlan = totalestimatedReward{s,r};
        regretPerWlan = regretEvolutionPerWlan{s,r};
        rewardPerWlan = rewardEvolutionPerWlan{s,r};
        convTime = convergenceTime(s,r);
        
        save(['./output/workspaces_scalability_experiments/tptEvolutionPerWlan_' num2str(s) '_' num2str(r) '.mat'], 'tptPerWlan')
        save(['./output/workspaces_scalability_experiments/timesArmHasBeenPlayed_' num2str(s) '_' num2str(r) '.mat'], 'armsPerWlan')
        save(['./output/workspaces_scalability_experiments/totalEstimatedReward_' num2str(s) '_' num2str(r) '.mat'], 'estimatedRewardPerWlan')
        save(['./output/workspaces_scalability_experiments/regretPerWlan_' num2str(s) '_' num2str(r) '.mat'], 'regretPerWlan')
        save(['./output/workspaces_scalability_experiments/rewardPerWlan_' num2str(s) '_' num2str(r) '.mat'], 'rewardPerWlan')
        save(['./output/workspaces_scalability_experiments/convTime_' num2str(s) '_' num2str(r) '.mat'], 'convTime')
        
    end

end

save('./Output/workspace_experiment_3_2.mat')

fprintf('Experiment ended at time %s\n', datestr(now,'HH:MM:SS.FFF'))

if saveConsoleLogs
    diary(['./Output/EXPERIMENT_3_2_' endTextOutputFile '.txt']) % Save logs in a text file
end