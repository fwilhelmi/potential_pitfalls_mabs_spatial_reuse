% FILE DESCRIPTION:
% Script for generating the Scenarios used in simulation 3

clear all
clc
%% DEFINE THE VARIABLES TO BE USED
constants_sfctmn_framework
constants_thompson_sampling
configuration_system_sim_3
configuration_agents_sim_3

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