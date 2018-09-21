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

function [ estimatedRewardPerWlan ] = compute_estimated_reward( rewardPerWlan, estimatedRewardPerWlan, timesArmHasBeenPlayed, selectedAction )
%COMPUTE_ESTIMATED_REWARD 
%   Detailed explanation goes here

    nWlans = size(estimatedRewardPerWlan, 1);
       
    for i = 1 : nWlans       
        estimatedRewardPerWlan(i, selectedAction(i)) = ((estimatedRewardPerWlan(i, selectedAction(i)) ...
            * timesArmHasBeenPlayed(i, selectedAction(i))) ...
            + rewardPerWlan(i)) / (timesArmHasBeenPlayed(i, selectedAction(i)) + 2);
    end

end