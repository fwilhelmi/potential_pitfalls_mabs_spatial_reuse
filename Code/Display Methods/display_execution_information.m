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

function [] = display_execution_information( wlans, rewardPerConfiguration, transitionsCounter)

    % Generate constants 
    constants_sfctmn_framework
    constants_thompson_sampling
    % Set configurations
    configuration_system
    configuration_agents
        
        if saveConsoleLogs
            diary(['./Output/console_logs' endTextOutputFile '.txt']) % Save logs in a text file
        end
                 
        nWlans = size(wlans, 2);
        
        % Print the preferred action per wlan
        for i = 1 : nWlans      

            % Display the most rewarding configuration
            if wlans(i).legacy
                % For legacy WLANs, show the default configuration
                a = wlans(i).primary;
                b = (ccaActions == wlans(i).cca);
                c = (txPowerActions == wlans(i).tx_power);
            else
                [~, ix] = max(rewardPerConfiguration(i, :));
                [a, b, c] = val2indexes(possibleActions(ix), size(channelActions,2), ...
                    size(ccaActions,2), size(txPowerActions,2)); 
            end
            disp('----------------')
            disp(['   * WN' num2str(i) ':'])
            disp(['       - Primary Channel:' num2str(a)])
            disp(['       - CCA:' num2str(ccaActions(b))])
            disp(['       - TX Power:' num2str(txPowerActions(c))])

            % Show the actions probability    
            %if transitionsCounter ~= 'null'
                a = transitionsCounter(i,:);
                % Max value
                [val1, ix1] = max(a);
                [ch1_1, y, x] = val2indexes(possibleActions(allCombs(ix1,1)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
                cca1_1 = ccaActions(y);
                tpc1_1 = txPowerActions(x);
                [ch1_2, y, x] = val2indexes(possibleActions(allCombs(ix1,2)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
                cca1_2 = ccaActions(y);
                tpc1_2 = txPowerActions(x);
                % Second max value
                [val2, ix2] = max(a(a<max(a)));
                [ch2_1, y, x] = val2indexes(possibleActions(allCombs(ix2,1)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
                cca2_1 = ccaActions(y);
                tpc2_1 = txPowerActions(x);
                [ch2_2, y, x] = val2indexes(possibleActions(allCombs(ix2,2)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
                cca2_2 = ccaActions(y);
                tpc2_2 = txPowerActions(x);
                % Third max value
                [val3, ix3] = max(a(a<max(a(a<max(a)))));
                [ch3_1, y, x] = val2indexes(possibleActions(allCombs(ix3,1)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
                cca3_1 = ccaActions(y);
                tpc3_1 = txPowerActions(x);
                [ch3_2, y, x] = val2indexes(possibleActions(allCombs(ix3,2)), size(channelActions,2), size(ccaActions,2), size(txPowerActions,2)); 
                cca3_2 = ccaActions(y);
                tpc3_2 = txPowerActions(x);

                disp(['    * Probability of going from ' num2str(allCombs(ix1,1)) ' (ch=' num2str(ch1_1) '/cca=' num2str(cca1_1) '/tpc=' num2str(tpc1_1) ')' ...
                    ' to ' num2str(allCombs(ix1,2)) ' (ch=' num2str(ch1_2) '/cca=' num2str(cca1_2) '/tpc=' num2str(tpc1_2) ')' ...
                    ' = ' num2str(val1/totalIterations)])

                disp(['    * Probability of going from ' num2str(allCombs(ix2,1)) ' (ch=' num2str(ch2_1) '/cca=' num2str(cca2_1) '/tpc=' num2str(tpc2_1) ')' ...
                    ' to ' num2str(allCombs(ix2,2)) ' (ch=' num2str(ch2_2) '/cca=' num2str(cca2_2) '/tpc=' num2str(tpc2_2) ')' ...
                    ' = ' num2str(val2/totalIterations)])

                disp(['    * Probability of going from ' num2str(allCombs(ix3,1)) ' (ch=' num2str(ch3_1) '/cca=' num2str(cca3_1) '/tpc=' num2str(tpc3_1) ')' ...
                    ' to ' num2str(allCombs(ix3,2)) ' (ch=' num2str(ch3_2) '/cca=' num2str(cca3_2) '/tpc=' num2str(tpc3_2) ')' ...
                    ' = ' num2str(val3/totalIterations)])
            %end
        end
end