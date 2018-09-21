%%% *********************************************************************
%%% * Spatial-Flexible CTMN for WLANs                                   *
%%% * Author: Sergio Barrachina-Munoz (sergio.barrachina@upf.edu)       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Sergio Barrachina-Munoz *
%%% * GitHub repository: https://github.com/sergiobarra/SFCTMN          *
%%% * More info on https://www.upf.edu/en/web/sergiobarrachina          *
%%% *********************************************************************

%%% F. Wilhelmi Adaptation for Decentralized Learning in WNs 08/09/2017

%%% File description: main script for running WLAN's CTMN analysis

function [throughput, powerRxStationFromAp, powerRxApFromAp, SINR_cell] = function_main_sfctmn(wlans)

    close all
    % Display framework header
    % type 'sfctmn_header.txt'
    %% FRAMEWORK CONFIGURATION
    constants_sfctmn_framework
        
    if flag_save_console_logs
        diary('console_logs.txt') % Save logs in a text file
    end

    %% INPUT PROCESSING
    %   - Load constant variables
    %   - Load system configuration (e.g., path loss model, DSA policy, access
    % protocol type, etc.)
    %   - Check input correctness
    %   - Display input (system and WLANs)

    display_with_flag(' ', flag_general_logs)
    display_with_flag('Setting framework up...', flag_general_logs)

    % Framework constant variables
    display_with_flag('- Loading constant variables...', flag_general_logs)
    load('constants_sfctmn_framework.mat')        % Execute constants_script.m script to store constants in the workspace
    display_with_flag([LOG_LVL3 'Constants loaded!'], flag_general_logs)

    % System configuration
    display_with_flag([LOG_LVL2 'Loading system configuration...'], flag_general_logs)
    configuration_system            % Execute system_conf.m script to store constants in the workspace
    %load('configuration_system.mat');       % Load constants into workspace
    display_with_flag([LOG_LVL3 'System configuration loaded!'], flag_general_logs)
    
    % Determine the number of WLANs
    num_wlans = size(wlans, 2);
    wlans_aux = wlans;
%     if flag_activation
%         num_wlans_initial = num_wlans;   
%         for i = 1 : num_wlans
%             if ~wlans(i).activated && wlans(i).activation_iteration > 0
%                 wlans_aux(i) = [];
%                 num_wlans = num_wlans - 1;
%             end
%         end
%     end
    
    % Check input correctness
    if flag_input_checker
        display_with_flag([LOG_LVL3 'Checking input configuration...'], flag_general_logs)
        check_input_config(wlans_aux);
        display_with_flag([LOG_LVL4 'WLANs input file processed successfully!'], flag_general_logs)
    end

    [distance_ap_ap, distance_ap_sta] = compute_distance_nodes(wlans_aux);
   
    for i = 1 : num_wlans
        for j = 1 : num_wlans
            % Compute the power received in each STA and AP from each AP
            powerRxStationFromAp(i,j) = compute_power_received(distance_ap_sta(j,i), wlans_aux(j).tx_power, ...
                GAIN_TX_DEFAULT, GAIN_RX_DEFAULT, carrier_frequency, path_loss_model);    
            powerRxApFromAp(i,j) = compute_power_received(distance_ap_ap(i,j), wlans_aux(j).tx_power, ...
                GAIN_TX_DEFAULT, GAIN_RX_DEFAULT, carrier_frequency, path_loss_model);     
        end
    end
        
    % Compute the MCS according to the SINR in isolation mode
    mcs_per_wlan = compute_mcs(powerRxStationFromAp, nChannels);
    
    % SINR sensed in the STA in isolation (just considering ambient noise)
    %  - NOT USED
    sinr_isolation = compute_sinr(powerRxStationFromAp, 0, NOISE_DBM);    
    display_wlans(wlans_aux, flag_display_wlans, flag_plot_wlans, flag_plot_ch_allocation, nChannels,...
        path_loss_model, carrier_frequency, sinr_isolation)

    % Display system configuration
    display_with_flag([LOG_LVL2 'System configuration'], flag_general_logs)
    display_with_flag([LOG_LVL3 'Access protocol: ' LABELS_DICTIONARY_ACCESS_PROTOCOL(access_protocol_type + 1,:)], flag_general_logs)
    display_with_flag([LOG_LVL3 'DSA policy: ' LABELS_DICTIONARY_DSA_POLICY(dsa_policy_type,:)], flag_general_logs)
    display_with_flag([LOG_LVL3 'Path loss model: ' LABELS_DICTIONARY_PATH_LOSS(path_loss_model,:)], flag_general_logs)
    display_with_flag([LOG_LVL3 'Carrier frequency: ' num2str(carrier_frequency * 1e-9) ' GHz'], flag_general_logs)

    %% GLOBAL STATES SPACE (PSI)
    % - Identify global states space (PSI) according ONLY to medium access
    % protocol constraints

    display_with_flag(' ', flag_general_logs)
    display_with_flag([LOG_LVL1 'Identifying global state space (PSI)...'], flag_general_logs)
    [PSI_cell, num_global_states, PSI] = identify_global_states(wlans_aux, nChannels, num_wlans, access_protocol_type);
    display_with_flag([LOG_LVL2 'Global states identified! There are ' num2str(num_global_states) ' global states.'], flag_general_logs)
    
    %% SENSED POWER
    % Compute the power perceived by each WLAN in every channel in every global state [dBm]
    display_with_flag(' ', flag_general_logs)
    display_with_flag([LOG_LVL1 'Computing interference sensed power by the STAs in every state (Power_PSI). It may take some minutes :) ...'], flag_general_logs)
    [ Power_AP_PSI_cell, Power_STA_PSI_cell, SINR_cell] = compute_sensed_power(wlans_aux, num_global_states, PSI_cell, path_loss_model, ...
        carrier_frequency, flag_general_logs, powerRxStationFromAp, distance_ap_ap, distance_ap_sta, nChannels);
    display_with_flag([LOG_LVL2 'Sensed power computed!'], flag_general_logs)    
