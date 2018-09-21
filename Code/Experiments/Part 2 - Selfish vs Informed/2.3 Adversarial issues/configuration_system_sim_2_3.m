% FILE DESCRIPTION:
% Script for generating the system configuration in simulation 2.3

path_loss_model = PATH_LOSS_AX_RESIDENTIAL;         % Path loss model index
access_protocol_type = ACCESS_PROTOCOL_IEEE80211;   % Access protocol type
flag_hardcode_distances = true;                     % Allows hardcoding distances from main_sfctmn.m file
carrier_frequency = 5;                              % Carrier frequency [GHz] (2.4 or 5) GHz
NOISE_DBM = -95;                                    % Ambient noise [dBm]
BANDWITDH_PER_CHANNEL = 20e6;                       % Bandwidth per channel [Hz]

% Dimensions of the 3D map 
MaxX=10;
MaxY=10; 
MaxZ=5;
% Maximum range for a STA
MinRange = [1 1 1];
MaxRange = [3 3 3];
MaxRangeX = 3;
MaxRangeY = 3;
MaxRangeZ = 3;

% ACTIONS

nChannels = 2;
channelActions = 1 : nChannels;     % Possible channels
% CHANNEL BONDING ONLY
% channelIndexes = 3;                      % Number of available channels (from 1 to n_channels)
% channelActions = 1 : channelIndexes;     % Possible channels
ccaActions = [-68 -90];             % CCA levels (dBm)
txPowerActions = [5 20];            % Transmit power levels (dBm)

% DSA policy type (SFCTMN)
dsa_policy_type = DSA_POLICY_ONLY_MAX;

save('configuration_system.mat');  % Save system configuration into current folder