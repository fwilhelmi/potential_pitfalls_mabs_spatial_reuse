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

function [ reward_per_wlan, regret_per_wlan ] = generate_reward(wlans, action_per_wlan, ...
    throughput_per_wlan, times_arm_has_been_played, reward_type, shared_reward_type, alpha_learning)
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
    load('configuration_agents.mat')
        
    num_wlans = size(wlans, 2);                         % Number of WLANs in the map
    K = size(times_arm_has_been_played, 2);             % Number of actions per WLAN
    reward_per_configuration = zeros(num_wlans, K);     % Initialize the reward obtained for each configuration per WLAN    
    reward_per_wlan = zeros(1, num_wlans);              % Array to store all the rewards
    upper_bound_array = zeros(1, num_wlans);            % Array to store all the upper bounds
    tpt_array = [];                                     % Array containing the throughput of every non-legacy WLAN
        
    % Iterate for each WLAN
    for i = 1 : num_wlans            
        % Check the reward type (selfish or shared)
        if reward_type == REWARD_INDIVIDUAL  
            % Determine reward and regret directly (according to the experienced throughput)
            reward_per_configuration(i, action_per_wlan(i)) = ...
                throughput_per_wlan(i) / wlans(i).upper_bound;                
            regret_per_wlan(i) = min(1, max(0, 1 - throughput_per_wlan(i) / wlans(i).upper_bound));
        elseif reward_type == REWARD_JOINT
            % Build an array of throughputs for WLANs implementing TS 
            if ~wlans(i).legacy          
                tpt_array = [tpt_array throughput_per_wlan(i)];
            end                
        else
            text = 'Wrong reward type introduced. Refer to "constants_mabs.m"';
            error(text);
        end   
        % Store the upper bound of each WLAN to an array for further operations
        upper_bound_array(i) = wlans(i).upper_bound;        
    end
        
    % Iterate for each WLAN
    for i = 1 : num_wlans
        % Check if WLAN "i" is legacy and if a shared reward is being used
        if reward_type == REWARD_JOINT && ~wlans(i).legacy      
            % Check if the selected joint reward is the proportional fairness
            if shared_reward_type == SHARED_REWARD_PROPORTIONAL_FAIRNESS    
                %rewardPerConfiguration(i, actionPerWlan(i)) = max(0, compute_proportional_fairness(tptArray)); %...
            	upperBoundPF = compute_proportional_fairness(upper_bound_array);
                reward_per_configuration(i, action_per_wlan(i)) = ...
                    max(0, compute_proportional_fairness(tpt_array) / upperBoundPF);                          
            elseif shared_reward_type == SHARED_REWARD_INDIVIDUAL_PLUS_AGGREGATE      
                % Check if the selected joint reward is the sum of the individual and the aggregate throughput
                reward_per_configuration(i, action_per_wlan(i)) = ...
                    tpt_array(i)/wlans(i).upper_bound + ...     
                    sum(tpt_array)/sum(upper_bound_array) * jains_fairness(tpt_array);                   
            elseif shared_reward_type == SHARED_REWARD_MAX_MIN
               % Check if the selected joint reward is the minimum individual throughput for max-min maximization                     
               [min_throughput, ~] = min(tpt_array);              
               reward_per_configuration(i, action_per_wlan(i)) = min_throughput/min(upper_bound_array);   
            elseif shared_reward_type == SHARED_REWARD_MAX_MIN_AND_INDIVIDUAL
                % Check if the selected joint reward is the sum of the individual and the minimum individual throughput             
                [min_throughput, ~] = min(tpt_array);  
                reward_per_configuration(i, action_per_wlan(i)) = alpha_learning*min_throughput/min(upper_bound_array) + (1-alpha_learning)*tpt_array(i)/wlans(i).upper_bound;                      
            elseif shared_reward_type == SHARED_REWARD_PF_AND_INDIVIDUAL
            	PF = compute_proportional_fairness(tpt_array);  
            	upperBoundPF = compute_proportional_fairness(upper_bound_array);
                reward_per_configuration(i, action_per_wlan(i)) = alpha_learning*PF/upperBoundPF + (1-alpha_learning)*tpt_array(i)/wlans(i).upper_bound; 
            else
                % No shared reward allowed
            end     
            % Generate the regret according to the experienced reward
            regret_per_wlan(i) = min(1, max(0, 1 - reward_per_configuration(i, action_per_wlan(i))));                
        end         
        reward_per_wlan(i) = reward_per_configuration(i, action_per_wlan(i));                       
    end
end