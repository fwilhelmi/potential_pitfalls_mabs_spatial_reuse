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

function [] = display_wlans_information( wlan )

    % Load the MABs constants
    load('constants_sfctmn_framework.mat')

    disp([LOG_LVL3 'WLAN ' num2str(wlan.code) ':'])
    disp([LOG_LVL4 'Primary (range): ' num2str(wlan.primary) ' (' num2str(wlan.range) ')'])
    disp([LOG_LVL4 'CCA (dBm): ' num2str(wlan.cca)])
    disp([LOG_LVL4 'Tx power (dBm): ' num2str(wlan.tx_power)])
    disp([LOG_LVL4 'Position AP / Position STA: ' num2str(wlan.position_ap) ' / ' num2str(wlan.position_sta)])
    disp([LOG_LVL4 'Upper bound: ' num2str(wlan.upper_bound)])
    disp([LOG_LVL4 'Legacy: ' num2str(wlan.legacy)])
    
end