%     disp('Power_AP_PSI_cell')
%     Power_AP_PSI_cell{1}
%     Power_AP_PSI_cell{2}
%     Power_AP_PSI_cell{3}
%     Power_AP_PSI_cell{4}
%     disp('Power_STA_PSI_cell')
%     Power_STA_PSI_cell{1}
%     Power_STA_PSI_cell{2}
%     Power_STA_PSI_cell{3}
%     Power_STA_PSI_cell{4}
%     
%     disp('SINR_cell')
%     SINR_cell{1}
%     SINR_cell{2}
%     SINR_cell{3}
%     SINR_cell{4}
    
    %% FEASIBLE STATES SPACE (S)
    % Identify feasible states space (S) according to spatial and spectrum requirements.
    display_with_flag(' ', flag_general_logs)
    display_with_flag([LOG_LVL1 'Identifying feasible state space (S) and transition rate matrix (Q)...'], flag_general_logs)
    [ Q, S, S_cell, Q_logical_S, Q_logical_PSI, S_num_states ] = ...
        identify_feasible_states_and_Q(PSI_cell, Power_AP_PSI_cell, nChannels, ...
        wlans_aux, dsa_policy_type, mcs_per_wlan, flag_logs_feasible_space);
    display_with_flag([LOG_LVL2 'Feasible state space (S) identified! There are ' num2str(S_num_states) ' feasible states.'], flag_general_logs)
    
    %% MARKOV CHAIN
    % Solve Markov Chain from equilibrium distribution
    display_with_flag(' ', flag_general_logs)
    display_with_flag([LOG_LVL1 'Solving pi * Q = 0 ...'], flag_general_logs)

    % Equilibrium distribution array (pi). Element s is the probability of being in state s.
    % - The left null space of Q is equivalent to solve [pi] * Q =  [0 0 ... 0 1]
    
    p_equilibrium = mrdivide([zeros(1,size(Q,1)) 1],[Q ones(size(Q,1),1)]);
    [Q_is_reversible, error_reversible] = isreversible(Q,p_equilibrium,1e-8); % Alessandro code for checking reversibility
    display_with_flag([LOG_LVL2 'Equilibrium distribution found! Prob. of being in each possible state:'], flag_general_logs)
    display_with_flag(p_equilibrium, flag_general_logs)
    display_with_flag([LOG_LVL2 'Reversible Markov chain? ' num2str(Q_is_reversible) ' (error: ' num2str(error_reversible) ')'], flag_general_logs)

%     [prob_tx_num_channels_success, prob_tx_num_channels_unsuccess] = get_probability_tx_in_n_channels(Power_STA_PSI_cell,...
%         S_cell, PSI_cell, num_wlans, num_channels_system, p_equilibrium, path_loss_model, distance_ap_sta, wlans,...
%         carrier_frequency);
%     
%     disp([LOG_LVL2 'Probability of transmitting SUCCESSFULLY in num channels (0:num_channels_system): '])
%     disp(prob_tx_num_channels_success)
%     disp([LOG_LVL2 'Probability of transmitting UNSUCCESSFULLY (i.e. packet losses) in num channels (0:num_channels_system): '])
%     disp(prob_tx_num_channels_unsuccess)

    [prob_dominant, dominant_state_ix] = max(p_equilibrium);
    display_with_flag([LOG_LVL2 'Dominant state: s' num2str(dominant_state_ix) ' (with probability ' num2str(prob_dominant) ')'], flag_general_logs)

    display_with_flag(' ', flag_general_logs)
    display_with_flag([LOG_LVL1 'Computing throughput...'], flag_general_logs)

    % get_throughput now per states
    throughput = get_throughput(wlans_aux, num_wlans, p_equilibrium, S_cell, ...
        PSI_cell, SINR_cell, mcs_per_wlan, powerRxStationFromAp); 
