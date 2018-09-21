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

function [ wlans_that_converged, countConvergence ] = check_thompson_sampling_convergence(convergenceType, previous_wlans_that_converged, ...
    countConvergence, previousEstimatedRewardPerWlan, currentEstimatedRewardPerWlan, totalExperiencedRegret, iteration)

    % CHECK CONVERGENCE
    
    % Load TS constants
    load('constants_thompson_sampling.mat')
    
    nWlans = size(currentEstimatedRewardPerWlan, 2);
    %K = size(totalEstimatedReward, 2);
    provisional_list = previous_wlans_that_converged ;
    
    average_regret = zeros(1, nWlans);
    cumulative_regret = zeros(1, nWlans);
     
    for wlan_i = 1 : nWlans    

        if sum(provisional_list == wlan_i) == 0
            
            switch convergenceType
                % Variation of the last X estimated rewards
                case CASE_CONVERGENCE_TYPE_1    
                    % Check variation between iterations "i" and "i-1"
                    if abs( currentEstimatedRewardPerWlan(wlan_i) - ...
                            previousEstimatedRewardPerWlan(wlan_i) ) < allowed_error
%                         disp('accomplished')
                        countConvergence(wlan_i) = countConvergence(wlan_i) + 1; 
                    else
%                         disp('not accomplished')
                        countConvergence(wlan_i) = 0; 
                    end
                    % Determine the number of times that the estimated reward has remained stable
                    if countConvergence(wlan_i) >= numMaxIterationsConvergence
                        disp(['ALERT: TS Converged in WLAN ' num2str(wlan_i) ' in iteration ' num2str(iteration)])
                        provisional_list = [provisional_list wlan_i];
                    end
                % Monitor the average regret - Individual
                case CASE_CONVERGENCE_TYPE_2                        
                    % Check last "numMaxIterationsConvergence" iterations to assess convergence
                    if iteration > numMaxIterationsConvergence
                        minIteration = iteration - numMaxIterationsConvergence; 
                    else
                        minIteration = 1;
                    end
                    % Compute the average regret for the last "numMaxIterationsConvergence"
                    cumulative_regret = 0; 
                    for i = minIteration : iteration
                        cumulative_regret = cumulative_regret + totalExperiencedRegret{i}(wlan_i);
                    end
                    average_regret(wlan_i) = sum(cumulative_regret)/(iteration-minIteration);    
                    % Check if the average regret experienced by wlan_i matches the acceptance criteria
                    if average_regret(wlan_i) < epsilon_regret
                        disp(['ALERT: TS Converged in WLAN ' num2str(wlan_i) ' in iteration ' num2str(iteration)])
                        provisional_list = [provisional_list wlan_i];
                    end 
                % Monitor the average regret - Collective
                case CASE_CONVERGENCE_TYPE_3    
                    % Check last "numMaxIterationsConvergence" iterations to assess convergence
                    if iteration > numMaxIterationsConvergence
                        minIteration = iteration - numMaxIterationsConvergence; 
                    else
                        minIteration = 1;
                    end
                    % Compute the average regret for the last "numMaxIterationsConvergence"
                    cumulative_regret(wlan_i) = 0;
                    for i = minIteration : iteration
                        cumulative_regret(wlan_i) = cumulative_regret(wlan_i) + totalExperiencedRegret{i}(wlan_i);
                    end
                    average_regret(wlan_i) = cumulative_regret(wlan_i)/(iteration-minIteration);
                % Hybrid approach - Estimated reward + Average regret (collective)
                case CASE_CONVERGENCE_TYPE_4
                    % STEP 1: Check the estimated reward of the last "numMaxIterationsConvergence" iterations
%                     if wlan_i == 1
%                         disp(repmat('-',1,20))
%                         disp([' * iteration: ' num2str(iteration)])
%                         disp([' * totalEstimatedReward: ' num2str(currentEstimatedRewardPerWlan(wlan_i))])
%                         disp([' * previousTotalEstimatedReward: ' num2str(previousEstimatedRewardPerWlan(wlan_i))])
%                         disp([' * countConvergence(wlan_i): ' num2str(countConvergence(wlan_i))])
%                     end
                    
                    % Check variation between iterations "i" and "i-1"
                    if abs( currentEstimatedRewardPerWlan(wlan_i) - previousEstimatedRewardPerWlan(wlan_i) ) < allowed_error
%                         if wlan_i == 1, disp('accomplished'); end
                        countConvergence(wlan_i) = countConvergence(wlan_i) + 1; 
                    else
%                         if wlan_i == 1, disp('not accomplished'); end
                        countConvergence(wlan_i) = 0; 
                    end                
                    % Determine the number of times that the estimated reward has remained stable
                    if countConvergence(wlan_i) >= numMaxIterationsConvergence
                        provisional_list = [provisional_list wlan_i];
                    end
                    % STEP 2: check the average regret 
                    % Check last "numMaxIterationsConvergence" iterations to assess convergence
                    if iteration > numMaxIterationsConvergence
                        minIteration = iteration - numMaxIterationsConvergence; 
                    else
                        minIteration = 1;
                    end
                    % Compute the average regret for the last "numMaxIterationsConvergence"
                    cumulative_regret(wlan_i) = 0;
                    for i = minIteration : iteration
                        cumulative_regret(wlan_i) = cumulative_regret(wlan_i) + totalExperiencedRegret{i}(wlan_i);
                    end
                    average_regret(wlan_i) = cumulative_regret(wlan_i)/(iteration-minIteration);     
                    
%                     if wlan_i == 1
%                         disp(['cumulative_regret: ' num2str(cumulative_regret(wlan_i))])
%                         disp(['iterations: ' num2str(iteration-minIteration)])
%                         disp(['average_regret: ' num2str(average_regret(wlan_i))])                       
%                     end
            end           

        end

    end 
    
    % Only for CASE_CONVERGENCE_TYPE_3 (variability of the collective regret)
    if convergenceType == CASE_CONVERGENCE_TYPE_3 || convergenceType == CASE_CONVERGENCE_TYPE_4 
        
        mean_average_regret = mean(average_regret);
        std_average_regret = std(average_regret);        

%         cumulative_regret
%         average_regret
%         disp(['Mean average regret: ' num2str(mean_average_regret) '; Mean std: ' num2str(std_average_regret)])
           
        
        %disp(['Average regret: ' num2str(mean_average_regret) '; std: ' num2str(std_average_regret)])
        if convergenceType == CASE_CONVERGENCE_TYPE_3
            % Check if the mean average regret experienced matches the acceptance criteria     
            if mean_average_regret < epsilon_regret && std_average_regret < epsilon_regret / 2
                disp(['ALERT: TS Converged in iteration ' num2str(iteration)])
                provisional_list = 1:nWlans;
            end
        % Only for CASE_CONVERGENCE_TYPE_4 (hybrid approach)    
        elseif convergenceType == CASE_CONVERGENCE_TYPE_4              
            if size(provisional_list, 2) == nWlans || mean_average_regret < epsilon_regret ...
                    && std_average_regret < epsilon_regret / 2
                % We have converged
                disp(['ALERT: TS Converged in iteration ' num2str(iteration)])
                provisional_list = 1 : nWlans;
            else
                % Not convergence, so empty the list of WLANs that have converged
                provisional_list = [];
            end
        end
        
    end
     
    % Return the list of WLANs that have converged
    wlans_that_converged = provisional_list;

end