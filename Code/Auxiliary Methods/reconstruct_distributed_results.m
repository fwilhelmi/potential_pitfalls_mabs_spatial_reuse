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

% EXPERIMENT EXPLANATION:
%

initialScenario = 1;
lastScenario = 2;
initialRepetition = 1;
lastRepetition = 50;

for s = initialScenario : lastScenario
    for r = initialRepetition : lastRepetition
        load(sprintf('timesArmHasBeenPlayed_%d_%d.mat', s, r));
        armPerWlanEvolution{s,r} = armsPerWlan;
        
        load(sprintf('totalEstimatedReward_%d_%d.mat', s, r));
        estimatedRewardEvolution{s,r} = estimatedRewardPerWlan;
        
        load(sprintf('tptEvolutionPerWlan_%d_%d.mat', s, r));
        tptEvolution{s,r} = tptPerWlan;
    end
end