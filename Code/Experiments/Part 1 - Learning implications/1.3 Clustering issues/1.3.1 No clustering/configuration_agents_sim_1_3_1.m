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

% LEARNING ITERATIONS AND REPETITIONS

totalIterations = 10000;             % Maximum convergence time (one period implies the participation of all WLANs)
minimumIterationToConsider = 1;   % Iteration from which to consider the obtained results

% ACTIONS
load('configuration_system.mat') % Load allowed configuration parameters
% Each state represents an [i,j,k] combination for indexes on "channels", "cca" and "tx_power"
possibleActions = 1:(size(channelActions, 2) * size(ccaActions, 2) * size(txPowerActions, 2));
K = size(possibleActions,2);        % Total number of actions
allCombs = allcomb(1:K, 1:K);

% Structured array with all the combinations (for computing the optimal)
possibleComb = allcomb(possibleActions, possibleActions, possibleActions);
randomInitialConfiguration = false;    % Variable for assigning random channel/tx_power/cca at the beginning

% DISPLAY AND PLOT OPTIONS
plotResultsThompsonSampling = true;    % To plot or not the results at the end of the simulation
printResultsThompsonSampling = true;  % To print info after Bandits implementation (1) or not (0)
saveConsoleLogs = false;               % To save logs into a file or not
displayLogsTS = false;                  % Variable to display logs during the TS execution
drawMap = false;                       % Variable for drawing the map when generating it through "generate_wlan_from_file" or "generate_wlan_randomly"
displayProgressBar = true;

% Variables for CASE_CONVERGENCE_TYPE_1
convergenceActivated = false;
numMaxIterationsConvergence = 10;    % Number of needed iterations without changes to assess convergence        
allowedError = 0.05;                % Maximum allowed error between measurements
% Variables for CASE_CONVERGENCE_TYPE_2
epsilonRegret = 0.1;                % Maximum allowed variability for the average cumulative regret (R_T/T) 

probabilityOfActing = 1;
clusteringActivated = false;
clusteringType = 0;

save('configuration_agents.mat');  % Save system configuration into current folder