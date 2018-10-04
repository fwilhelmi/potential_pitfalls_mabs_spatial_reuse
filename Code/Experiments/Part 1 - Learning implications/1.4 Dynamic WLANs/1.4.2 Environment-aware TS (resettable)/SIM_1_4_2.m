% FILE DESCRIPTION:
% Script to generate the results of simulation 1.4.2 (dynamic WLANs, with resettable TS)
% This script partially computes the results shown in Figure 8 in Section 4.2.3

clc
clear all

disp('***********************************************************************')
disp('*         Potential and Pitfalls of Multi-Armed Bandits for           *')
disp('*               Decentralized Spatial Reuse in WLANs                  *')
disp('*                                                                     *')
disp('* Submission to Journal on Network and Computer Applications          *')
disp('* Authors:                                                            *')
disp('*   - Francesc Wilhelmi (francisco.wilhelmi@upf.edu)                  *')
disp('*   - Sergio Barrachina-Muñoz  (sergio.barrachina@upf.edu)            *')
disp('*   - Boris Bellalta (boris.bellalta@upf.edu)                         *')
disp('*   - Cristina Cano (ccanobs@uoc.edu)                                 *')
disp('*   - Anders Jonsson (anders.jonsson@upf.edu)                         *')
disp('*   - Gergely Neu (gergely.neu@upf.edu)                               *')
disp('* Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi         *')
disp('* Repository:                                                         *')
disp('*  https://github.com/fwilhelmi/potential_pitfalls_mabs_spatial_reuse *')
disp('***********************************************************************')

disp('----------------------------------------------')
disp('GENERATE RESULTS OF SIMULATION 1.4.2')
disp('----------------------------------------------')

% Generate constants 
constants_sfctmn_framework
constants_thompson_sampling
% Set specific configurations
configuration_system_sim_1_4
configuration_agents_sim_1_4_2

% Rewarding type
rewardType = REWARD_JOINT;
sharedRewardType = SHARED_REWARD_MAX_MIN;    
convergenceActivated = false;                               
convergenceType = 0;                 

% Generate wlans object according to the input file
input_file = './Input/input_1_4.csv';
wlans = generate_wlan_from_file(input_file, false, false, 1, [], []);

initialTotalIterations = 500;
totalIterations = 1000;

% Generate the wlans structure without B
wlans_without_b = wlans;
wlans_without_b(2) = [];

%% STEP 1 - Perform the necessary iterations without B
% Compute the upper bound of each WLAN, according to the type of reward
optimalType = OPTIMAL_MAXMIN;
optimalTptPerWlanWithoutB = compute_optimal_throughput(wlans_without_b, optimalType, 'sim_1_4_3_without_b');
for w = 1 : size(wlans_without_b,2), wlans_without_b(w).upper_bound = optimalTptPerWlanWithoutB(w); end

% Display simulation's information
display_experiment_information(wlans_without_b);

% Apply Thompson sampling
[tptEvolutionPerWlan, timesArmHasBeenPlayed, estimatedRewardEvolutionPerWlan, ~, rewardEvolutionPerWlan, ~] ...
    = thompson_sampling(wlans_without_b, initialTotalIterations, totalIterations, ...
    rewardType, sharedRewardType, convergenceActivated, 0, 0);

% Display results
disp([' * Mean tpt. evolution: ' num2str(mean(tptEvolutionPerWlan)) ' Mbps'])
disp([' * Mean JFI: ' num2str(mean(jains_fairness(tptEvolutionPerWlan)))])

