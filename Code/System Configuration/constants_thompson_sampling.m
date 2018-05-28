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

% REWARDS DEFINITION

% Type of reward (shared or individual)
REWARD_INDIVIDUAL = 0;      % individual throughput
REWARD_JOINT = 1;           % joint proportional fairness
REWARD_CENTRALIZED = 2;     % joint proportional fairness

% Types of joint rewards

SHARED_REWARD_PROPORTIONAL_FAIRNESS = 1;        % reward = proportional fairness
SHARED_REWARD_MAX_MIN = 2;                      % reward = min throughput
SHARED_REWARD_INDIVIDUAL_PLUS_AGGREGATE = 3;    % reward = agg*JFI + individual
SHARED_REWARD_MAX_MIN_AND_INDIVIDUAL = 4;       % reward = min + inidividual
SHARED_REWARD_PF_AND_INDIVIDUAL = 5; 			% reward = PF + individual

% CONVERGENCE 

% Convergence types
CASE_CONVERGENCE_TYPE_1 = 1;    % Check the last X estimated rewards
CASE_CONVERGENCE_TYPE_2 = 2;    % Check the variability of the regret (individual)
CASE_CONVERGENCE_TYPE_3 = 3;    % Check the variability of the regret (collective)
CASE_CONVERGENCE_TYPE_4 = 4;    % Hybrid method of cases 2 and 3 (collective)

% TYPE OF OPTIMAL SOLUTION
OPTIMAL_SELFISH = 1;        % Selfish optimal solution (each WLAN refers to its maximum achievable throughput)
OPTIMAL_AGGREGATE = 2;      % Highest possible aggregate throughput
OPTIMAL_MAXMIN = 3;         % Highest possible max-min fairness
OPTIMAL_PF = 4;             % Highest possible proportional fairness

% CLUSTERING

CLUSTERING_BY_CHANNEL = 1;
CLUSTERING_BY_SINR = 2;

endTextOutputFile = '';

save('constants_thompson_sampling.mat');  % Save constants into current folder