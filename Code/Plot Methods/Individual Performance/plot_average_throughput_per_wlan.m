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

function [] = plot_average_throughput_per_wlan( wlans_aux, tpt_evolution_per_wlan, reward_type, totalIterations, method_name )

    load('constants_thompson_sampling.mat');
    load('configuration_agents.mat');
    
    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');
    
    num_wlans = size(tpt_evolution_per_wlan, 2);
    mean_tpt_per_wlan = zeros(1, num_wlans);
    upper_bound_tpt = zeros(1, num_wlans);
    for i = 1 : num_wlans
        upper_bound_tpt(i) = wlans_aux(i).upper_bound; 
        min_iteration = max(minimumIterationToConsider, wlans_aux(i).activation_iteration);
        mean_tpt_per_wlan(i) = mean(tpt_evolution_per_wlan(min_iteration:totalIterations, i), 1);     
        std_per_wlan(i) = std(tpt_evolution_per_wlan(min_iteration:totalIterations, i), 1);
    end
        
    %% Average tpt experienced per WLAN
      
    %mean_tpt_per_wlan = mean(tpt_evolution_per_wlan(minimumIterationToConsider:totalIterations,:), 1);
    %std_per_wlan = std(tpt_evolution_per_wlan(minimumIterationToConsider:totalIterations,:), 1);
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    %data = [mean_tpt_per_wlan; upperBoundTpt]';
    b1 = bar(1 : num_wlans, mean_tpt_per_wlan, 0.5);
    hold on    
    errorbar(mean_tpt_per_wlan, std_per_wlan, '.r')     
    b2 = bar(1 : num_wlans, upper_bound_tpt, 0.5, 'LineStyle', '--', ...
        'FaceColor', 'none', 'EdgeColor', 'red', 'LineWidth', 1.5); 
    if reward_type == REWARD_JOINT
        l1 = plot(0 : num_wlans+1, min(upper_bound_tpt) * ones(1, num_wlans+2), 'k--', 'linewidth', 2); 
    end
    set(gca, 'FontSize', 22)
    xlabel('WLAN id','fontsize', 24)
    ylabel('Mean throughput (Mbps)','fontsize', 24)
    hold on
    axis([0 num_wlans + 1 0 1.2 * max(max(max(tpt_evolution_per_wlan)), max(upper_bound_tpt))])
    grid on
    grid minor
    if reward_type == REWARD_JOINT
        legend([b1 b2 l1],{'Thompson s.','Optimal', 'Shared goal'});
    else
        legend([b1 b2],{'Thompson s.','Optimal'});
    end
    % Save Figure
    save_figure( fig, ['mean_tpt_' method_name], './Output/' )
    
end