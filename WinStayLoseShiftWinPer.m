function [ll,armSelected,win] = WinStayLoseShiftWinPer(parameters,behWin)

winStayProb = parameters(1);
loseShiftProb = parameters(2);
ll = 0;
armSelected = zeros(1,length(behWin));

for WSLScounter = 1:length(behWin)
    currentTrial = behWin(:,WSLScounter);

    if WSLScounter == 1
        
        armChoice = randi(4);
        armSelected(WSLScounter) = armChoice;

        if rand()*100 < currentTrial(armChoice)
            win(WSLScounter) = 1;
        else
            win(WSLScounter) = 0;
        end
    else
        previousTrial = win(WSLScounter-1);
        previousArm = armSelected(WSLScounter-1);
        
        
        %Determine ArmChoice
        if previousTrial == 1
            
            if winStayProb > rand(1) %win-stay
                ll = ll+log(winStayProb);
                armChoice = previousArm;
            else
                ll = ll+(log(1-winStayProb)/3);
                possibleChoice = [1,2,3,4];
                possibleChoice(previousArm) = [];
                pos = randi(length(possibleChoice));
                armChoice = possibleChoice(pos);
            end
        else
            if loseShiftProb > rand(1) %lose-shift
                ll = ll+log(loseShiftProb);
                possibleChoice = [1,2,3,4];
                possibleChoice(previousArm) = [];
                pos = randi(length(possibleChoice));
                armChoice = possibleChoice(pos);
            else
                ll = ll+(log(1-loseShiftProb)/3);
                armChoice = previousArm;
            end
            
        end
        
        armSelected(WSLScounter) = armChoice;
        
        %Determine if Trial is Rewarded or not
        if rand()*100 < currentTrial(armChoice)
            win(WSLScounter) = 1;
        else
            win(WSLScounter) = 0;
        end
    end
    
    
    

    
end

ll = -abs(sum(ll));

end