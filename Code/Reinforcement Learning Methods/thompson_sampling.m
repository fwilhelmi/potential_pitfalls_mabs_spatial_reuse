%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [ tpt_experienced_per_wlan, cellTimesArmHasBeenPlayed, cellEstimatedReward, cellExperiencedRegret, rewardEvolution, convergenceTime] ...
    = thompson_sampling( wlans_input, rewardType, sharedRewardType, convergenceActivated, convergenceType, alpha, varargin )
% thompson_sampling - Given a WLAN, applies Thompson sampling to maximize the experienced throughput
%
%   OUTPUT: 
%       * tpt_experienced_per_wlan - throughput experienced by each WLAN
%         for each of the iterations done
%       * cell_times_arm_has_been_played - times each action has been played
%       * total_estimated_reward - estimated reward for each WLAN in each iteration
%       * total_experienced_regret - regret experienced by each WLAN in each iteration
%       * reward_evolution_per_wlan - evolution of the reward for each WLAN and iteration
%       * convergence_time - iteration in which the algorithm converged
%   INPUT: 
%       * wlans - object containing information about the overlapping WLANs
%       * rewardType - type of reward (individual or joint)
%       * sharedRewardType - type of shared reward (PF, JFI, max-min, hybrid max-min, hybrid PF)
%       * convergenceActivated - flag to indicate if convergence is considered or not
%       * convergenceType - type of convergence
%       * alpha - scalar from 0 to 1 for hybrid approaches
%       * varargin - extra arguments to explicitly indicate new actions
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CHECK INPUT PARAMETERS AND DETERMINE OPTIONAL ARGUMENTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              
    % Load TS constants
    load('constants_thompson_sampling.mat')
    % Load system & TS configuration
    load('configuration_system.mat')
    load('configuration_agents.mat')
    
    display_with_flag([LOG_LVL2 'Applying Thompson sampling with the following parameters:'], displayLogsTS)
    display_with_flag([LOG_LVL3 'rewardType = ' num2str(rewardType)], displayLogsTS)
    display_with_flag([LOG_LVL4 'sharedRewardType = ' num2str(sharedRewardType)], displayLogsTS)
    display_with_flag([LOG_LVL3 'convergenceActivated = ' num2str(convergenceActivated)], displayLogsTS)
    display_with_flag([LOG_LVL4 'convergenceType = ' num2str(convergenceType)], displayLogsTS)
    display_with_flag([LOG_LVL4 'alpha = ' num2str(alpha)], displayLogsTS)
    
    text = 'Applying Thompson Sampling to the introduced WLAN...';
    display_with_flag(text, displayLogsTS);
    
    % Check optional variables defining a new set of actions
    try
        if size(varargin, 2) == 3
            disp('Error 1')
        elseif size(varargin, 2) == 3
            disp('Error 2')
        elseif size(varargin, 2) == 3
            % Update possible actions
            nChannels = varargin{1};
            channelActions = 1 : nChannels;
            ccaActions = varargin{2};
            txPowerActions = varargin{3};
            % Each state represents an [i,j,k] combination for indexes on "channels", "cca" and "tx_power"
            possibleActions = 1:(size(channelActions, 2) * ...
                size(ccaActions, 2) * size(txPowerActions, 2));
            K = size(possibleActions,2);   % Total number of actions
            allCombs = allcomb(1:K, 1:K);   
        end
    catch
        if size(varargin, 2) ~= 1, error('Wrong number of input arguments'); end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% INITIALIZE VARIABLES AND DEFINE THE INITIAL CONFIGURATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    display_with_flag('Initialization...', displayLogsTS);
    
