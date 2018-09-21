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

function [] = display_results(wlans, tptEvolutionPerWlan)

    constants_ctmn
    constants_mabs
    system_conf 

    if saveConsoleLogsEgreedy
        diary(['./Output/console_logs' endTextOutputFile '.txt']) % Save logs in a text file
    end

    meanAggregateThroughput = num2str(mean(sum(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :),2)));
    meanFairness = num2str(mean(jains_fairness(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :))));
    meanProportionalFairness = num2str(mean(sum(log(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)),2)));
    
    disp(['Aggregate throughput experienced on average: ' meanAggregateThroughput ' Mbps'])
    disp(['Fairness on average: ' meanFairness])
    disp(['Proportional fairness experienced on average: ' meanProportionalFairness])

    nWlans = size(wlans, 2);

    % Throughput experienced by each WLAN for each e-greedy iteration
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);
    for i = 1 : nWlans
        subplot(nWlans/2, nWlans/2, i)
        throughputPerIteration = tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, i);
        plot(minimumIterationToConsider:totalIterations, throughputPerIteration);
        title(['WN ' num2str(i)]);
        set(gca, 'FontSize', 18)
        axis([minimumIterationToConsider totalIterations 0 1.1 * max(throughputPerIteration)])
        grid on
        grid minor
    end
    %xlabel('e-greedy Iteration', 'fontsize', 24)
    ylabel('Throughput experienced (Mbps)', 'fontsize', 24)
    % Save Figure
    figName = ['./Output/temporal_tpt_' endTextOutputFile];
    savefig(fig, figName);
    
%     fig_name = ['temporal_tpt_' end_text_output_file];
%     savefig(['./Code/Experiments/e-greedy Experiments/Results Experiment 1/' fig_name '.fig'])
%     saveas(gcf,['./Code/Experiments/e-greedy Experiments/Results Experiment 1/' fig_name],'epsc')

    % % Aggregated throughput experienced for each e-greedy iteration
    % figure('pos',[450 400 500 350])
    % axes;
    % axis([1 20 30 70]);
    % agg_tpt_per_iteration = sum(tpt_evolution_per_wlan_eg(minimumIterationToConsider:totalIterations, :), 2);
    % plot(minimumIterationToConsider:totalIterations, agg_tpt_per_iteration)
    % set(gca, 'FontSize', 22)
    % xlabel('e-greedy Iteration', 'fontsize', 24)
    % ylabel('Network Throughput (Mbps)', 'fontsize', 24)
    % axis([minimumIterationToConsider totalIterations 0 1.1 * max(agg_tpt_per_iteration)])
    % 
    % % Proportional fairness experienced for each e-greedy iteration
    % figure('pos',[450 400 500 350])
    % axes;
    % axis([1 20 30 70]);
    % proprotional_fairness_per_iteration = sum(log(tpt_evolution_per_wlan_eg(minimumIterationToConsider:totalIterations,:)), 2);
    % plot(minimumIterationToConsider:totalIterations, proprotional_fairness_per_iteration)
    % set(gca, 'FontSize', 22)
    % xlabel('e-greedy Iteration', 'fontsize', 24)
    % ylabel('Proportional Fairness', 'fontsize', 24)
    % axis([minimumIterationToConsider totalIterations 0 1.1 * max(proprotional_fairness_per_iteration)])
    % saveas(gcf,'mean_tpt_per_wlan','epsc')

    % Average tpt experienced per WLAN
    minimumIterationToConsider = totalIterations/2 + 1;
    meanThroughputPerWlan = mean(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
    meanStdPerWlan = std(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
    figure('pos',[450 400 500 350])
    axes;
    axis([1 20 30 70]);
    bar(meanThroughputPerWlan, 0.5)
    set(gca, 'FontSize', 22)
    xlabel('WN id','fontsize', 24)
    ylabel('Mean throughput (Mbps)','fontsize', 24)
    hold on
    errorbar(meanThroughputPerWlan, meanStdPerWlan, '.r');
    grid on
    grid minor
    % Save Figure
    figName = ['mean_tpt_' endTextOutputFile];
    savefig(['./Output/' figName '.fig'])
    saveas(gcf,['./Output/' figName],'epsc')
    
end