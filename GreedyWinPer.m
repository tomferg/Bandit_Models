function [ll,ArmSelected,banditValues,win] = GreedyWinPer(parameters,behWin,initialValue)

%Parameters
epsilon = parameters(1);
learningRateLoss = parameters(2);
learningRateWin = parameters(3);
ll = 0;

%Length
trialLength = length(behWin);

%Initialize Values
banditValues = zeros(1,4) + initialValue;

%     %Determine Trial Type
%     trialTypes = zeros(trialLength,1);

%     %Determine valid responses
%     validResponse = behWin(:,4) == 1;

for trialCounter = 1:trialLength
    currentTrial = behWin(:,trialCounter);

    %Determine if trial is valid or first trial
    %         if trialCounter == 1
    %             %First trial can't be explore/exploit
    %             trialTypes(trialCounter) = -1;
    %         elseif ~validResponse(trialCounter)
    %             %IF not valid, mark it as 0
    %             trialTypes(trialCounter) = 0;
    %         else
    %Find Max Value
    [trialValue,armChoice] = max(banditValues);
    
    %Check if the values are equal?
    [ties] = find(banditValues == trialValue);
    %Breaks tie randomly
    if length(ties) > 1
        armChoice = ties(randi(length(ties)));
    end
    
    %Randomize based on the explore rate
    if epsilon > rand
        armChoice = randi(4);
    end
    %             %Compare Model Choice to Participant Choice
    %             if currentTrial(5) == armChoice
    %                 trialTypes(trialCounter) = 1;
    %             else
    %                 trialTypes(trialCounter) = 2;
    %             end
    
    %Determine if Trial is Rewarded or not
    if rand()*100 < currentTrial(armChoice)
        rewardVal = 0.25;
        win(trialCounter) = 1;
    else
        rewardVal = -0.5;
        win(trialCounter) = 0;
    end
    
    %Save Arm choice
    ArmSelected(trialCounter) = armChoice;
    %Compute Log Likelihood    
    ll(trialCounter) = log(banditValues(armChoice));
            
    thisDelta = rewardVal - banditValues(armChoice);%*discountFactor;% - oldValues(thisTrialChoice);
    
    if thisDelta > 0
        banditValues(armChoice) = banditValues(armChoice) + learningRateWin * thisDelta;
    else
        banditValues(armChoice) = banditValues(armChoice) + learningRateLoss * thisDelta;
    end
    
    
    %Constrain model to avoid problems - this just avoids it going
    %larger than -1 and 1 (breaks model if not)
    if banditValues(armChoice) > 1
        banditValues(armChoice) = 1;
    end
    if banditValues(armChoice) < -1
        banditValues(armChoice) = -1;
    end
    

    
    
    %end
end

    ll = -abs(sum(ll));
end