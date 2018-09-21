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

function [] = plot_actions_probabilities( tptEvolutionPerWlan, timesArmHasBeenPlayed, method_name )

    load('constants_thompson_sampling.mat');
    load('configuration_agents.mat');
    
    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');
    
    num_wlans = size(tptEvolutionPerWlan, 2);
     
    %% Actions probability
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);  
    % Print the preferred action per wlan
    for i = 1 : num_wlans             
        K = size(timesArmHasBeenPlayed, 2);
        if num_wlans > 3
            subplot(num_wlans/2, num_wlans/2, i);
        else
            subplot(num_wlans, 1, i);
        end
        bar(1:K, timesArmHasBeenPlayed(i, :)/totalIterations);
        hold on
        title(['WLAN' num2str(i)])
        axis([0 K+1 0 1])
        xticks(1:K)
        xticklabels(1:K)
        set(gca, 'FontSize', 22)
    end
    % Set Axes labels
    AxesH    = findobj(fig, 'Type', 'Axes');       
    % Y-label
    YLabelHC = get(AxesH, 'YLabel');
    YLabelH  = [YLabelHC{:}];
    set(YLabelH, 'String', 'Action prob.', 'fontsize', 24)
    % X-label
    XLabelHC = get(AxesH, 'XLabel');
    XLabelH  = [XLabelHC{:}];
    set(XLabelH, 'String', 'Action index', 'fontsize', 24) 
    % Save Figure
    save_figure( fig, ['actions_probability_' method_name], './Output/' )
    
end