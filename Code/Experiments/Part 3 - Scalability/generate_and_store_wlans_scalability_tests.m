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

% EXPERIMENT EXPLANATION:
%

clear all
clc
%% DEFINE THE VARIABLES TO BE USED
constants_sfctmn_framework
constants_thompson_sampling
configuration_system_sim_4
configuration_agents_sim_4

draw_map = false;
display_wlans = false;
random_initial_configuration = false;

numberOfScenarios = 50;

nWlans = [2 4 6 8];
save('constants_mabs.mat')

for n = 1 : size(nWlans, 2)    
    for i = 1 : numberOfScenarios             
        wlans_container{n, i} = generate_wlan_randomly(nWlans(n), ...
            random_initial_configuration, draw_map);
    end    
end
% Save scenarios into a variable
save('wlans_container.mat', 'wlans_container')