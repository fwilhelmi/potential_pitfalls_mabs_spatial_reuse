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

function [ rewardPerWlan, regretPerWlan ] = generate_reward_with_clusters(wlans, actionPerWlan, ...
    throughputPerWlan, upper_bound_tpt, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha_learning)
% generate_reward - generates a reward according to the experienced throughput
%
%   OUTPUT: 
%       * estimatedRewardPerWlan - estimated reward for each WLAN in the last iteration
%       * timesArmHasBeenPlayed - regret experienced by each WLAN in the last iteration
%       * rewardPerWlan - array of rewards for each action
%   INPUT: 
%       * wlans - object containing information about the overlapping WLANs
%       * actionPerWlan - action selected by each WLAN
%       * throughputPerWlan - throughput achieved after choosing the current arm
%       * timesArmHasBeenPlayed - times each arm has been played so far
%       * rewardType - type of reward (individual or joint)
%       * sharedRewardType - type of shared reward (PF, JFI, max-min, hybrid max-min, hybrid PF)
%       * estimatedRewardPerWlan - estimated reward for each WLAN in the last iteration
%       * alpha_learning - scalar from 0 to 1 for hybrid approaches
    
    % Load TS constants
    load('constants_thompson_sampling.mat')
        
    nWlans = size(wlans, 2);                        % Number of WLANs in the map
    K = size(timesArmHasBeenPlayed, 2);             % Number of actions per WLAN
    rewardPerConfiguration = zeros(nWlans, K);      % Initialize the reward obtained for each configuration per WLAN
    
    rewardPerWlan = zeros(1, nWlans);

    tptArray = [];
        
    % Iterate for each WLAN
    for i = 1 : nWlans
        % Check if WLAN "i" is legacy and if a shared reward is being used
        if rewardType == REWARD_JOINT && ~wlans(i).legacy      
            % Check if the selected joint reward is the proportional fairness
            if sharedRewardType == SHARED_REWARD_PROPORTIONAL_FAIRNESS    
                %rewardPerConfiguration(i, actionPerWlan(i)) = max(0, compute_proportional_fairness(tptArray)); %...
            	upperBoundPF = compute_proportional_fairness(upper_bound_tpt);
                rewardPerConfiguration(i, actionPerWlan(i)) = ...
                    max(0, compute_proportional_fairness(tptArray) / upperBoundPF);                          
            elseif sharedRewardType == SHARED_REWARD_INDIVIDUAL_PLUS_AGGREGATE      
                % Check if the selected joint reward is the sum of the individual and the aggregate throughput
                rewardPerConfiguration(i, actionPerWlan(i)) = ...
                    tptArray(i)/upper_bound_tpt(i) + ...     
                    sum(tptArray)/sum(upper_bound_tpt) * jains_fairness(tptArray);                   
            elseif sharedRewardType == SHARED_REWARD_MAX_MIN
               % Check if the selected joint reward is the minimum individual throughput for max-min maximization                              
               rewardPerConfiguration(i, actionPerWlan(i)) = throughputPerWlan(i)/min(upper_bound_tpt);      
            elseif sharedRewardType == SHARED_REWARD_MAX_MIN_AND_INDIVIDUAL
                % Check if the selected joint reward is the sum of the individual and the minimum individual throughput             
                rewardPerConfiguration(i, actionPerWlan(i)) = alpha_learning*throughputPerWlan(i)/min(upper_bound_tpt) + (1-alpha_learning)*throughputPerWlan(i)/upper_bound_tpt(i);                      
            elseif sharedRewardType == SHARED_REWARD_PF_AND_INDIVIDUAL
            	PF = compute_proportional_fairness(tptArray);  
            	upperBoundPF = compute_proportional_fairness(upper_bound_tpt);
                rewardPerConfiguration(i, actionPerWlan(i)) = alpha_learning*PF/upperBoundPF + (1-alpha_learning)*tptArray(i)/upper_bound_tpt(i); 
            else
                % No shared reward allowed
            end     
            % Generate the regret according to the experienced reward
            regretPerWlan(i) = min(1, max(0, 1 - rewardPerConfiguration(i, actionPerWlan(i))));                
        end 
        
        rewardPerWlan(i) = rewardPerConfiguration(i, actionPerWlan(i));
                       
    end
                
end