function [ll,ArmSelected,banditValues,win] = ChanceWinPer(parameters,behWin,initialValue)

%Parameters
learningRateWin = parameters(1);
learningRateLoss = parameters(2);
ll = 0;

%Length
trialLength = length(behWin);

%Initialize Values
banditValues = zeros(1,4) + initialValue;

for trialCounter = 1:trialLength
    currentTrial = behWin(:,trialCounter);

    %Randomize based on the explore rate
     armChoice = randi(4);

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
            
    %Save Arm choice
    ArmSelected(trialCounter) = armChoice;
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
        
end

    ll = -abs(sum(ll));
end