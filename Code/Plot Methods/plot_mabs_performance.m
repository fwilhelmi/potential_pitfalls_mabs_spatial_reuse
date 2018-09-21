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

function [] = plot_mabs_performance( wlans, tptEvolutionPerWlan, timesActionHasBeenPlayed, ...
    totalExperiencedRegret, rewardEvolutionPerWlan, rewardType, totalIterations, method_name )

    load('constants_sfctmn_framework.mat')
    load('configuration_agents.mat')
    load('configuration_system.mat')   

    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');

    % Compute data to be plotted
    mean_agg_tpt = mean(sum(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :),2));
    mean_std_agg_tpt = mean(std(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)));
    mean_fairness = mean(jains_fairness(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)));
    mean_prop_fairness = mean(sum(log(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)),2));
     
    disp('-----------------------------------')
    disp('SUMMARY OF THE RESULTS')
    disp([LOG_LVL2 'Mean aggregate throughput in ' method_name ': ' num2str(mean_agg_tpt)])
    disp([LOG_LVL2 'Mean Std agg. tpt in ' method_name ': ' num2str(mean_std_agg_tpt)])
    disp([LOG_LVL2 'Mean fairness in ' method_name ': ' num2str(mean_fairness)])
    disp([LOG_LVL2 'Mean Prop. fairness in ' method_name ': ' num2str(mean_prop_fairness)])
    disp('-----------------------------------')

    %% TEMPORAL THROUGHPUT
    plot_temporal_throughput( wlans, tptEvolutionPerWlan, totalIterations, method_name );
    
    %% AVERAGE THROUGHPUT PER WLAN
    plot_average_throughput_per_wlan(wlans, tptEvolutionPerWlan, rewardType, totalIterations, method_name);
    
    %% Actions probability
    %plot_actions_probabilities( tptEvolutionPerWlan, timesActionHasBeenPlayed{totalIterations}, method_name );
    
    %% Regret 
    %plot_temporal_regret( totalExperiencedRegret, method_name );    
        
    %% Reward     
    %plot_temporal_reward( tptEvolutionPerWlan, rewardEvolutionPerWlan, method_name );
    
end