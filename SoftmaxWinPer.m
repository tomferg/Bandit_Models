function [ll,ArmSelected,banditValues,win] = SoftmaxWinPer(parameters,behWin,initialValue)

%Parameters
temperature = parameters(1);
learningRateWin = parameters(2);
learningRateLoss = parameters(3);
ll = 0;

%Length
trialLength = length(behWin);
win = nan(400,1);

%Initialize Values
banditValues = zeros(1,4) + initialValue;

for trialCounter = 1:trialLength
    currentTrial = behWin(:,trialCounter);
    
    possibleOptions = 1:1:4;
    numerator = exp(banditValues.*temperature);
    denom = sum(numerator);
    total = numerator/denom;
    probabilities = cumsum(total);
    randselect = rand(1);
    check = randselect >= probabilities;
    findChoice = find(check == 0,1,'first');
    armChoice = possibleOptions(findChoice);
    
    
    %Determine if Trial is Rewarded or not
    if rand()*100 < currentTrial(armChoice)
        rewardVal = 0.25;
        win(trialCounter) = 1;
    else
        rewardVal = -0.5;
        win(trialCounter) = 0;
    end
    ll = ll + log(banditValues(armChoice));
    
    
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
    
    %             %Compute Prediction Error - Currently SARSA
    %             predictionError = rewardVal + trialValue(armChoice)*discountFactor - oldValues(armChoice);
    %
    %             %Update Values
    %             banditValues(armChoice) = banditValues(armChoice) + learningRate * predictionError;
    
    
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