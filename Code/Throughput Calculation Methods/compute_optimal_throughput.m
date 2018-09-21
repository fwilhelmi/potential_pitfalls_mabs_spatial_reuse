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

function [ optimal_tpt_per_wlan, optimal_actions_ix ] = compute_optimal_throughput( wlans_aux, optimalType, nameWorkspace )
% Computes the optimal throughput for each WLAN according to the reward type
%
% OUTPUT:
%   * optimal_tpt_per_wlan - optimal throughput per WLAN in Mbps
% INPUT:
%   * wlans - object containing all the information of the WLANs
%   * reward_type

    load('constants_thompson_sampling.mat')
    load('configuration_agents.mat')

    throughput_per_configuration = compute_throughput_all_combinations(wlans_aux, nameWorkspace);
        
    nWlans = size(wlans_aux, 2);
    
    switch optimalType

        % Find conf. maximum individual throughput
        case OPTIMAL_SELFISH
            [val, ix] = max(throughput_per_configuration);
            optimal_tpt_per_wlan = val;
            optimal_actions_ix = ix;

        % Find conf. maximum aggregate throughput
        case OPTIMAL_AGGREGATE
            % Find max conf. AGG TPT
            [val, ix] = max(sum(throughput_per_configuration,2));
            action_ixs = possibleComb(ix,:);
            optimal_tpt_per_wlan = throughput_per_configuration(ix,:);
            optimal_actions_ix = action_ixs;
        
        % Find conf. maximum Max-min
        case OPTIMAL_MAXMIN
            % Find max conf. MAX-MIN
            min_abs = 0;
            ix = 0;
            for i = 1 : size(throughput_per_configuration,1)
                min_val = min(throughput_per_configuration(i,:));
                if min_val > min_abs
                    min_abs = min_val;
                    ix = i;
                end
            end
            val = min_abs;
            action_ixs = possibleComb(ix, :);
            optimal_tpt_per_wlan = throughput_per_configuration(ix,:);
            optimal_actions_ix = action_ixs;
        
        % Find conf. maximum PF
        case OPTIMAL_PF            
            [val, ix] = max(compute_proportional_fairness(throughput_per_configuration'));
            action_ixs = possibleComb(ix,:);
            optimal_tpt_per_wlan = throughput_per_configuration(ix,:);

        otherwise
            disp('Wrong optimal type!')

    end

    disp('+++++++++++++++++++++++++++++++++++++++++++++++')
    disp(['Best configuration (optimalType = ' num2str(optimalType) '):'])
    disp('+++++++++++++++++++++++++++++++++++++++++++++++')
    disp([' + Optimal value = ' num2str(val)])
    for w = 1 : nWlans
        if optimalType == OPTIMAL_SELFISH
             [i,j,k] = val2indexes(possibleComb(ix(w),w), size(channelActions,2), ...
                size(ccaActions,2), size(txPowerActions,2));
        else
            [i,j,k] = val2indexes(action_ixs(w), size(channelActions,2), ...
                size(ccaActions,2), size(txPowerActions,2));
        
        end
        disp(['   - WLAN ' num2str(w) ':'])
        disp(['       * ix. of channels = ' num2str(i)])
        disp(['       * CCA = ' num2str(ccaActions(j)) ' dBm'])
        disp(['       * tx power = ' num2str(txPowerActions(k)) ' dBm'])
        if optimalType == OPTIMAL_SELFISH
            disp(['       * throughput = ' num2str(throughput_per_configuration(ix(w), w)) ' Mbps']) 
        else
            disp(['       * throughput = ' num2str(throughput_per_configuration(ix, w)) ' Mbps']) 
        end
    end


end