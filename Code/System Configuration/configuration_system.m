% FILE DESCRIPTION:
% Script for generating the default system configuration

path_loss_model = PATH_LOSS_ROOM_CORRIDOR_5250KHZ;         % Path loss model index
access_protocol_type = ACCESS_PROTOCOL_IEEE80211;   % Access protocol type
flag_hardcode_distances = true;                     % Allows hardcoding distances from main_sfctmn.m file
carrier_frequency = 5;                              % Carrier frequency [GHz] (2.4 or 5) GHz
NOISE_DBM = -95;                                    % Ambient noise [dBm]
BANDWITDH_PER_CHANNEL = 20e6;
SINGLE_USER_SPATIAL_STREAMS = 1;

% Dimensions of the 3D map 
MaxX=10;
MaxY=10;
MaxZ=5;
% Maximum range for a STA
MinRange = [1 1 1];
MaxRange = [5 5 5];
MaxRangeX = 5;
MaxRangeY = 5;
MaxRangeZ = 5;

% ACTIONS
nChannels = 2;
channelActions = 1 : nChannels;     % Possible channels
ccaActions = [-60, -80];             % CCA levels (dBm)
txPowerActions = [5 10];            % Transmit power levels (dBm)

% DSA policy type (SFCTMN)
dsa_policy_type = DSA_POLICY_ONLY_MAX;

CW_DEFAULT = 16;

save('configuration_system.mat');  % Save system configuration into current folder