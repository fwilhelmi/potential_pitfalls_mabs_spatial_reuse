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

function [] = plot_temporal_reward( tptEvolutionPerWlan, rewardEvolutionPerWlan, method_name )

    load('constants_thompson_sampling.mat');
    load('configuration_agents.mat');
    
    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');
    
    num_wlans = size(tptEvolutionPerWlan, 2);
     
    %% Average reward per WLAN
    mean_reward_per_wlan = mean(rewardEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
    std_per_wlan = std(rewardEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    bar(mean_reward_per_wlan, 0.5)
    set(gca, 'FontSize', 22)
    xlabel('WLAN id','fontsize', 24)
    ylabel('Mean Reward','fontsize', 24)
    hold on
    axis([0 num_wlans+1 0 1.1])
    plot(0 : num_wlans+1, ones(1, num_wlans+2), 'r--', 'linewidth',2);
    grid on
    grid minor
    errorbar(mean_reward_per_wlan, std_per_wlan, '.r');
    % Save Figure
    save_figure( fig, ['mean_reward_' method_name], './Output/' )
    
    % Individual reward evolution
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    for i = 1:num_wlans
        if num_wlans == 2
            subplot(2,1,i)
        else
            subplot(num_wlans/2, num_wlans/2, i)
        end
        reward_per_iteration = rewardEvolutionPerWlan(1:totalIterations, i);
        plot(1:totalIterations, reward_per_iteration);
        title(['WLAN ' num2str(i)]);
        hold on
        plot(1 : totalIterations, ones(1, totalIterations), 'r--', 'linewidth',2);
        set(gca, 'FontSize', 18)
        axis([1 totalIterations 0 1.1])
        grid on
        %grid minor
    end
    % Set Axes labels
    AxesH = findobj(fig, 'Type', 'Axes');       
    % Y-label
    YLabelHC = get(AxesH, 'YLabel');
    YLabelH  = [YLabelHC{:}];
    set(YLabelH, 'String', 'Reward')
    % X-label
    XLabelHC = get(AxesH, 'XLabel');
    XLabelH  = [XLabelHC{:}];
    set(XLabelH, 'String', [method_name ' iteration']) 
    % Save Figure
    save_figure( fig, ['temporal_individual_reward_' method_name], './Output/' )
    
    % Average reward evolution
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    avg_reward_per_iteration = mean(rewardEvolutionPerWlan(1:totalIterations, :), 2);
    plot(1:totalIterations, avg_reward_per_iteration)
    hold on
    grid on
    grid minor
    h1 = plot(1 : totalIterations, ones(1, totalIterations), 'r--', 'linewidth',2);
    legend({'Reward', 'Optimal'});
    set(gca,'FontSize', 22)
    xlabel([method_name ' iteration'], 'fontsize', 24)
    ylabel('Reward', 'fontsize', 24)
    axis([1 totalIterations 0 1.1])
    % Save Figure
    save_figure( fig, ['average_reward_evolution' method_name], './Output/' )
    
end