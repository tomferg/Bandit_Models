function [ll,trialTypes,ArmSelected,banditValues] = SoftmaxUpdate(parameters,behData,initialValue)
    
    %Parameters
    temperature = parameters(1);
    learningRateWin = parameters(2);
    learningRateLoss = parameters(3);

    ll = 0;
    
    %Length
    trialLength = length(behData);
   
    %Initialize Values
    banditValues = zeros(1,4) + initialValue;

    %Determine Trial Type
    trialTypes = zeros(trialLength,1);
    
    %Determine valid responses
    validResponse = behData(:,4) == 1;
    
    for trialCounter = 1:trialLength
        currentTrial = behData(trialCounter,:);
        %Determine if trial is valid or first trial
        if trialCounter == 1
            %First trial can't be explore/exploit
            trialTypes(trialCounter) = -1;
        elseif ~validResponse(trialCounter)
            %IF not valid, mark it as 0
            trialTypes(trialCounter) = 0;            
        else
%             %Randomize based on the temperature
            possibleOptions = 1:1:4;
            numerator = exp(temperature./banditValues);
            denom = sum(numerator);
            total = numerator/denom;
            probabilities = cumsum(total);
            randselect = rand(1);
            check = randselect >= probabilities;
            findChoice = find(check == 0,1,'first');
            armChoice = possibleOptions(findChoice);
        
            %Compare Model Choice to Participant Choice
            thisTrialChoice = currentTrial(5);
            if thisTrialChoice == armChoice
                trialTypes(trialCounter) = 1;
            else
                trialTypes(trialCounter) = 2;
            end

            %Determine if Trial is Rewarded or not
            if currentTrial(6) == 2
                rewardVal = 0;
            elseif currentTrial(6) == 0
                rewardVal = -0.5;
            else 
                rewardVal = 0.25;
            end
            
            ll(trialCounter) = log(banditValues(thisTrialChoice));

            
            %Save Arm choice
            ArmSelected(trialCounter) = armChoice;
            
            %Alpha Values with win/loss
            thisDelta = rewardVal - banditValues(thisTrialChoice);

            
            if thisDelta > 0
                banditValues(thisTrialChoice) = banditValues(thisTrialChoice) + learningRateWin * thisDelta; 
            else
                banditValues(thisTrialChoice) = banditValues(thisTrialChoice) + learningRateLoss * thisDelta;
            end
            
            %Constrain model to avoid problems - this just avoids it going
            %larger than -1 and 1
            if banditValues(armChoice) > 1
                banditValues(armChoice) = 1;
            end
            if banditValues(armChoice) < -1
                banditValues(armChoice) = -1;
            end  
        end
    end
    
    ll = -abs(sum(ll));
end