%     % REPLICATE NUMBER OF ACTIONS   
%     num_actions_repeated = 4;    
%     new_actions_set = repmat(possibleActions,1,num_actions_repeated)';
%     possibleActions = new_actions_set(:)';    
%     K = size(possibleActions,2);   % Total number of actions  
    
    nWlans = size(wlans_input, 2);

    % Determine the initial action and initialize variables
    initialAction = zeros(1, nWlans);               % Initialize arm selection for each WLAN by using the initial action
    timesArmHasBeenPlayed = zeros(nWlans, K);       % Initialize the times an arm has been played
    transitionsCounter = zeros(nWlans, K^2);        % Initialize the transitions counter per WLAN
    currentAction = zeros(1, nWlans);               % Initialize the current action selected per WLAN
    upperBoundTpt = zeros(1, nWlans);               % Initialize the array containing the upper bound of each WLAN
    estimatedRewardPerWlan = zeros(nWlans, K);      % Initialize the estimated reward per WLAN for each action
    
    % Find the index of the initial action taken by each WLAN    
    for i = 1 : nWlans
        [~,indexCca] = find(ccaActions==wlans_input(i).cca);
        [~,indexTpc] = find(txPowerActions==wlans_input(i).tx_power);
        initialAction(i) = indexes2val(wlans_input(i).primary, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
        upperBoundTpt(i) = wlans_input(i).upper_bound;
    end                  
    
    % Initialize the current selected arm to the initial action
    selectedArm = initialAction;
    % Initialize the previous action selected per WLAN
    previousAction = selectedArm;                   
    
    % Compute the throughput in each WLAN with CTMNs    
    initialThroughput = function_main_sfctmn(wlans_input);

    % Set the initial throughput experienced by each WLAN
    tpt_experienced_per_wlan(1, :) = initialThroughput;

    % Determine the reward experienced by each WLAN according to the throughput
    [rewardPerWlan, regretPerWlan] = generate_reward(wlans_input, selectedArm, ...
        initialThroughput, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha);  
    % Compute the estimated reward according to the actual reward
    estimatedRewardPerWlan = compute_estimated_reward(rewardPerWlan, ...
        estimatedRewardPerWlan, timesArmHasBeenPlayed, selectedArm);
    
    % Store the reward experienced in this iteration
    rewardEvolution(1, :) = rewardPerWlan;        
    % Variables to keep track of the estimated rewards in each WLAN
    cellEstimatedReward{1} = estimatedRewardPerWlan;
    cellExperiencedRegret{1} = regretPerWlan;
    
    % Update the times an arm has been played after drawing the initial action
    for i = 1 : nWlans, timesArmHasBeenPlayed(i, initialAction(i)) = 1; end
    cellTimesArmHasBeenPlayed{1} = timesArmHasBeenPlayed;
    
    % Initialize variables to determine convergence
    convergenceTime = totalIterations;          % Set the convergence time by default to the maximum 
    wlansThatConverged = [];                   % Initialization of the wlans that have converged
    countConvergence = zeros(1, nWlans);     % Initialization of the counter to assess convergence in TS
    
    % Initialize variables to determine the probability of acting in each iteration    
    counterIterationsWithoutActing = zeros(1, nWlans);	% Counter to assess the number of iterations that each WLAN has expended without acting
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % START THE ALGORITHM    
    text = ['Running ' num2str(totalIterations) ' iterations of Thompson sampling...'];
    display_with_flag(text, displayLogsTS);
    if displayProgressBar, h = waitbar(0,'Please wait...'); end
    
    % ITERATE UNTIL ENDING OR CONVERGENCE IS ACHIEVED    
    iteration = 2;  % iteration 1 is considered to be the initialization
    while(iteration < totalIterations + 1)         
        display_with_flag(['Iteration ' num2str(iteration)], displayLogsTS);
        % Check if all the WLANs converged
        if convergenceActivated && size(wlansThatConverged, 2) == nWlans            
            display_with_flag('ALL THE WLANS CONVERGED!', displayLogsTS);
            convergenceTime = iteration;
            % Fill remaining iterations with the last observed performance
            for i = iteration : totalIterations
                % Use the last experienced throughput
                tpt_experienced_per_wlan(i, :) = tpt_after_action;
                % Update and store the reward and the estimate for statistics
                [rewardPerWlan, regretPerWlan] = generate_reward(wlans_input, selectedArm, ...
                    tpt_after_action, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha);                 
                estimatedRewardPerWlan = compute_estimated_reward(rewardPerWlan, ...
                    estimatedRewardPerWlan, timesArmHasBeenPlayed, selectedArm);                
                rewardEvolution(i, :) = rewardPerWlan;
                cellEstimatedReward{i} = estimatedRewardPerWlan;
                cellExperiencedRegret{i} = regretPerWlan;
                % Update the times an action has been played (the same until the algorithm ends)
                for wlan_i = 1 : nWlans
                    timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) = ...
                        timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + 1;  
                end
                cellTimesArmHasBeenPlayed{i} = timesArmHasBeenPlayed;
            end            
            break; % Finish Thompson sampling execution
        end

        if displayProgressBar, waitbar(iteration / totalIterations); end
                
        previous_arm = selectedArm;
        
        order = randperm(nWlans);       % Assign turns to WLANs randomly   
        % Iterate sequentially for each agent in the random order 
        for i = 1 : nWlans 
            p = rand(1);
            if wlans_input(order(i)).legacy || ...
                sum(wlansThatConverged == order(i)) > 0 || ...
                p > probabilityOfActing
                % DO NOTHING - LEGACY WLANs DO NOT MAKE ACTIONS
                transitionsCounter(order(i), selectedArm(order(i))) = ...
                    transitionsCounter(order(i), selectedArm(order(i))) + 1;
            else
                % Select an action according to the policy
                selectedArm(order(i)) = select_action_thompson_sampling(estimatedRewardPerWlan(order(i),:), ...
                    timesArmHasBeenPlayed(order(i), :));                               
                % Update the current action
                currentAction(order(i)) = selectedArm(order(i));                
                % Find channel and tx power of the current action
                [a, b, c] = val2indexes(selectedArm(order(i)), ...
                    size(channelActions, 2), size(ccaActions, 2), size(txPowerActions, 2));
                % Update WN configuration
                wlans_input(order(i)).primary = a;  
                wlans_input(order(i)).range = [a a]; 
                wlans_input(order(i)).cca = ccaActions(b);
                wlans_input(order(i)).tx_power = txPowerActions(c);   
                % Find the index of the current and the previous action in allCombs
                ix = find(allCombs(:, 1) == previousAction(order(i)) ...
                    & allCombs(:, 2) == currentAction(order(i)));
                % Update the previous action
                previousAction(order(i)) = currentAction(order(i));  
                % Update the transitions counter
                transitionsCounter(order(i), ix) = transitionsCounter(order(i), ix) + 1;
            end            
        end
         
