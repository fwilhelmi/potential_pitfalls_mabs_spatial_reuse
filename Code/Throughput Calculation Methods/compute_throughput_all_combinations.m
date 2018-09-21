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

function [ throughput_per_configuration ] = compute_throughput_all_combinations( wlans_aux, nameWorkspace )
% Computes the throughput experienced by each WLAN for all the possible
% combinations of Channels, CCA and TPC 
%
%   NOTE: the "allcomb" function does not hold big amounts of combinations 
%   (a reasonable limit is 4 WLANs with 2 channels and 4 levels of TPC)
%
% OUTPUT:
%   * throughputPerConfiguration - tpt achieved by each WLAN for each configuration (Mbps)
% INPUT:
%   * wlans - object containing all the WLANs information 

    % Load TS constants
    load('constants_sfctmn_framework.mat')
    load('constants_thompson_sampling.mat')
    % Load system & TS configuration
    load('configuration_system.mat')
    load('configuration_agents.mat')
    
    disp([LOG_LVL2 'Computing the throughput for all the combinations...'])
    disp([LOG_LVL3 'Channel actions: ' num2str(channelActions)])
    disp([LOG_LVL3 'CCA actions: ' num2str(ccaActions)])
    disp([LOG_LVL3 'Tx power actions: ' num2str(txPowerActions)])

    % Generate a copy of the WLAN object to make modifications
    wlansAux = wlans_aux;    
    nWlans = size(wlansAux, 2);  
        
    log_k = round(size(possibleComb, 1)/10);
    throughput_per_configuration = zeros(size(possibleComb, 1), nWlans);
    
    % Try all the combinations
    for i = 1 : size(possibleComb, 1)
        
        if mod(i, log_k) == 0
             disp([LOG_LVL4 'Progress: ' num2str(round(i*100/size(possibleComb, 1))) ' %'])
        end
        
        % Change WLANs configuration 
        for j = 1 : nWlans 
            [ch, cca_ix, tpc_ix] = val2indexes(possibleComb(i,j), ...
                nChannels, size(ccaActions, 2), size(txPowerActions, 2));
            wlansAux(j).primary = ch;
            wlansAux(j).range = [ch ch];
            % CHANNEL BONDING CASE
%             [ch, cca_ix, tpc_ix] = val2indexes(possibleComb(i,j), ...
%                 size(channelActions, 2), size(ccaActions, 2), size(txPowerActions, 2));
%             [left_ch, right_ch] = channel_index_to_range(ch);
%             wlansAux(j).primary = left_ch;  
%             wlansAux(j).range = [left_ch right_ch]; 
            wlansAux(j).cca = ccaActions(cca_ix);
            wlansAux(j).tx_power = txPowerActions(tpc_ix);       
        end

        % Compute the Throughput and store it
        throughput_per_configuration(i,:) = function_main_sfctmn(wlansAux)';

    end  

    save(['throughput_per_configuration_' nameWorkspace], 'throughput_per_configuration')
    
end