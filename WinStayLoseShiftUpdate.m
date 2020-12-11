function [ll,trialTypes] = WinStayLoseShiftUpdate(parameters,behData)
        
winStayProb = parameters(1);
loseShiftProb = parameters(2);
trialTypes = nan(length(behData),1);
ll = 0;

    for WSLScounter = 2:length(behData)
        currentTrial = behData(WSLScounter,:);
        previousTrial = behData(WSLScounter-1,:);
        
        if WSLScounter == 1
            trialTypes(WSLScounter) = -1;
        elseif currentTrial == 2
            trialTypes(WSLScounter) = 0;
        elseif currentTrial(6) == 1 
            if currentTrial(6) == previousTrial(6) %Win-Stay
                ll = ll+log(winStayProb);
                trialTypes(WSLScounter) = 1;
            else
                ll = ll+(log(1-winStayProb)/3);
                trialTypes(WSLScounter) = 2;
            end
        else
            if currentTrial(6) ~= previousTrial(6) %Lose-Shift
                ll = ll+log(loseShiftProb);
                trialTypes(WSLScounter) = 1;
            else
                ll = ll+(log(1-loseShiftProb)/3);
                trialTypes(WSLScounter) = 2;
            end 
        end 
    end

ll = -abs(ll);

end