%         disp('---------------')
%         disp(['Iteration ' num2str(iteration)])
        % Compute the throughput in each WLAN with CTMNs
        [tpt_after_action, power_rx_sta_from_ap, ~, ~] = function_main_sfctmn(wlans_input);        
        ccaArray = zeros(1, nWlans);
        for wlan_i = 1 : nWlans
            ccaArray(wlan_i) = wlans_input(wlan_i).cca;
        end
        clusters = determine_clusters(power_rx_sta_from_ap,ccaArray);
       
        tpt_experienced_per_wlan(iteration, :) = tpt_after_action;
        
        % Make clusters according to the channel for the shared reward
        min_throughput_per_channel = zeros(1, nChannels);
        if clusteringActivated
            for ch = 1 : nChannels
                tpt = [1000];
                for wlan_i = 1 : nWlans
                    if wlans_input(wlan_i).primary == ch, tpt = [tpt tpt_after_action(wlan_i)]; end
                end
                min_throughput_per_channel(ch) = min(tpt);
            end
        end
                
        tptAfterActionAuxiliar = zeros(1, nWlans);
        upper_bound_tpt_aux = zeros(1, nWlans);
        if clusteringActivated       
            for wlan_i = 1 : nWlans      
                %disp(['Clustering WLAN ' num2str(wlan_i) ': ' num2str(clusters{wlan_i})])                
                if clusteringType == CLUSTERING_BY_CHANNEL                    
                    tptAfterActionAuxiliar(wlan_i) = min_throughput_per_channel(wlans_input(wlan_i).primary);                      
                elseif clusteringType == CLUSTERING_BY_SINR                                
                    tptAfterActionAuxiliar(wlan_i) = min(tpt_after_action(clusters{wlan_i}));    
                    upper_bound_tpt_aux(wlan_i) = min(upperBoundTpt(clusters{wlan_i}));
                end                
            end
            [rewardPerWlan, regretPerWlan] = generate_reward_with_clusters(wlans_input, selectedArm, ...
                tptAfterActionAuxiliar, upper_bound_tpt_aux, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha); 
        else            
            tptAfterActionAuxiliar = tpt_after_action; 
            [rewardPerWlan, regretPerWlan] = generate_reward(wlans_input, selectedArm, ...
                tptAfterActionAuxiliar, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha); 
        end
        
        estimatedRewardPerWlan = compute_estimated_reward(rewardPerWlan, ...
            estimatedRewardPerWlan, timesArmHasBeenPlayed, selectedArm);
        
        rewardEvolution(iteration, :) = rewardPerWlan;

        % Tune the estimated reward according to the results observed since the last time the WLAN acted
        %estimatedRewardPerWlan = reward_since_last_action(estimatedRewardPerWlan, counterIterationsWithoutActing);
          
        % Update the times WN has selected the current action
        for wlan_i = 1 : nWlans
            timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) = ...
                timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + 1;  
        end
        
        % Keep track of the reward of each WLAN in each iteration
        totalReward{iteration} = rewardPerWlan;
        % Keep track of the estimated reward of each WLAN in each iteration
        cellEstimatedReward{iteration} = estimatedRewardPerWlan;
        % Keep track of the regret experienced by each WLAN
        cellExperiencedRegret{iteration} = regretPerWlan;
        % Keep track of the times an arm has been selected by each WLAN in each iteration
        cellTimesArmHasBeenPlayed{iteration} = timesArmHasBeenPlayed;
        
        currentEstimatedRewardPerWlan = zeros(1, nWlans);
        previousEstimatedRewardPerWlan = zeros(1, nWlans);
        for wlan_i = 1 : nWlans
            currentEstimatedRewardPerWlan(wlan_i) = cellEstimatedReward{iteration}(wlan_i, selectedArm(wlan_i));
            previousEstimatedRewardPerWlan(wlan_i) = cellEstimatedReward{iteration-1}(wlan_i, previous_arm(wlan_i));
        end
        
        % Check if the algorithm has converged
        if convergenceActivated
            [wlansThatConverged, countConvergence ] = check_thompson_sampling_convergence ( ...
                convergenceType, wlansThatConverged, countConvergence, ...
                previousEstimatedRewardPerWlan, currentEstimatedRewardPerWlan, ...
                cellExperiencedRegret, iteration );                   
        end
        
        % Increase the number of 'learning iterations'
        iteration = iteration + 1; 
                
    end
           
    text = '... Done!';
    display_with_flag(text, displayLogsTS);
    
    if displayProgressBar, close(h); end
    % END OF THE ALGORITHM 
    
end