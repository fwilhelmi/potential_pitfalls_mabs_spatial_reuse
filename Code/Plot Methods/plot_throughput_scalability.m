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

% FUNCTION THAT PLOTS THE SCALABILITY RESULTS
function [] = plot_throughput_scalability(tptStaticInput, tptSelfishInput, learning_type)

    load('constants_sfctmn_framework.mat')
    load('constants_thompson_sampling.mat')
    load('configuration_system.mat')
    load('configuration_agents.mat')   

%     if saveConsoleLogsEgreedy
%         diary(['./Output/console_logs' endTextOutputFile '.txt']) % Save logs in a text file
%     end
    
    % STEP 0: Set plot properties    
    % Set font type
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');

% tptEvolutionPerWlanContainer{s}{r} contains the throughput at each iteration
% experienced by each WLAN in scenario "s" and repetition "r"

    number_of_scenarios = size(tptSelfishInput, 1);
    number_of_repetitions = size(tptSelfishInput, 2);
    
    if size(tptStaticInput{1}, 2) == 1
        for s = 1 : number_of_scenarios
            for r = 1 : number_of_repetitions
                for i = 1 : totalIterations
                    tptEvolutionStatic{s,r}(i,:) = tptStaticInput{s,r}(:,1)';
                end
            end
        end
    else
        tptEvolutionStatic = tptStaticInput;
    end
    
    % STEP 1: Compute the average throughput and std obtained in each
    % scenario and repetition
    
    % Mean of the average throughput in each iteration
    mean_average_throughput_per_scenario_static = zeros(number_of_scenarios, number_of_repetitions);
    mean_average_throughput_per_scenario_selfish = zeros(number_of_scenarios, number_of_repetitions);
    % Mean of the aggregate throughput in each iteration
    mean_aggregate_throughput_per_scenario_static = zeros(number_of_scenarios, number_of_repetitions);
    mean_aggregate_throughput_per_scenario_selfish = zeros(number_of_scenarios, number_of_repetitions);
    % Mean of the std of the throughput in each iteration (fairness)
    mean_std_throughput_per_scenario_static = zeros(number_of_scenarios, number_of_repetitions);
    mean_std_throughput_per_scenario_selfish = zeros(number_of_scenarios, number_of_repetitions);
    
    proportional_fairness_per_scenario_static = zeros(number_of_scenarios, number_of_repetitions);
    proportional_fairness_per_scenario_selfish = zeros(number_of_scenarios, number_of_repetitions);
    
    jfi_per_scenario_static = zeros(number_of_scenarios, number_of_repetitions);
    jfi_per_scenario_selfish = zeros(number_of_scenarios, number_of_repetitions);
    
    mean_pf_per_scenario_static = zeros(1, number_of_scenarios);
    std_pf_per_scenario_static = zeros(1, number_of_scenarios);
    mean_jfi_per_scenario_static = zeros(1, number_of_scenarios);
    std_jfi_per_scenario_static = zeros(1, number_of_scenarios);
        
    mean_pf_per_scenario_selfish = zeros(1, number_of_scenarios);
    std_pf_per_scenario_selfish = zeros(1, number_of_scenarios);
    mean_jfi_per_scenario_selfish = zeros(1, number_of_scenarios);
    std_jfi_per_scenario_selfish = zeros(1, number_of_scenarios);
    
    %STATIC    
    for i = 1 : number_of_scenarios
        for j = 1 : number_of_repetitions
            mean_average_throughput_per_scenario_static(i,j) = mean(mean(tptEvolutionStatic{i,j}));
            mean_aggregate_throughput_per_scenario_static(i,j) = mean(sum(tptEvolutionStatic{i,j}, 2));
            mean_std_throughput_per_scenario_static(i,j) = mean(std(tptEvolutionStatic{i,j}'));
%            proportional_fairness_per_scenario_static(i,j) = compute_proportional_fairness(tptEvolutionStatic{i,j});
            jfi_per_scenario_static(i,j) = mean(jains_fairness(tptEvolutionStatic{i,j}));
        end
    %    mean_pf_per_scenario_static(i) = mean(proportional_fairness_per_scenario_static);
    %    std_pf_per_scenario_static(i) = std(proportional_fairness_per_scenario_static);
        mean_jfi_per_scenario_static(i) = mean(jfi_per_scenario_static(i,:));
        std_jfi_per_scenario_static(i) = std(jfi_per_scenario_static(i,:));        
    end
        
    % SELFISH
    for i = 1 : number_of_scenarios
        for j = 1 : number_of_repetitions
            mean_average_throughput_per_scenario_selfish(i,j) = mean(mean(tptSelfishInput{i,j}));
            mean_aggregate_throughput_per_scenario_selfish(i,j) = mean(sum(tptSelfishInput{i,j},2));
            mean_std_throughput_per_scenario_selfish(i,j) = mean(std(tptSelfishInput{i,j}'));
            %proportional_fairness_per_scenario_selfish(i,j) = mean(compute_proportional_fairness(tptEvolutionSelfish{i,j}'));
            jfi_per_scenario_selfish(i,j) = mean(jains_fairness(tptSelfishInput{i,j}));
        end
       % mean_pf_per_scenario_selfish(i) = mean(proportional_fairness_per_scenario_selfish);
      %  std_pf_per_scenario_selfish(i) = std(proportional_fairness_per_scenario_selfish);
        mean_jfi_per_scenario_selfish(i) = mean(jfi_per_scenario_selfish(i,:));
        std_jfi_per_scenario_selfish(i) = std(jfi_per_scenario_selfish(i,:));        
    end    
    
    % STEP 2-1: Plot the mean average throughput with error obtained in each
    % scenario (make average from all the repetitions)        
    
    plot_mean_static = mean(mean_average_throughput_per_scenario_static');
    plot_std_static = std(mean_average_throughput_per_scenario_static');
    plot_mean_selfish = mean(mean_average_throughput_per_scenario_selfish');
    plot_std_selfish = std(mean_average_throughput_per_scenario_selfish'); 
    
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);    
    ctrs = 1:number_of_scenarios;
    data = [plot_mean_static(:) plot_mean_selfish(:)];
    figure(1)
    hBar = bar(ctrs, data);
    for k1 = 1 : size(data, 2)
        ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
        ydt(k1,:) = hBar(k1).YData;
    end
    hold on
    errorbar(ctr', ydt', [plot_std_static(:) plot_std_selfish(:)], '.r')     
    xlabel('Number of Nodes')
    ylabel('Mean av. throughput (Mbps)')
    legend({'Static', learning_type})
    set(gca,'FontSize', 22)
    set(gca,'xticklabel',{'2','4','6','8'})
    %axis([0 5 0 1.2*max(plot_mean_selfish)])    
    ctrs = 1:number_of_scenarios;
    data = [mean_jfi_per_scenario_static(:) mean_jfi_per_scenario_selfish(:)];   
    % Save Figure
    figName = ['scalability_mean_tpt' endTextOutputFile];
    savefig(['./Output/' figName '.fig'])
    saveas(gcf,['./Output/' figName],'epsc')
        
    % PLOT MEAN JFI     
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);    
    ctrs = 1:number_of_scenarios;
    data = [mean_jfi_per_scenario_static(:) mean_jfi_per_scenario_selfish(:)];
    %figure(1)
    hBar = bar(ctrs, data);
    for k1 = 1 : size(data, 2)
        ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
        ydt(k1,:) = hBar(k1).YData;
    end
    hold on
    errorbar(ctr', ydt', [std_jfi_per_scenario_static(:) std_jfi_per_scenario_selfish(:)], '.r')       
    xlabel('Number of Nodes')
    ylabel('JFI')
    set(gca,'FontSize', 22)
    legend({'Static', learning_type})
    set(gca,'xticklabel',{'2','4','6','8'})
    % Save Figure
    figName = ['scalability_mean_jfi' endTextOutputFile];
    savefig(['./Output/' figName '.fig'])
    saveas(gcf,['./Output/' figName],'epsc')
    hold off
    
    %% PLOT AV. TPT PER ITERATIONS

    % COMPUTE THE AV. TPT IN INTERVALS
    intervals = [100 200 300 400 500];    
    for i = 1 : number_of_scenarios        
        lastInterval = 0;
        for k = 1 : size(intervals,2)
            for j = 1 : number_of_repetitions
                mean_average_throughput_per_scenario_selfish(i,j,k) = mean(mean(tptSelfishInput{i,j}(lastInterval+1:intervals(k),:)));
                mean_aggregate_throughput_per_scenario_selfish(i,j,k) = mean(sum(tptSelfishInput{i,j}(lastInterval+1:intervals(k),:),2));
                mean_std_throughput_per_scenario_selfish(i,j,k) = mean(std(tptSelfishInput{i,j}(lastInterval+1:intervals(k),:)'));
                jfi_per_scenario_selfish(i,j,k) = mean(jains_fairness(tptSelfishInput{i,j}(lastInterval+1:intervals(k),:)));
            end
            mean_jfi_per_scenario_selfish(i,k) = mean(jfi_per_scenario_selfish(i,:));
            std_jfi_per_scenario_selfish(i,k) = std(jfi_per_scenario_selfish(i,:));         
            lastInterval = intervals(k);            
        end        
    end
        
    % PLOT
    for i = 1 : number_of_scenarios
        for k = 1 : size(intervals,2)
            plot_mean_selfish(i,k) = mean(mean_average_throughput_per_scenario_selfish(i,:,k)');
            plot_std_selfish(i,k) = std(mean_average_throughput_per_scenario_selfish(i,:,k)'); 
        end
    end
    
    % Plot 
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);   
    %symbols = ['-x','-o','-d','-.','.x'];
    for i = 1 : number_of_scenarios
        plot(1:size(intervals,2), plot_mean_selfish(i,:))
        %errorbar(plot_mean_selfish(i,:), plot_std_selfish(i,:), '.r')    
        hold on
    end
    for i = 1 : number_of_scenarios
        %plot(1:size(intervals,2), plot_mean_selfish(i,:))
        errorbar(plot_mean_selfish(i,:), plot_std_selfish(i,:),'.')    
        hold on
    end
    xlabel('Learning interval')
    ylabel('Mean av. throughput (Mbps)')    
    set(gca,'FontSize', 22)
    set(gca,'xticklabel',{'1-100','101-200','201-300','301-400','401-500'})
    legend({'2 WLANs','4 WLANs','6 WLANs','8 WLANs'})
    figName = ['scalability_cumulative_avg_tpt' endTextOutputFile];
    savefig(['./Output/' figName '.fig'])
    saveas(gcf,['./Output/' figName],'epsc')
        
    %% PLOT AVERAGE THROUGHPUT (BAR PLOT)    
    fig = figure('pos',[450 400 500 350]);
    axes;
    axis([1 20 30 70]);    
    ctrs = 1:number_of_scenarios;
    data = plot_mean_selfish;
    figure(1)
    hBar = bar(ctrs, data);
    for k1 = 1 : size(data, 2)
        ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
        ydt(k1,:) = hBar(k1).YData;
    end
    hold on
    errorbar(ctr', ydt', plot_std_selfish, '.r')      
    xlabel('Number of Nodes')
    ylabel('Mean av. throughput (Mbps)')
    legend({'1-100', '101-250', '251-500'})
    set(gca,'FontSize', 22)
    set(gca,'xticklabel',{'2','4','6','8'})
    % Save Figure
    figName = ['scalability_mean_tpt' endTextOutputFile];
    savefig(['./Output/' figName '.fig'])
    saveas(gcf,['./Output/' figName],'epsc')        