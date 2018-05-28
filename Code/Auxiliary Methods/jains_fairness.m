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

function fairness = jains_fairness( C )
% jains_fairness returns the Jain's fairness measure given the inputted
% array, which can be a NxM matrix
%   OUTPUT: 
%       * fairness - Jain's fairness measure from 0 to 1
%   INPUT: 
%       * C - matrix containing inputs

    numRows = size(C, 1);
    
    for i = 1 : numRows
        fairness(i) = sum(C(i,:))^2 ./ (size(C(i,:),2)*sum(C(i,:).^2));
        if isnan(fairness(i)), fairness(i) = 0; end
    end

end