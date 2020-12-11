function [probWinStay,probLossShift]  = winstayProb(armData,winData)
    
probWinStay = zeros(0,length(armData));
probLossShift = zeros(0,length(armData));
Win = 0;
WinStay = 0;
Loss = 0;
LoseShift = 0;

    for counter = 2:400
        %Set up Previous and Current Trials
        prevTrial = armData(1,counter-1);
        currentTrial = armData(1,counter);
        prevTrialWin = winData(1,counter-1);
        %Determine if Current Trial is a Win or Loss
        if currentTrial == prevTrial && prevTrialWin == 1
            Win = Win + 1;
            WinStay = WinStay + 1;
        elseif currentTrial ~= prevTrial && prevTrialWin == 1
            Win = Win + 1;
        elseif currentTrial ~= prevTrial && prevTrialWin == 0
            Loss = Loss + 1;
            LoseShift = LoseShift + 1;
        elseif currentTrial == prevTrial && prevTrialWin == 0
            Loss = Loss + 1;
        end
        %This is needed to avoid NANs
        if Win == 0
            probWinStay(counter) =0;
        else
            probWinStay(counter) = WinStay/Win;
        end
        if Loss == 0
            probLossShift(counter) = 0;
        else
            probLossShift(counter) = LoseShift/Loss;
        end
    end



end