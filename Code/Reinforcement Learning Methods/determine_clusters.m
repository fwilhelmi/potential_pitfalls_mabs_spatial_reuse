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

function [clusters] = determine_clusters(powerRxStaFromAp, ccaArray)
%DETERMINE_CLUSTERS Summary of this function goes here
%   Detailed explanation goes here

    nWlans = size(powerRxStaFromAp, 2);
        
    for i = 1 : nWlans
        nodes_affecting = [i];
        for j = 1 : nWlans
            if i ~= j && powerRxStaFromAp(i,j) > ccaArray(i)
                nodes_affecting = [nodes_affecting j];
            end
        end  
        list_of_affecting_nodes{i} = nodes_affecting;        
    end
    
    for i = 1 : nWlans
        
        for j = 1 : size(list_of_affecting_nodes{i}, 2)

                elem = list_of_affecting_nodes{i}(j);
                
                if elem ~= i
                    if sum(list_of_affecting_nodes{elem} == i) == 0
                        list_of_affecting_nodes{elem} = [list_of_affecting_nodes{elem} i];
                    end
                end
            
        end
        
    end    
    
    clusters = list_of_affecting_nodes;

end

