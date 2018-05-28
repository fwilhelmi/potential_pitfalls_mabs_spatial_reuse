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

% EXPERIMENT EXPLANATION:
%

function wlans = generate_wlan_randomly ( numWlans, randomInitialConf, drawMap )
% GenerateNetwork3D - Generates a 3D network 
%   OUTPUT: 
%       * wlan - contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)
%   INPUT: 
%       * nWlans: number of WLANs on the studied environment

    % Load TS constants
    load('constants_thompson_sampling.mat')
    % Load system & TS configuration
    load('configuration_system.mat')
    load('configuration_agents.mat')
        
    % Generate wlan structures
    wlans = [];                                      % Array of structures containning wlans info

    for w = 1 : numWlans
        % WLAN code
        wlans(w).code = w;   
        % Initial configuration
        if randomInitialConf % Random
            wlans(w).primary = datasample(nChannels, 1);        % Pick primary channel
            wlans(w).tx_power = datasample(txPowerActions, 1);  % Pick transmission power
            wlans(w).cca = datasample(ccaActions, 1);           % Pick CCA level
        else % Greedy configuration
            wlans(w).primary = min(nChannels);          % Pick primary channel
            wlans(w).tx_power = max(txPowerActions);    % Pick transmission power
            wlans(w).cca = min(ccaActions);             % Pick CCA level
        end
        
        % Channels range (for Channel Bonding purposes - does not apply here)
        wlans(w).range = [wlans(w).primary wlans(w).primary];  % pick range

        % Position AP
        wlans(w).x = MaxX * rand();
        wlans(w).y = MaxY * rand();
        wlans(w).z = MaxZ * rand(); 
        wlans(w).position_ap = [wlans(w).x  wlans(w).y  wlans(w).z];
        % Position STA 
        %   - Determine the distance in each of the directions
        x_distance = MinRange(1) + rand(1,1)*(MaxRange(1)-MinRange(1));
        y_distance = MinRange(2) + rand(1,1)*(MaxRange(2)-MinRange(2));
        z_distance = MinRange(3) + rand(1,1)*(MaxRange(3)-MinRange(3));   
        %   - Assign to which direction to locate the STA
        if(rand() < 0.5), xc = x_distance;  else, xc = -x_distance; end
        if(rand() < 0.5), yc = y_distance;  else, yc = -y_distance; end
        if(rand() < 0.5), zc = z_distance;  else, zc = -z_distance; end
        %   - Assign determined value
        wlans(w).xn = min(abs(wlans(w).x+xc), MaxX);  
        wlans(w).yn = min(abs(wlans(w).y+yc), MaxY);
        wlans(w).zn = min(abs(wlans(w).z+zc), MaxZ);
        xn(w)=wlans(w).xn;
        yn(w)=wlans(w).yn;
        zn(w)=wlans(w).zn;        
        wlans(w).position_sta = [wlans(w).xn  wlans(w).yn  wlans(w).zn];

        wlans(w).lambda = 14815;         % Pick lambda
        
        %wlans(w).lambda = input_data(w,INPUT_FIELD_LAMBDA);         % Pick lambda
        wlans(w).bandwidth = BANDWITDH_PER_CHANNEL;
                
        wlans(w).states = [];   % Instantiate states for later use          
        wlans(w).widths = [];   % Instantiate acceptable widhts item for later use
               
        wlans(w).legacy = 0;
        
        wlans(w).cw = 16;

    end

    % COMPUTE THE UPPER BOUND THROUGHPUT PER WLAN
    upperBoundTpt = compute_throughput_isolation(wlans); 
    
    for w = 1 : numWlans
        wlans(w).upper_bound = upperBoundTpt(w);
    end
       
    if drawMap, draw_network_3D(wlans); end

end