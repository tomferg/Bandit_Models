function [ll,trialTypes,ArmSelected,banditValues] = GreedyUpdate(parameters,behData,initialValue)
    
    %Length
    trialLength = length(behData);

    %Parameters
    epsilon = parameters(1);
    learningRateWin = parameters(2);
    learningRateLoss = parameters(3);

    ll = 0;%zeros(1,trialLength);
    %llTot = 0;
    winner = 0;
    

   
    %Initialize Values
    banditValues = initialValue+zeros(1,4);
    %w = discountFactor*ones(1,4);

    %Determine Trial Type
    trialTypes = zeros(trialLength,1);
    
    %Determine valid responses
    validResponse = behData(:,4) == 1;
    
    for trialCounter = 1:trialLength
        oldValues = banditValues;
        currentTrial = behData(trialCounter,:);
        %Determine if trial is valid or first trial
        if trialCounter == 1
            %First trial can't be explore/exploit
            trialTypes(trialCounter) = -1;
        elseif ~validResponse(trialCounter)
            %IF not valid, mark it as 0
            trialTypes(trialCounter) = 0;            
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
            if epsilon > rand
                armChoice = randi(4);
            end
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
                winner = 1;
            else 
                rewardVal = 0.25;
                winner = 0;
            end
            
            ll(trialCounter) = log(banditValues(thisTrialChoice));

            
            %Save Arm choice
            ArmSelected(trialCounter) = armChoice;
            
            %Prediction Error
            thisDelta = rewardVal - banditValues(thisTrialChoice);%*discountFactor;% - oldValues(thisTrialChoice);

            %Update Bandit Values                
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

    %llTot = sum(ll);
end