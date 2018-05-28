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

function optimalThroughputPerWlan = compute_throughput_isolation(wlans_input)
% Given an WLAN (AP+STA), compute the maximum capacity achievable according
% to the power obtained at the receiver without interference
%
% OUTPUT:
%   * optimalThroughputPerWlan - maximum achievable throughput per WLAN (Mbps)
% INPUT:
%   * wlan - object containing all the WLANs information 
%   * powerMatrix - power received from each AP
%   * noise - floor noise in dBm

    load('configuration_system.mat');
    
    nWlans = size(wlans_input, 2);
       
    % Iterate for each WLAN
    for i = 1 : nWlans
        wlans_input(i).tx_power = max(txPowerActions);
        wlans_input(i).cca = min(ccaActions);
        wlans_input(i).primary = 1;
        wlans_input(i).range = [1 1];
        % Put the other WLANs to the most favorable configuration
        for j = 1 : nWlans
            if i ~= j
               wlans_input(j).tx_power = -1000;
            end
        end
        throughputPerWlan = function_main_sfctmn(wlans_input);
        optimalThroughputPerWlan(i) = throughputPerWlan(i);
    end
    
end