%     throughput_wlans_aux = get_throughput(wlans_aux, num_wlans, p_equilibrium, S_cell, ...
%         PSI_cell, SINR_cell, mcs_per_wlan, powerRxStationFromAp); 
%     if flag_activation
%         throughput = zeros(1, num_wlans_initial);
%         k = 1;
%         for i = 1 : num_wlans_initial
%             if ~wlans_aux(i).activated        
%                 throughput(i) = 0;
%             else
%                 throughput(i) = throughput_wlans_aux(k);
%                 k = k + 1;
%             end
%         end
%     else
%         throughput = throughput_wlans_aux;
%     end
    proportional_fairness = sum(log(throughput));
    display_with_flag([LOG_LVL2 'Trhoughput computed!'], flag_general_logs)
        
     
    %% Save results
    if flag_save_results    
        disp('--------------------------------------------------------')
        disp([LOG_LVL1 'Saving results...'])
        save('./Code/Experiments/main_results.mat') % Save all variables (workspace) in file 'results.mat'
        disp([LOG_LVL2 'Results saved successfully!'])
        disp('--------------------------------------------------------')
    end
    
    %% Display info and plot

    display_with_flag(' ', flag_general_logs);
    display_with_flag(' ', flag_general_logs);
    display_with_flag([LOG_LVL1 '***** DISPLAYING RESULTS *****'], flag_general_logs);

    % Display global states
    if flag_display_PSI_states
        disp(' ')
        disp([LOG_LVL2 'GLOBAL states (PSI):'])
        for s = 1 : length(PSI_cell)
            disp(['PSI(' num2str(s) ')']);
            disp(PSI_cell{s})
        end
        disp(' ')
        disp([LOG_LVL2 'PSI logical transition matrix (Q_logical_PSI)'])
        disp(Q_logical_PSI)
    end

    % Display sensed power in every global state
    if flag_display_Power_PSI
         disp(' ')
        for s = 1 : length(Power_AP_PSI_cell)
            disp(['  - Power_PSI(' num2str(s) ')']);
            disp(Power_AP_PSI_cell{s})
        end
    end

    % Display feasible states
    if flag_display_S_states
        disp(' ')
        disp([LOG_LVL2 'FEASIBLE states (S). Number of states :' num2str(S_num_states)])
        for s = 1 : length(S_cell)
            disp(['S(' num2str(s) ')']);
            disp(S_cell{s})
        end
    end

    % Display logical transition rate matrix
    if flag_display_Q_logical
        disp([LOG_LVL2 'Logical transition rate matrix in S (Q_logical_S):'])
        disp(Q_logical_S)
    end

    % Display transition rate matrix
    if flag_display_Q
        disp([LOG_LVL2 'Transition rate matrix in S (Q):'])
        disp(Q)
    end

    % Plot global state space CTMC
    if flag_plot_PSI_ctmc
        disp([LOG_LVL2 'Plotting PSI CTMC...'])
        plot_ctmc(PSI, num_wlans, nChannels, 'CTMC of global (PSI) and feasible (S) states', Q_logical_PSI);
        disp([LOG_LVL3 'Plotted!'])
    end

    % Plot feasible state space CTMC
    if flag_plot_S_ctmc
        disp([LOG_LVL2 'Plotting S CTMC...'])
        plot_ctmc(S , num_wlans, nChannels, 'CTMC of feasible states (S)', Q_logical_S);
        disp([LOG_LVL3 'Plotted!'])
    end

    % Display throughput
    if flag_display_throughput
        disp([LOG_LVL2 'Throughput [Mbps]']);
        disp([LOG_LVL3 'Per WLAN: ' num2str(sum(throughput))]);
        for w = 1 : num_wlans
            disp([LOG_LVL4 LABELS_DICTIONARY(w) ': ' num2str(throughput(w))]);        
        end
        disp([LOG_LVL3 'Total: ' num2str(sum(throughput))]);
        disp([LOG_LVL3 'Proportional fairness: ' num2str(proportional_fairness)]);
    end

    if flag_plot_throughput
        plot_throughput(throughput, num_wlans, 'Throughput');
    end

    display_with_flag([LOG_LVL1 'Finished!'], flag_general_logs)
   
end