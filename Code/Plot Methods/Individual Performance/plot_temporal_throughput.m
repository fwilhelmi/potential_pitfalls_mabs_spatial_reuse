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

function [] = plot_temporal_throughput( wlans_aux, tptEvolutionPerWlan, totalIterations, method_name )

    load('constants_thompson_sampling.mat');
    load('configuration_agents.mat');
    
    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');
    
    num_wlans = size(tptEvolutionPerWlan, 2);
    upper_bound_tpt = zeros(1, num_wlans);
    for i = 1 : num_wlans, upper_bound_tpt(i) = wlans_aux(i).upper_bound; end
    
    %% Average throughput experienced in each iteration
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    avg_tpt_per_iteration = mean(tptEvolutionPerWlan(1:totalIterations, :), 2);
    plot(1:totalIterations, avg_tpt_per_iteration)
    hold on
    grid on
    grid minor
    h1 = plot(1 : totalIterations, max(upper_bound_tpt) * ones(1, totalIterations), 'r--', 'linewidth',2);
    %legend(h1, {'Optimal (Max. Prop. Fairness)'});
    legend({'Temporal throughput', 'Optimal (Max. Prop. Fairness)'});
    set(gca,'FontSize', 22)
    xlabel([method_name ' iteration'], 'fontsize', 24)
    ylabel('Average Throughput (Mbps)', 'fontsize', 24)
    axis([1 totalIterations 0 1.1 * max(upper_bound_tpt)])
    % Save Figure
    save_figure( fig, ['temporal_average_tpt_' method_name], './Output/' )
         
    %% Aggregate throughput experienced in each iteration
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    agg_tpt_per_iteration = sum(tptEvolutionPerWlan(1:totalIterations, :), 2);
    plot(1:totalIterations, agg_tpt_per_iteration)
    hold on
    grid on
    grid minor
    h1 = plot(1 : totalIterations, sum(upper_bound_tpt) * ones(1, totalIterations), 'r--', 'linewidth',2);
    %legend(h1, {'Optimal (Max. Prop. Fairness)'});
    legend({'Temporal throughput', 'Optimal (Max. Prop. Fairness)'});
    set(gca,'FontSize', 22)
    xlabel([method_name ' iteration'], 'fontsize', 24)
    ylabel('Network Throughput (Mbps)', 'fontsize', 24)
    axis([1 totalIterations 0 1.5 * sum(upper_bound_tpt)])
    % Save Figure
    save_figure( fig, ['temporal_aggregate_tpt_' method_name], './Output/' )
    
    %% Throughput evolution experienced by each WLAN
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    for i = 1 : num_wlans
        if num_wlans > 3
            subplot(num_wlans/2, num_wlans/2, i);
        else
            subplot(num_wlans, 1, i);
        end
        tpt_per_iteration = tptEvolutionPerWlan(1 : totalIterations, i);
        plot(1 : totalIterations, tpt_per_iteration);
        title(['WLAN ' num2str(i)]);
        hold on
        plot(1 : totalIterations, upper_bound_tpt(i) ...
            * ones(1, totalIterations), 'r--', 'linewidth',2);
        set(gca, 'FontSize', 18)
        axis([1 totalIterations 0 1.1 * max(max(max(tptEvolutionPerWlan)), max(upper_bound_tpt))])
        grid on
        %grid minor
    end
    % Set Axes labels
    AxesH = findobj(fig, 'Type', 'Axes');       
    % Y-label
    YLabelHC = get(AxesH, 'YLabel');
    YLabelH  = [YLabelHC{:}];
    set(YLabelH, 'String', 'Throughput (Mbps)')
    % X-label
    XLabelHC = get(AxesH, 'XLabel');
    XLabelH  = [XLabelHC{:}];
    set(XLabelH, 'String', [method_name ' iteration']) 
    % Save Figure
    save_figure( fig, ['temporal_individual_tpt_' method_name], './Output/' )
    
end