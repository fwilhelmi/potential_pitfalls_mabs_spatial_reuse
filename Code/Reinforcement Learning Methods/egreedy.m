% ***********************************************************************
% *         Potential and Pitfalls of Multi-Armed Bandits for           *
% *               Decentralized Spatial Reuse in WLANs                  *
% *                                                                     *
% * Submission to Journal on Network and Computer Applications          *
% * Authors:                                                            *
% *   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *
% *   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *
% *   - Boris Bellalta (boris.bellalta@upf.edu)                         *
% *   - Cristina Cano (ccanobs@uoc.edu)                                 *
% *   - Anders Jonsson (anders.jonsson@upf.edu)                         *
% *   - Gergely Neu (gergely.neu@upf.edu)                               *
% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *
% * Repository:                                                         *
% *  https://github.com/fwilhelmi/potential_pitfalls_mabs_spatial_reuse *
% ***********************************************************************

function [ tpt_experienced_per_wlan, cellTimesArmHasBeenPlayed, cellEstimatedReward, cellExperiencedRegret, rewardEvolution, convergenceTime] ...
    = egreedy( wlans_input, partialIterations, totalIterations, rewardType, sharedRewardType, convergenceActivated, convergenceType, alpha, varargin )
% thompson_sampling - Given a WLAN, applies e-greedy to maximize the experienced throughput
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
              
    % Load e-greedy constants
    load('constants_thompson_sampling.mat')
    % Load system & e-greedy configuration
    load('configuration_system.mat')
    load('configuration_agents.mat')
    
    display_with_flag([LOG_LVL2 'Applying e-greedy with the following parameters:'], displayLogsTS)
    display_with_flag([LOG_LVL3 'rewardType = ' num2str(rewardType)], displayLogsTS)
    display_with_flag([LOG_LVL4 'sharedRewardType = ' num2str(sharedRewardType)], displayLogsTS)
    display_with_flag([LOG_LVL3 'convergenceActivated = ' num2str(convergenceActivated)], displayLogsTS)
    
    text = 'Applying e-greedy to the introduced WLAN...';
    display_with_flag(text, displayLogsTS);
    
    % Check optional variables defining a new set of actions
    try
        if size(varargin, 2) == 1
            disp('Error 1')
        elseif size(varargin, 2) == 2
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
    
    num_wlans = size(wlans_input, 2);
    wlans_aux = wlans_input;
    
    % Determine the initial action and initialize variables
    initialAction = zeros(1, num_wlans);               % Initialize arm selection for each WLAN by using the initial action
    timesArmHasBeenPlayed = zeros(num_wlans, K);       % Initialize the times an arm has been played
    transitionsCounter = zeros(num_wlans, K^2);        % Initialize the transitions counter per WLAN
    currentAction = zeros(1, num_wlans);               % Initialize the current action selected per WLAN
    upperBoundTpt = zeros(1, num_wlans);               % Initialize the array containing the upper bound of each WLAN
    estimatedRewardPerWlan = zeros(num_wlans, K);      % Initialize the estimated reward per WLAN for each action
    
    % Find the index of the initial action taken by each WLAN    
    for i = 1 : num_wlans
        [~,indexCca] = find(ccaActions==wlans_aux(i).cca);
        [~,indexTpc] = find(txPowerActions==wlans_aux(i).tx_power);
        initialAction(i) = indexes2val(wlans_aux(i).primary, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
        upperBoundTpt(i) = wlans_aux(i).upper_bound;
    end                  
    
    % Initialize the current selected arm to the initial action
    selectedArm = initialAction;
    % Initialize the previous action selected per WLAN
    previousAction = selectedArm;         
       
    % Compute the throughput in each WLAN with CTMNs    
    initialThroughput = function_main_sfctmn(wlans_aux);

    % Set the initial throughput experienced by each WLAN
    tpt_experienced_per_wlan(1, :) = initialThroughput;

    % Determine the reward experienced by each WLAN according to the throughput
    [rewardPerWlan, regretPerWlan] = generate_reward(wlans_aux, selectedArm, ...
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
    for i = 1 : num_wlans, timesArmHasBeenPlayed(i, initialAction(i)) = 1; end    
    cellTimesArmHasBeenPlayed{1} = timesArmHasBeenPlayed;
    
    % Initialize variables to determine convergence
    convergenceTime = totalIterations;          % Set the convergence time by default to the maximum 
    wlansThatConverged = [];                   % Initialization of the wlans that have converged
    countConvergence = zeros(1, num_wlans);     % Initialization of the counter to assess convergence in e-greedy
    
    % Initialize variables to determine the probability of acting in each iteration    
    counterIterationsWithoutActing = zeros(1, num_wlans);	% Counter to assess the number of iterations that each WLAN has expended without acting
    
    % e-greedy variables
    initialEpsilon = 1;
    epsilon = initialEpsilon;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % START THE ALGORITHM    
    text = ['Running ' num2str(partialIterations) ' iterations of e-greedy...'];
    display_with_flag(text, displayLogsTS);
    if displayProgressBar, h = waitbar(0,'Please wait...'); end
    
    % ITERATE UNTIL ENDING OR CONVERGENCE IS ACHIEVED    
    iteration = 2;  % iteration 1 is considered to be the initialization
    while(iteration < partialIterations + 1)         
        display_with_flag(['Iteration ' num2str(iteration)], displayLogsTS);
        % Check if all the WLANs converged
        if convergenceActivated && size(wlansThatConverged, 2) == num_wlans            
            display_with_flag('ALL THE WLANS CONVERGED!', displayLogsTS);
            convergenceTime = iteration;
            % Fill remaining iterations with the last observed performance
            for i = iteration : partialIterations
                % Use the last experienced throughput
                tpt_experienced_per_wlan(i, :) = tpt_after_action;
                % Update and store the reward and the estimate for statistics
                [rewardPerWlan, regretPerWlan] = generate_reward(wlans_aux, selectedArm, ...
                    tpt_after_action, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha);                 
                estimatedRewardPerWlan = rewardPerWlan;                
                rewardEvolution(i, :) = rewardPerWlan;
                cellEstimatedReward{i} = estimatedRewardPerWlan;
                cellExperiencedRegret{i} = regretPerWlan;
                % Update the times an action has been played (the same until the algorithm ends)
                for wlan_i = 1 : num_wlans
                    timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) = ...
                        timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + 1;  
                end
                cellTimesArmHasBeenPlayed{i} = timesArmHasBeenPlayed;
            end            
            break; % Finish e-greedy execution
        end

        if displayProgressBar, waitbar(iteration / partialIterations); end
                
        previousArm = selectedArm;        
            
        order = randperm(num_wlans);       % Assign turns to WLANs randomly 
        
        % Iterate sequentially for each agent in the random order 
        for i = 1 : num_wlans 
            
            p = rand(1);
            
            if wlans_aux(order(i)).legacy || ...
                sum(wlansThatConverged == order(i)) > 0 || ...
                p > probabilityOfActing
                % DO NOTHING - LEGACY WLANs DO NOT MAKE ACTIONS
                transitionsCounter(order(i), selectedArm(order(i))) = ...
                    transitionsCounter(order(i), selectedArm(order(i))) + 1;
            else
                % Select an action according to the policy
                selectedArm(order(i)) = select_action_egreedy(estimatedRewardPerWlan(order(i),:), epsilon);                               
                % Update the current action
                currentAction(order(i)) = selectedArm(order(i));                
                % Find channel and tx power of the current action
                [a, b, c] = val2indexes(selectedArm(order(i)), ...
                    size(channelActions, 2), size(ccaActions, 2), size(txPowerActions, 2));
                % Update WN configuration
                wlans_aux(order(i)).primary = a;  
                wlans_aux(order(i)).range = [a a]; 
                wlans_aux(order(i)).cca = ccaActions(b);
                wlans_aux(order(i)).tx_power = txPowerActions(c);   
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
        [tpt_after_action, power_rx_sta_from_ap, ~, ~] = function_main_sfctmn(wlans_aux);        
        ccaArray = zeros(1, num_wlans);
        for wlan_i = 1 : num_wlans
            ccaArray(wlan_i) = wlans_aux(wlan_i).cca;
        end
        clusters = determine_clusters(power_rx_sta_from_ap,ccaArray);
       
        tpt_experienced_per_wlan(iteration, :) = tpt_after_action;
        
        % Make clusters according to the channel for the shared reward
        min_throughput_per_channel = zeros(1, nChannels);
        if clusteringActivated
            for ch = 1 : nChannels
                tpt = [1000];
                for wlan_i = 1 : num_wlans
                    if wlans_aux(wlan_i).primary == ch, tpt = [tpt tpt_after_action(wlan_i)]; end
                end
                min_throughput_per_channel(ch) = min(tpt);
            end
        end
                
        tptAfterActionAuxiliar = zeros(1, num_wlans);
        upper_bound_tpt_aux = zeros(1, num_wlans);
        if clusteringActivated       
            for wlan_i = 1 : num_wlans      
                %disp(['Clustering WLAN ' num2str(wlan_i) ': ' num2str(clusters{wlan_i})])                
                if clusteringType == CLUSTERING_BY_CHANNEL                    
                    tptAfterActionAuxiliar(wlan_i) = min_throughput_per_channel(wlans_aux(wlan_i).primary);                      
                elseif clusteringType == CLUSTERING_BY_SINR                                
                    tptAfterActionAuxiliar(wlan_i) = min(tpt_after_action(clusters{wlan_i}));    
                    upper_bound_tpt_aux(wlan_i) = min(upperBoundTpt(clusters{wlan_i}));
                end                
            end
            [rewardPerWlan, regretPerWlan] = generate_reward_with_clusters(wlans_aux, selectedArm, ...
                tptAfterActionAuxiliar, upper_bound_tpt_aux, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha); 
        else            
            tptAfterActionAuxiliar = tpt_after_action; 
            [rewardPerWlan, regretPerWlan] = generate_reward(wlans_aux, selectedArm, ...
                tptAfterActionAuxiliar, timesArmHasBeenPlayed, rewardType, sharedRewardType, alpha); 
        end
        
        estimatedRewardPerWlan = compute_estimated_reward(rewardPerWlan, ...
            estimatedRewardPerWlan, timesArmHasBeenPlayed, selectedArm);
        
        rewardEvolution(iteration, :) = rewardPerWlan;

        % Tune the estimated reward according to the results observed since the last time the WLAN acted
        %estimatedRewardPerWlan = reward_since_last_action(estimatedRewardPerWlan, counterIterationsWithoutActing);
          
        % Update the times WN has selected the current action
        for wlan_i = 1 : num_wlans
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
        
        currentEstimatedRewardPerWlan = zeros(1, num_wlans);
        previousEstimatedRewardPerWlan = zeros(1, num_wlans);
        for wlan_i = 1 : num_wlans
            currentEstimatedRewardPerWlan(wlan_i) = cellEstimatedReward{iteration}(wlan_i, selectedArm(wlan_i));
            previousEstimatedRewardPerWlan(wlan_i) = cellEstimatedReward{iteration-1}(wlan_i, previousArm(wlan_i));
        end
        
        % Check if the algorithm has converged
        if convergenceActivated
            [wlansThatConverged, countConvergence ] = check_thompson_sampling_convergence ( ...
                convergenceType, wlansThatConverged, countConvergence, ...
                previousEstimatedRewardPerWlan, currentEstimatedRewardPerWlan, ...
                cellExperiencedRegret, iteration );                   
        end
        
        % Update egreedy parameters
        epsilon = initialEpsilon / sqrt(iteration);  
        
        % Increase the number of 'learning iterations'
        iteration = iteration + 1; 
                
    end
           
    text = '... Done!';
    display_with_flag(text, displayLogsTS);
    
    % Save the workspace in case e-greedy with memory is used
    save('e_greedy.mat', 'iteration', 'currentAction', 'previousAction', ...
        'selectedArm', 'previousArm', 'estimatedRewardPerWlan', ...
        'timesArmHasBeenPlayed', 'transitionsCounter')     
        
    if displayProgressBar, close(h); end
    % END OF THE ALGORITHM 
    
end