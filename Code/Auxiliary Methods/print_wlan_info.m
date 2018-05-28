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

function [] = print_wlan_info(wlans)
% print_wlan_info prints useful information regarding a WLAN
%   INPUT: 
%       * wlans - object containing information of the overlapping WLANs

    load('constants_ctmn.mat')
    
    nWlans = length(wlans);  % Number of WLANs in the system
        
    disp('WLANs info:')

    for wlan_ix = 1 : nWlans

        disp(['  - wlan ' LABELS_DICTIONARY(wlans(wlan_ix).code) ':'])
        disp(['    * primary channel: '  num2str(wlans(wlan_ix).primary)])
        disp(['    * channel range: '  num2str(wlans(wlan_ix).range(1)) ' - ' num2str(wlans(wlan_ix).range(2))])
        disp('    * positions:')
        disp(['      * ap: ('  num2str(wlans(wlan_ix).position_ap(1)) ', ' num2str(wlans(wlan_ix).position_ap(2))...
            ', ' num2str(wlans(wlan_ix).position_ap(3)) ') m'])
        disp(['      * sta: ('  num2str(wlans(wlan_ix).position_sta(1)) ', ' num2str(wlans(wlan_ix).position_sta(2))...
            ', ' num2str(wlans(wlan_ix).position_sta(3)) ') m'])
        disp(['    * Transmission power: '  num2str(wlans(wlan_ix).tx_power) ' dBm'])
        disp(['    * CCA level: '  num2str(wlans(wlan_ix).cca) ' dBm'])
        disp(['    * lambda: '  num2str(wlans(wlan_ix).lambda) ' packets/s'])
    end
    
end