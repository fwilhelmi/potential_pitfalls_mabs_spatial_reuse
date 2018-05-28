function [ estimatedRewardPerWlan ] = compute_estimated_reward( rewardPerWlan, estimatedRewardPerWlan, timesArmHasBeenPlayed, selectedAction )
%COMPUTE_ESTIMATED_REWARD 
%   Detailed explanation goes here

    nWlans = size(estimatedRewardPerWlan, 1);
       
    for i = 1 : nWlans       
        estimatedRewardPerWlan(i, selectedAction(i)) = ((estimatedRewardPerWlan(i, selectedAction(i)) ...
            * timesArmHasBeenPlayed(i, selectedAction(i))) ...
            + rewardPerWlan(i)) / (timesArmHasBeenPlayed(i, selectedAction(i)) + 2);
    end

end