%% STEP 2 - Prepare data to handle a third WLAN
upperBoundTpt = compute_optimal_throughput(wlans, optimalType, 'sim_1_4_3_with_b');
for w = 1 : size(wlans,2), wlans(w).upper_bound = upperBoundTpt(w); end
% Load previously computed data
load('thompson_sampling_memory.mat');
% Fill variables to include B's operation
selectedArm = [selectedArm(1) 2 selectedArm(2)];
previousArm = [previousArm(1) 2 previousArm(2)];
previousAction = [previousAction(1) 2 previousAction(2)];
estimatedRewardPerWlan = [estimatedRewardPerWlan(1,:); zeros(1,K); estimatedRewardPerWlan(2,:)];
timesArmHasBeenPlayed = [timesArmHasBeenPlayed(1,:); zeros(1,K); timesArmHasBeenPlayed(2,:)];
transitionsCounter = [transitionsCounter(1,:); zeros(1,K^K); transitionsCounter(2,:)];
tptEvolutionPerWlan = [tptEvolutionPerWlan(:,1) zeros(initialTotalIterations,1) tptEvolutionPerWlan(:,2)];
rewardEvolutionPerWlan = [rewardEvolutionPerWlan(:,1) zeros(initialTotalIterations,1) rewardEvolutionPerWlan(:,2)];
for i = 1 : initialTotalIterations
    estimatedRewardEvolutionPerWlan{i} = [estimatedRewardEvolutionPerWlan{i}(1,:); zeros(1,K); estimatedRewardEvolutionPerWlan{i}(2,:)];
end

% Save the workspace in case TS with memory is used
save('thompson_sampling_memory.mat', 'iteration', 'currentAction', 'previousAction', ...
    'selectedArm', 'previousArm', 'estimatedRewardPerWlan', ...
    'timesArmHasBeenPlayed', 'transitionsCounter', 'upperBoundTpt', ...
    'tptEvolutionPerWlan', 'rewardEvolutionPerWlan', 'estimatedRewardEvolutionPerWlan')   

%% STEP 3 - Perform the necessary iterations with B
% Display simulation's information
display_experiment_information(wlans);

% Apply Thompson sampling
[tptEvolutionPerWlan, timesArmHasBeenPlayed, estimatedRewardEvolutionPerWlan, ...
    regretEvolutionPerWlan, rewardEvolutionPerWlan, convergenceTime] ...
    = thompson_sampling_with_memory(wlans, totalIterations, rewardType, sharedRewardType, convergenceActivated, 0, 0);

% Display results
disp(' * Mean tpt. evolution:')
mean_tpt = zeros(1, size(wlans,2));
for i = 1 : size(wlans, 2)
    if wlans(i).activation_iteration > 0
        mean_tpt(i) = mean(tptEvolutionPerWlan(initialTotalIterations:totalIterations,i));
    else
        mean_tpt(i) = mean(tptEvolutionPerWlan(:,i));
    end    
    disp(['    - WLAN ' num2str(i) ': ' num2str(mean_tpt(i)) ' Mbps'])
end
disp([' * Mean JFI: ' num2str(mean(jains_fairness(mean_tpt)))])

%% Max-min throughput experienced in each iteration
max_min_tpt_per_iteration = zeros(1, totalIterations);

% Set font type
set(0,'defaultUicontrolFontName','Times New Roman');
set(0,'defaultUitableFontName','Times New Roman');
set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultUipanelFontName','Times New Roman');
fig = figure('pos',[450 400 500 350]);
axes;
axis([1 20 30 70]);
for i = 1 : initialTotalIterations
    max_min_tpt_per_iteration(i) = min(tptEvolutionPerWlan(i,1), tptEvolutionPerWlan(i,3));
end
for i = initialTotalIterations + 1 : totalIterations
    max_min_tpt_per_iteration(i) = min(tptEvolutionPerWlan(i,:));
end
plot(1:totalIterations, max_min_tpt_per_iteration)
hold on
grid on
grid minor
h1 = plot(1 : initialTotalIterations, min(optimalTptPerWlanWithoutB) * ones(1, initialTotalIterations), 'r--', 'linewidth',2);
h2 = plot(initialTotalIterations + 1 : totalIterations, min(upperBoundTpt) * ones(1, totalIterations - initialTotalIterations), 'r--', 'linewidth',2);
legend({'Temporal throughput', 'Optimal (Max. Prop. Fairness)'});
set(gca,'FontSize', 22)
xlabel('TS iteration', 'fontsize', 24)
ylabel('Max-min Throughput (Mbps)', 'fontsize', 24)
% Save Figure
save_figure( fig, 'max_min_tpt_1_4_2', './Output/' )

%% Save workspace
save('workspace_sim_1_4_2.mat')