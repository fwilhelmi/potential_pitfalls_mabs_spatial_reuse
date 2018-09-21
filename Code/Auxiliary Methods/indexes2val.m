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

function ix = indexes2val(i,j,k,a,b)
% indexes2val provides the index ix from i, j, k (value for each variable)
%   OUTPUT: 
%       * ix - index of the (i,j,k) combination
%   INPUT: 
%       * i - index of the first element
%       * j - index of the second element
%       * k - index of the third element
%       * a - size of elements containing "i"
%       * b - size of elements containing "j"
%           (size of elements containing "k" is not necessary)

    ix = i + (j-1)*a + (k-1)*a*b;
    
end