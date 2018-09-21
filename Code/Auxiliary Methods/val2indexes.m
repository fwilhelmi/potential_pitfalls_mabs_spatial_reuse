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

function [i,j,k] = val2indexes(ix, a, b, c)
% val2indexes provides the indexes i,j,k from index ix
%   OUTPUT: 
%       * i - index of the first element
%       * j - index of the second element
%       * k - index of the third element
%   INPUT: 
%       * ix - index of the (i,j,k) combination
%       * a - size of elements containing "i"
%       * b - size of elements containing "j"
%       * c - size of elements containing "k"

    i = mod(ix, a); 
    if i == 0, i = a; end    
    y = mod(ix, (a * b));
    j = ceil(y/a);
    if j == 0, j = b; end 
    k = ceil(ix / (a * b)); 
    if k > c, k = c; end
    
end