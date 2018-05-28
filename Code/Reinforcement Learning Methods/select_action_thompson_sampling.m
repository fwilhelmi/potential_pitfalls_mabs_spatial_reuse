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

function [ arm ] = select_action_thompson_sampling( mu_hat, times_arm_has_been_played )
% select_action_ts: returns the best possible arm given the current distribution
%   OUTPUT:
%       * arm - chosen arm to be played - configuration composed by {channel, CCA, TPC}
%   INPUT:
%       - mu_hat: estimates of each arm
%       - times_arm_has_been_played: number of plays of each arm

    % STEP 1. For each arm, sample theta_i(t) independently from the normal distribution
    K = size(times_arm_has_been_played, 2);
%     times_arm_has_been_played
%     mu_hat
    for k = 1 : K
        theta(k) = normrnd(mu_hat(k), 1 / (1 + times_arm_has_been_played(k)));   
        %theta(k) = normrnd(mu_hat(k), 1 / (times_arm_has_been_played(k)*exp(1)^times_arm_has_been_played(k)));   
    end
       
%     % NORMAL-INVERSE GAMMA DISTRIBUTION
%     %  - mean was estimated from nu observations with sample mean mu_0
%     %  - variance was estimated from 2alpha observations with sample mean
%     %  mu_0 and sum of squared deviations 2Beta
%     % posterior predictive: t_2alpha(estimated_x | mu, Beta'(nu'+1)/nu'alpha')
%     ALPHA = 2;
%     BETA = 1;
%     DELTA = 1;
%     for k = 1 : K
%         %   R = NIGRND(ALPHA, BETA, MU, DELTA, M, N) returns an array of random 
%         %   numbers chosen from Normal-Inverse-Gaussian distribution with the 
%         %   parameter BETA which determines the skewness, shape parameter ALPHA, 
%         %   location parameter MU and scale parameter DELTA.
%         %   Default values for ALPHA = 1, BETA = 0; MU = 0; DELTA = 1.
%         theta(k) = nigrnd(ALPHA, BETA, mu_hat(k), DELTA, 1, 1);
%     end   
        
    % STEP 2. Play arm i(t) that maximizes theta_i(t)
    [val, ~] = max(theta);
    
    % Break ties randomly
    if sum(theta == val) > 1
        if val ~= Inf
            indexes = find(theta == val);
            arm = randsample(indexes, 1);
        else
            arm = randsample(1:size(theta, 2), 1);
        end
        
    % Select arm with maximum reward
    else
        [~, arm] = max(theta);
    end
    
end