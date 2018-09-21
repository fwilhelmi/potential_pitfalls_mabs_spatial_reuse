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

function [] = plot_temporal_regret( totalExperiencedRegret, method_name )

    load('constants_thompson_sampling.mat');
    load('configuration_agents.mat');
    
    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');
    
    num_wlans = size(totalExperiencedRegret{1}, 2);
     
    %% Average regret evolution
    for i = 1 : size(totalExperiencedRegret, 2)
        mean_regret(i) = mean(totalExperiencedRegret{i});
        regret_per_wlan(i, :) = totalExperiencedRegret{i};
        %std_regret(i) = std(totalExperiencedRegret{i});
    end   
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);  
    plot(1 : size(totalExperiencedRegret, 2), cumsum(mean_regret));
    set(gca, 'FontSize', 22)
    xlabel([method_name ' iteration'], 'fontsize', 24)
    ylabel('Cumulative average regret', 'fontsize', 24)
    % Save Figure
    save_figure( fig, ['cumulative_regret_evolution_' method_name], './Output/' )
    
    %% Individual regret evolution
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);  
    for i = 1 : num_wlans
        if num_wlans > 3
            subplot(num_wlans/2, num_wlans/2, i);
        else
            subplot(num_wlans, 1, i);
        end
        plot(1 : size(totalExperiencedRegret, 2), cumsum(regret_per_wlan(:,i)));
        hold on;
        set(gca, 'FontSize', 22)
        title(['WLAN ' num2str(i)])
        xlabel([method_name ' iteration'], 'fontsize', 24)
        ylabel('Regret', 'fontsize', 24)
    end
    % Save Figure
    save_figure( fig, ['individual_regret_evolution_' method_name], './Output/' )
    
end