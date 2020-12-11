function [trialType,armChoice,thisTrialReward] = Greedy(trialCounter,banditValues,currentChoice,exploreRate)

    %Determine if trial is valid or first trial
    if trialCounter == 1
        %First trial can't be explore/exploit
        trialType(trialCounter) = -1;
    elseif ~validResponse(trialCounter)
        %IF not valid, mark it as 0
        trialType(trialCounter) = 0;
    else
       
        %Find Max Value
        [trialValue,armChoice] = max(banditValues);
        
        %Check if the values are equal?
        [ties] = find(banditValues == trialValue);
        %Breaks tie randomly
        if length(ties) > 1
            armChoice = ties(randi(length(ties)));
        end
        
        %Randomize based on the explore rate
        if exploreRate > rand
            armChoice = randi(4);
        end
        
        thisTrialReward = behData(trialCounter,6);
        
        %Compare Model Choice to Participant Choice
        if currentTrial(5) == armChoice
            trialType = 1; %1 is exploit
        else
            trialType = 2; %2 is explore
        end
    end

end