% Modelling for Adam's Class

%% Chance Model
clc;clear;close all;

%Attempt different starting values?
%try q-learning later
%try other search
%Parameter estimation

%Set up loading data
addpath('./Behavioural_Data');
fileLoc = dir('./Behavioural_Data/*.txt');


%Parameters for possible solutions?
initialValue = 0.5;
ArraySize = 10;

%Initialize values
chanceParam = zeros(length(fileLoc),2);
tunedLLs = zeros(length(fileLoc),1);
xPart = zeros(ArraySize,2);
FVALpart = zeros(ArraySize,1);

for partCounter = 1:length(fileLoc)
    %Load Data
    behData = load(fileLoc(partCounter).name);
    %Tune model
    fun = @(parameters)ChanceUpdate(parameters,behData,initialValue);
    eps = 0.01;
    
    %Parameter initialization
    learningRateWinSet = betarnd(1.1,1.1,[ArraySize,1]);%Learning Rate - beta distribution
    learningRateLossSet = betarnd(1.1,1.1,[ArraySize,1]);%Learning Rate - beta distribution
   
    
    
    for pCounter = 1:ArraySize
        StartParam = [learningRateWinSet(pCounter),learningRateLossSet(pCounter)];
        %Useing fmincon - try other search?
        [x, FVAL] = fmincon(fun,StartParam,[],[],[],[],[eps eps],[1 1]);
        %options = optimset('MaxFunEvals',10000,'MaxIter',10000);
        %[x, FVAL] = fminsearch(fun,StartParam,options);
        xPart(pCounter,:) = x;
        FVALpart(pCounter,1) = FVAL;
    end
    
    [minFval,minFloc] = min(FVALpart);
    
    chanceParam(partCounter,:) = xPart(minFloc,:);
    tunedLLs(partCounter) = minFval;
    
end


% %Compare Reaction Times for Explore vs Exploit
% %Loads up best fit parameters
% for partCounter3 = 1:length(fileLoc)
%     %Load Data
%     behData = load(fileLoc(partCounter3).name);
%     
%     [ll,trialType,ArmSelected,banditValues] = ChanceUpdate(behParam(partCounter3,:),behData,initialValue);
%     llPart(partCounter3) = ll;
%     trialTypePart(partCounter3,:) = trialType;
% end
% 
% exploit = sum(sum(trialTypePart(:,:) == 1));
% explore = sum(sum(trialTypePart(:,:) == 2));
% 
% 
% %Compare RTs for Win v Losses?
% 
% for rtCounter = 1:length(fileLoc)
%     
%     behData = load(fileLoc(rtCounter).name);
%             
%     exploreTrial = find(trialTypePart(rtCounter,:) == 2);
%     exploitTrial = find(trialTypePart(rtCounter,:) == 1);
%     exploreWinPer = mean(behData(exploreTrial,6))/(mean(behData(exploreTrial,6))+mean(behData(exploitTrial,6)));
%     exploitWinPer = mean(behData(exploitTrial,6))/(mean(behData(exploitTrial,6))+mean(behData(exploreTrial,6)));
%     exploreRT(rtCounter) = mean(behData(exploreTrial,3));
%     exploitRT(rtCounter) = mean(behData(exploitTrial,3));
% 
% end
% 
% disp(mean(exploreRT));
% disp(mean(exploitRT));
% disp(mean(exploreWinPer));
% disp(mean(exploitWinPer));

%Save Parameters and Trial Type
save('Chance','chanceParam')
save('ChanceLL','tunedLLs')

%% Greedy Model
clc;clear;close all;

%Set up loading data
addpath('./Behavioural_Data');
fileLoc = dir('./Behavioural_Data/*.txt');


%Parameters for possible solutions?
learningRateWin = 0.01; %Learning rate for the Prediction Error
learningRateLoss = 0.01; %Learning rate for the Prediction Error
epsilon = 0.01;
%parameters = [epsilon,learningRate];
initialValue = 0.5;
ArraySize = 10;

%Initialize values
greedyParam = zeros(length(fileLoc),3);
tunedLLs = zeros(length(fileLoc),1);
xPart = zeros(ArraySize,3);
FVALpart = zeros(ArraySize,1);


for partCounter = 1:length(fileLoc)
    %Load Data
    behData = load(fileLoc(partCounter).name);
    %Tune model
    fun = @(parameters)GreedyUpdate(parameters,behData,initialValue);
    eps = 0.01;
    
    %Parameter initialization
    learningRateWinSet = betarnd(1.1,1.1,[ArraySize,1]);%Learning Rate - beta distribution
    learningRateLossSet = betarnd(1.1,1.1,[ArraySize,1]);%Learning Rate - beta distribution
    exploreSet = betarnd(1,1,[ArraySize,1]);%Temperature - gamma distribution
    
    for pCounter = 1:ArraySize
        StartParam = [exploreSet(pCounter),learningRateWinSet(pCounter),learningRateLossSet(pCounter)];
        %Useing fmincon - try other search?
        [x, FVAL] = fmincon(fun,StartParam,[],[],[],[],[eps eps eps],[1 1 1]);
        xPart(pCounter,:) = x;
        FVALpart(pCounter,1) = FVAL;
    end
    
    [minFval,minFloc] = min(FVALpart);
    
    greedyParam(partCounter,:) = xPart(minFloc,:);
    tunedLLs(partCounter) = minFval;
    
end


% %Compare Reaction Times for Explore vs Exploit
% %Loads up best fit parameters
% for partCounter3 = 1:length(fileLoc)
%     %Load Data
%     behData = load(fileLoc(partCounter3).name);
%     
%     [ll,trialType,ArmSelected,banditValues] = GreedyUpdate(behParam(partCounter3,:),behData,initialValue);
%     llPart(partCounter3) = ll;
%     trialTypePart(partCounter3,:) = trialType;
% end
% 
% exploit = sum(sum(trialTypePart(:,:) == 1));
% explore = sum(sum(trialTypePart(:,:) == 2));
% 
% 
% %Compare RTs for Win v Losses?
% 
% for rtCounter = 1:length(fileLoc)
%     
%     behData = load(fileLoc(rtCounter).name);
%             
%     exploreTrial = find(trialTypePart(rtCounter,:) == 2);
%     exploitTrial = find(trialTypePart(rtCounter,:) == 1);
%     exploreWinPer = mean(behData(exploreTrial,6))/(mean(behData(exploreTrial,6))+mean(behData(exploitTrial,6)));
%     exploitWinPer = mean(behData(exploitTrial,6))/(mean(behData(exploitTrial,6))+mean(behData(exploreTrial,6)));
%     exploreRT(rtCounter) = mean(behData(exploreTrial,3));
%     exploitRT(rtCounter) = mean(behData(exploitTrial,3));
% 
% end
% 
% disp(mean(exploreRT));
% disp(mean(exploitRT));
% disp(mean(exploreWinPer));
% disp(mean(exploitWinPer));

%Save Parameters and Trial Type
save('Greedy','greedyParam')
save('GreedyLL','tunedLLs')

%% Softmax Model
clc;clear;close all;

%Set up loading data
addpath('./Behavioural_Data');
fileLoc = dir('./Behavioural_Data/*.txt');


%Parameters for possible solutions?
%learningRate = 0.5; %Learning rate for the Prediction Error
%temperature = 0.5;
initialValue = 0.5;
ArraySize = 10;

%Initialize values
softmaxParam = zeros(length(fileLoc),3);
tunedLLs = zeros(length(fileLoc),1);
xPart = zeros(ArraySize,3);
FVALpart = zeros(ArraySize,1);


for partCounter = 1:length(fileLoc)
    %Load Data
    behData = load(fileLoc(partCounter).name);
    %Tune model
    fun = @(parameters)SoftmaxUpdate(parameters,behData,initialValue);
    eps = 0.01;
    
    %Parameter initialization
    learningRateWinSet = betarnd(1,1,[ArraySize,1]);%Learning Rate - beta distribution
    learningRateLossSet = betarnd(1,1,[ArraySize,1]);%Learning Rate - beta distribution
    temperatureSet = gamrnd(1,2,[ArraySize,1]);%Temperature - gamma distribution
    
    for pCounter = 1:ArraySize
        StartParam = [temperatureSet(pCounter),learningRateWinSet(pCounter),learningRateLossSet(pCounter)];
        %Useing fmincon - try other search?
        [x, FVAL] = fmincon(fun,StartParam,[],[],[],[],[eps eps eps],[20 1 1]);
        %options = optimset('MaxFunEvals',10000,'MaxIter',10000);
        %[x, FVAL] = fminsearch(fun,StartParam,options);
        xPart(pCounter,:) = x;
        FVALpart(pCounter,1) = FVAL;
    end
    
    [minFval,minFloc] = min(FVALpart);
    
    softmaxParam(partCounter,:) = xPart(minFloc,:);
    tunedLLs(partCounter) = minFval;
    
end


% %Compare Reaction Times for Explore vs Exploit
% %Loads up best fit parameters
% for partCounter3 = 1:length(fileLoc)
%     %Load Data
%     behData = load(fileLoc(partCounter3).name);
%     
%     [ll,trialType,ArmSelected,banditValues] = SoftmaxUpdate(behParam(partCounter3,:),behData,initialValue);
%     llPart(partCounter3) = ll;
%     trialTypePart(partCounter3,:) = trialType;
% end
% 
% exploit = sum(sum(trialTypePart(:,:) == 1));
% explore = sum(sum(trialTypePart(:,:) == 2));
% 
% 
% %Compare RTs for Win v Losses?
% for rtCounter = 1:length(fileLoc)
%     behData = load(fileLoc(rtCounter).name);   
%     exploreTrial = find(trialTypePart(rtCounter,:) == 2);
%     exploitTrial = find(trialTypePart(rtCounter,:) == 1);
%     exploreWinPer = mean(behData(exploreTrial,6))/(mean(behData(exploreTrial,6))+mean(behData(exploitTrial,6)));
%     exploitWinPer = mean(behData(exploitTrial,6))/(mean(behData(exploitTrial,6))+mean(behData(exploreTrial,6)));
%     exploreRT(rtCounter) = mean(behData(exploreTrial,3));
%     exploitRT(rtCounter) = mean(behData(exploitTrial,3));
% end
% 
% disp(mean(exploreRT));
% disp(mean(exploitRT));
% disp(mean(exploreWinPer));
% disp(mean(exploitWinPer));

%Save Parameters and Trial Type
save('Softmax','softmaxParam')
save('SoftmaxLL.mat','tunedLLs')

%% Win-Stay Lose-Shift Model
clc;clear;close all;
%Set up loading data
addpath('./Behavioural_Data');
fileLoc = dir('./Behavioural_Data/*.txt');


%Parameters for possible solutions?
winStayProb = 0.5; 
loseShiftProb = 0.5;

ArraySize = 10;

%Initialize values
WSLSParam = zeros(length(fileLoc),2);
tunedLLs = zeros(length(fileLoc),1);
xPart = zeros(ArraySize,2);
FVALpart = zeros(ArraySize,1);


for partCounter = 1:length(fileLoc)
    %Load Data
    behData = load(fileLoc(partCounter).name);
    %Tune model
    fun = @(parameters)WinStayLoseShiftUpdate(parameters,behData);
    eps = 0.01;
    
    %Parameter initialization
    winstayProbSet = betarnd(1,1,[ArraySize,1]);%Learning Rate - beta distribution
    loseshiftProbSet = betarnd(1,1,[ArraySize,1]);%Learning Rate - beta distribution
    
    for pCounter = 1:ArraySize
        StartParam = [winstayProbSet(pCounter),loseshiftProbSet(pCounter)];
        %Useing fmincon - try other search?
        [x, FVAL] = fmincon(fun,StartParam,[],[],[],[],[eps eps],[1 1]);
        xPart(pCounter,:) = x;
        FVALpart(pCounter,1) = FVAL;
    end
    
    [minFval,minFloc] = min(FVALpart);
    
    WSLSParam(partCounter,:) = xPart(minFloc,:);
    tunedLLs(partCounter) = minFval;
    
end

% %Compare Reaction Times for Explore vs Exploit
% %Loads up best fit parameters
% for partCounter3 = 1:length(fileLoc)
%     %Load Data
%     behData = load(fileLoc(partCounter3).name);
%     %Run Model with Tuned Parameters
%     [ll,trialType] = WinStayLoseShiftUpdate(WSLSParam(partCounter3,:),behData);
%     llPart(partCounter3) = ll;
%     trialTypePart(partCounter3,:) = trialType;
% end
% 
% exploit = sum(sum(trialTypePart(:,:) == 1));
% explore = sum(sum(trialTypePart(:,:) == 2));
% 
% 
% %Compare RTs for Win v Losses?
% for rtCounter = 1:length(fileLoc)
%     behData = load(fileLoc(rtCounter).name);   
%     exploreTrial = find(trialTypePart(rtCounter,:) == 2);
%     exploitTrial = find(trialTypePart(rtCounter,:) == 1);
%     exploreWinPer = mean(behData(exploreTrial,6))/(mean(behData(exploreTrial,6))+mean(behData(exploitTrial,6)));
%     exploitWinPer = mean(behData(exploitTrial,6))/(mean(behData(exploitTrial,6))+mean(behData(exploreTrial,6)));
%     exploreRT(rtCounter) = mean(behData(exploreTrial,3));
%     exploitRT(rtCounter) = mean(behData(exploitTrial,3));
% end
% 
% disp(mean(exploreRT));
% disp(mean(exploitRT));
% disp(mean(exploreWinPer));
% disp(mean(exploitWinPer));


%Save Parameters and Trial Type
save('WSLS','WSLSParam')
save('WSLSLL.mat','tunedLLs')

%% Manual Optimization  - Currently not working...
optimNumber = 10000;

for partCounter2 = 1:length(fileLoc)
    behData = load(fileLoc(partCounter2).name);
    alpha = 0.01:0.01:1;
    alphaMat = repmat(alpha,1,100);
    epsilon = 0.01:0.01:1;
    epsilonMat = repelem(epsilon,100);
    behParam2 = vertcat(epsilonMat,alphaMat);

    for optimCounter = 1:optimNumber
        [ll,trialType,~,banditValues] = GreedyUpdate(behParam2(:,optimCounter),behData,initialValue,discountFactor);
        llCount(optimCounter) = ll;
        banditValuesPart(optimCounter,:) = banditValues;
    end
    [minllVal,minllLoc] = min(llCount);
    llMi(partCounter2) = minllVal;
    behParamMin(partCounter2,:) = behParam2(:,minllLoc);
    %trialTypePart(partCounter2,:) = trialType;
    
end

%% Model Comparison
clc;clear;close all;
chanceLL = load('ChanceLL.mat');
greedyLL = load('GreedyLL.mat');
softmaxLL = load('SoftmaxLL.mat');
wslsLL = load('WSLSLL.mat');

%Set up parameters
chanceK = 2;
greedyK = 3;
softmaxK = 3;
wslsK = 2;

%AIC
for AICCounter = 1:length(chanceLL.tunedLLs)
    chanceAIC(AICCounter) = -2*chanceLL.tunedLLs(AICCounter) + 2*(chanceK);
    greedyAIC(AICCounter) = -2*greedyLL.tunedLLs(AICCounter) + 2*(greedyK);
    softmaxAIC(AICCounter) = -2*softmaxLL.tunedLLs(AICCounter) + 2*(softmaxK);
    wslsAIC(AICCounter) = -2*wslsLL.tunedLLs(AICCounter) + 2*(wslsK);
end

%Average AIC
meanChanceAIC = mean(chanceAIC);
meanGreedyAIC = mean(greedyAIC);
meanSoftmaxAIC = mean(softmaxAIC);
meanWSLSAIC = mean(wslsAIC);

%BIC
nData = 400;

for BICCounter = 1:length(chanceLL.tunedLLs)
    chanceBIC(BICCounter) = -2*chanceLL.tunedLLs(BICCounter) + chanceK*log(nData);
    greedyBIC(BICCounter) = -2*greedyLL.tunedLLs(BICCounter) + greedyK*log(nData);
    softmaxBIC(BICCounter) = -2*softmaxLL.tunedLLs(BICCounter) + softmaxK*log(nData);
    wslsBIC(BICCounter) = -2*wslsLL.tunedLLs(BICCounter) + wslsK*log(nData);
end

%Average BIC
meanChanceBIC = mean(chanceBIC);
meanGreedyBIC = mean(greedyBIC);
meanSoftmaxBIC = mean(softmaxBIC);
meanWSLSBIC = mean(wslsBIC);

%Re-org Data
%AIC
chanceAIC = chanceAIC';
greedyAIC = greedyAIC';
softmaxAIC = softmaxAIC';
wslsAIC = wslsAIC';
%BIC
chanceBIC = chanceBIC';
greedyBIC = greedyBIC';
softmaxBIC = softmaxBIC';
wslsBIC = wslsBIC';


%Best Fit models - AIC and BIC
AICtotal = horzcat([chanceAIC,greedyAIC,softmaxAIC,wslsAIC]);
BICtotal = horzcat([chanceBIC,greedyBIC,softmaxBIC,wslsBIC]);

%Determine Best Fit Model for each person
bestChanceAIC = 0;
bestGreedyAIC = 0;
bestSoftmaxAIC = 0;
bestWSLSAIC = 0;
bestChanceBIC = 0;
bestGreedyBIC = 0;
bestSoftmaxBIC = 0;
bestWSLSBIC = 0;

%Loop across AIC and BIC values
for counter = 1:length(AICtotal)
    
    [~,minValAIC] = min(AICtotal(counter,:));
    
    if minValAIC == 1
            bestChanceAIC = bestChanceAIC + 1;
    elseif minValAIC == 2
            bestGreedyAIC = bestGreedyAIC + 1;
    elseif minValAIC ==3 
            bestSoftmaxAIC = bestSoftmaxAIC + 1;
    else
            bestWSLSAIC = bestWSLSAIC + 1;
    end
    
        
    [~,minValBIC] = min(BICtotal(counter,:));
    
    if minValBIC == 1
            bestChanceBIC = bestChanceBIC + 1;
    elseif minValBIC == 2
            bestGreedyBIC = bestGreedyBIC + 1;
    elseif minValAIC ==3 
            bestSoftmaxBIC = bestSoftmaxBIC + 1;
    else
            bestWSLSBIC = bestWSLSBIC + 1;
    end   
end

%Plots - Models
%Set up Data
%AIC
chanceAIC(:,2) = .85;
greedyAIC(:,2) = 1.85;
softmaxAIC(:,2) = 2.85;
wslsAIC(:,2) = 3.85;
%BIC
chanceBIC(:,2) = 1.15;
greedyBIC(:,2) = 2.15;
softmaxBIC(:,2) = 3.15;
wslsBIC(:,2) = 4.15;



%Fit values
fitVal = [meanChanceAIC,meanChanceBIC;meanGreedyAIC,meanGreedyBIC;meanSoftmaxAIC,meanSoftmaxBIC;...
    meanWSLSAIC,meanWSLSBIC];
%Colors
purple = [153/255,51/255 255/255];
orange = [255/255,153/255 51/255]; 

%Confidence Intervals
chanceAICCI = 1.96*(std(chanceAIC(:,1))/sqrt(length(chanceLL.tunedLLs)));
chanceBICCI = 1.96*(std(chanceBIC(:,1))/sqrt(length(chanceLL.tunedLLs)));
greedyAICCI = 1.96*(std(greedyAIC(:,1))/sqrt(length(chanceLL.tunedLLs)));
greedyBICCI = 1.96*(std(greedyBIC(:,1))/sqrt(length(chanceLL.tunedLLs)));
softmaxAICCI = 1.96*(std(softmaxAIC(:,1))/sqrt(length(chanceLL.tunedLLs)));
softmaxBICCI = 1.96*(std(softmaxBIC(:,1))/sqrt(length(chanceLL.tunedLLs)));
wslsAICCI = 1.96*(std(wslsAIC(:,1))/sqrt(length(chanceLL.tunedLLs)));
wslsBICCI = 1.96*(std(wslsBIC(:,1))/sqrt(length(chanceLL.tunedLLs)));



xFITCI = [.85,1.15;1.85,2.15;2.85,3.15;3.85,4.15];
yFITCI = fitVal;
FITCI = [chanceAICCI,chanceBICCI;greedyAICCI,greedyBICCI;softmaxAICCI,softmaxBICCI;...
    wslsAICCI,wslsBICCI];

figure
fitAvgs = bar(fitVal,'EdgeColor',[0 0 0],'FaceAlpha',0.3,'FaceColor','flat');
fitAvgs(1,1).CData = purple;
fitAvgs(1,2).CData = orange;
hold on
scatter(chanceAIC(:,2),chanceAIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',purple);
scatter(chanceBIC(:,2),chanceBIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',orange);
scatter(greedyAIC(:,2),greedyAIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',purple);
scatter(greedyBIC(:,2),greedyBIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',orange);
scatter(softmaxAIC(:,2),softmaxAIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',purple);
scatter(softmaxBIC(:,2),softmaxBIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',orange);
scatter(wslsAIC(:,2),wslsAIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',purple);
scatter(wslsBIC(:,2),wslsBIC(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',orange);
e = errorbar(xFITCI,yFITCI,FITCI,'.','MarkerSize',5,'LineWidth',2,'CapSize',15,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);
ylim([2000,5000]);
ylabel('Model Fit (A.U.)');
%yticks([100,150,200,250,300]);
xticks([1,2,3,4]);
xticklabels({'Chance','Greedy','Softmax','WSLS'});
legend({'AIC','BIC'})
legend('boxoff')
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Times';
ax.LineWidth = 1;
ax.Box = 'off';
x_width=8 ;y_width=4;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
print('Model-Comparison','-dtiff','-r300');

%% Bandit Method 1 Figure
clc;clear;close all;
addpath('./Mat files/');
bandits = dir('./Mat files/*.mat');


for counter = 1:3
   load(bandits(counter).name);
   payout{counter,1} = actualPayouts{1,1};
   payout2{counter,1}(1,:) = smooth(payout{counter,1}(1,:));
   payout2{counter,1}(2,:) = smooth(payout{counter,1}(2,:));
   payout2{counter,1}(3,:) = smooth(payout{counter,1}(3,:));
   payout2{counter,1}(4,:) = smooth(payout{counter,1}(4,:));
end

trials = 1:400;


figure;
for figCounter = 1:length(payout)
    subplot(1,3,figCounter);
    plot(trials,payout2{figCounter,1}(1,:),'LineWidth',1,'color',[9/255,255/255,0/255])
    hold on
    plot(trials,payout2{figCounter,1}(2,:),'LineWidth',1,'color',[255/255,43/255,43/255])
    plot(trials,payout2{figCounter,1}(3,:),'LineWidth',1,'color',[0/255,255/255,255/255])
    plot(trials,payout2{figCounter,1}(4,:),'LineWidth',1,'color',[153/255,51/255,255/255])
    xlabel('Trials');
    xticks([0,100,200,300,400]);
    ylim([0,100]);
    yticks([0,25,50,75,100]);
    ylabel('Win Percentage (%)');
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Times';
    ax.LineWidth = 2;
    ax.Box = 'off';
end
labels = {'Bandit 1','Bandit 2','Bandit 3','Bandit 4'};
legend(labels,'Position',[0.75 0.75 0.3 0.1]);
legend('boxoff')
x_width=10 ;y_width=4;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
print('Method-WinPer','-dtiff','-r300');

%% Behavioural Comparison
clc;clear;close all;
addpath('./Behavioural_Data');
behDataComp = dir('./Behavioural_Data/*.txt');

for behCounter = 1:length(behDataComp)
    %Load Data
    partData = load(behDataComp(behCounter).name);
    %Count Wins, Losses, & invalid trials
    winCount(behCounter) = sum(partData(:,6) == 1);
    lossCount(behCounter) = sum(partData(:,6) == 0);
    invalidCount(behCounter) = sum(partData(:,6) == 2);
    %Find Average RT for Wins
    winNum = partData(:,6) == 1;
    winLoc = partData(winNum,:);
    winRT(behCounter) = mean(winLoc(:,3));
    %Find Average RT for Losses
    lossNum = partData(:,6) == 0;
    lossLoc = partData(lossNum,:);
    lossRT(behCounter) = mean(lossLoc(:,3));
    %Bandit Preference
    BanditPref(behCounter,1) = sum(partData(:,5) == 1);
    BanditPref(behCounter,2) = sum(partData(:,5) == 2);
    BanditPref(behCounter,3) = sum(partData(:,5) == 3);
    BanditPref(behCounter,4) = sum(partData(:,5) == 4);

end

%Win Averages
winAvg = mean(winCount);
disp(winAvg);
winCI = 1.96*(std(winCount)/sqrt(length(behDataComp)));
disp(winCI);
%Loss Averages
lossAvg = mean(lossCount);
disp(lossAvg);
lossCI = 1.96*(std(lossCount)/sqrt(length(behDataComp)));
disp(lossCI);
%Invalid Averages
invalidAvg = mean(invalidCount);
disp(invalidAvg);
invalidCI = 1.96*(std(invalidCount)/sqrt(length(behDataComp)));
disp(invalidCI);

%Win RT average
winRTAvg = mean(winRT);
disp(winRTAvg);
winCIRT = 1.96*(std(winRT)/sqrt(length(behDataComp)));
disp(winCIRT);

lossRTAvg = mean(lossRT);
disp(lossRTAvg);
lossCIRT = 1.96*(std(lossRT)/sqrt(length(behDataComp)));
disp(lossCIRT);

%RT Diff
RTdiff = winRT - lossRT;

%Bandit Preference
banditAvg(1) = mean(BanditPref(:,1));
banditAvg(2) = mean(BanditPref(:,2));
banditAvg(3) = mean(BanditPref(:,3));
banditAvg(4) = mean(BanditPref(:,4));
disp(banditAvg);


%Age Averages
Age = [21,20,21,21,23,35,20,21,19,19,19];
disp(mean(Age));
disp(1.96*(std(Age)/sqrt(length(behDataComp))));

%% Model Compared to Behaviour
clc;clear;close all;
addpath('./Mat files/');

%Load Data
matFiles = dir('./Mat files/*.mat');
behFiles = dir('./Behavioural_Data/*.txt');
behFiles = behFiles(1:13);

load('Chance.mat');
load('Greedy.mat');
load('Softmax.mat');
load('WSLS.mat');

initialValue = 0.5;

for behCounter = 1:length(matFiles)
    behData = load(matFiles(behCounter).name);
    behWin = behData.actualPayouts{1,1};
    %Chance
    [llChance,ArmSelected,banditValuesChance,win] = ChanceWinPer(chanceParam(behCounter,:),behWin,initialValue);
    ArmSelectedPartChance(behCounter,:) = ArmSelected;
    WinPartChance(behCounter,:) = win;
    %Greedy
    [llGreedy,ArmSelected,banditValuesGreedy,win] = GreedyWinPer(greedyParam(behCounter,:),behWin,initialValue);
    ArmSelectedPartGreedy(behCounter,:) = ArmSelected;
    WinPartGreedy(behCounter,:) = win;
    %SoftMax
    [llSoftmax,ArmSelected,banditValuesSoftmax,win] = SoftmaxWinPer(softmaxParam(behCounter,:),behWin,initialValue);
    ArmSelectedPartSoftmax(behCounter,:) = ArmSelected;
    WinPartSoftmax(behCounter,:) = win;
    %WSLS
    [llWSLS,ArmSelected,win] = WinStayLoseShiftWinPer(WSLSParam(behCounter,:),behWin);
    ArmSelectedPartWSLS(behCounter,:) = ArmSelected;
    WinPartWSLS(behCounter,:) = win;
end

%Compare WinPercentage

for behCounter3 = 1:length(behFiles)
    behData2 = load(behFiles(behCounter3).name);
    behavWin(behCounter3,:) = sum(behData2(:,6) == 1);
    behavLoss(behCounter3,:) = sum(behData2(:,6) == 0);
    chanceWin(behCounter3,:) = sum(WinPartChance(behCounter3,:) == 1);
    chanceLoss(behCounter3,:) = sum(WinPartChance(behCounter3,:) == 0);
    greedyWin(behCounter3,:) = sum(WinPartGreedy(behCounter3,:) == 1);
    greedyLoss(behCounter3,:) = sum(WinPartGreedy(behCounter3,:) == 0);
    softmaxWin(behCounter3,:) = sum(WinPartSoftmax(behCounter3,:) == 1);
    softmaxLoss(behCounter3,:) = sum(WinPartSoftmax(behCounter3,:) == 0);
    WSLSWin(behCounter3,:) = sum(WinPartWSLS(behCounter3,:) == 1);
    WSLSLoss(behCounter3,:) = sum(WinPartWSLS(behCounter3,:) == 0);
    %Arm Selected
    ArmSelectBeh(behCounter3,:) = behData2(:,5);
end

%Figure for probWin/probLoss
behavWinAvg = mean(behavWin);
behavLossAvg = mean(behavLoss);
ChanceWinAvg = mean(chanceWin);
ChanceLossAvg = mean(chanceLoss);
GreedylWinAvg = mean(greedyWin);
GreedyLossAvg = mean(greedyLoss);
SoftmaxWinAvg = mean(softmaxWin);
SoftmaxLossAvg = mean(softmaxLoss);
WSLSWinAvg = mean(WSLSWin);
WSLSLossAvg = mean(WSLSLoss);

%Positions for plotting
behavWin(:,2) = 0.85;
behavLoss(:,2) = 1.15;
chanceWin(:,2) = 1.85;
chanceLoss(:,2) = 2.15;
greedyWin(:,2) = 2.85;
greedyLoss(:,2) = 3.15;
softmaxWin(:,2) = 3.85;
softmaxLoss(:,2) = 4.15;
WSLSWin(:,2) = 4.85;
WSLSLoss(:,2) = 5.15;

%Model Values
modelVal = [behavWinAvg,behavLossAvg;ChanceWinAvg,ChanceLossAvg;...
    GreedylWinAvg,GreedyLossAvg;SoftmaxWinAvg,SoftmaxLossAvg;WSLSWinAvg,WSLSLossAvg];
%categories = [1,2,3,4];

%Confidence Intervals
behwinCI = 1.96*(std(behavWin(:,1))/sqrt(length(behFiles)));
behlossCI = 1.96*(std(behavLoss(:,1))/sqrt(length(behFiles)));
chancewinCI = 1.96*(std(chanceWin(:,1))/sqrt(length(behFiles)));
chancelossCI = 1.96*(std(chanceLoss(:,1))/sqrt(length(behFiles)));
greedywinCI = 1.96*(std(greedyWin(:,1))/sqrt(length(behFiles)));
greedylossCI = 1.96*(std(greedyLoss(:,1))/sqrt(length(behFiles)));
softmaxwinCI = 1.96*(std(softmaxWin(:,1))/sqrt(length(behFiles)));
softmaxlossCI = 1.96*(std(softmaxLoss(:,1))/sqrt(length(behFiles)));
WSLSwinCI = 1.96*(std(WSLSWin(:,1))/sqrt(length(behFiles)));
WSLSlossCI = 1.96*(std(WSLSLoss(:,1))/sqrt(length(behFiles)));



xCI = [.85,1.15;1.85,2.15;2.85,3.15;3.85,4.15;4.85,5.15];
yCI = modelVal;
CI = [behwinCI,behlossCI;chancewinCI,chancelossCI;greedywinCI,greedylossCI;...
    softmaxwinCI,softmaxlossCI;WSLSwinCI,WSLSlossCI];




%Colors
blue = [102/255,178/255 255/255];
red = [255/255,153/255 153/255]; 

figure
b = bar(modelVal,'EdgeColor',[0 0 0],'FaceAlpha',0.3,'FaceColor','flat');
hold on
scatter(behavWin(:,2),behavWin(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(behavLoss(:,2),behavLoss(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(chanceWin(:,2),chanceWin(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(chanceLoss(:,2),chanceLoss(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(greedyWin(:,2),greedyWin(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(greedyLoss(:,2),greedyLoss(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(softmaxWin(:,2),softmaxWin(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(softmaxLoss(:,2),softmaxLoss(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(WSLSWin(:,2),WSLSWin(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(WSLSLoss(:,2),WSLSLoss(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
e = errorbar(xCI,yCI,CI,'.','MarkerSize',5,'LineWidth',2,'CapSize',15,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);
ylim([100,300]);
ylabel('Trial Count (n)');
yticks([100,150,200,250,300]);
xticks([1,2,3,4,5]);
xticklabels({'Behavioural','Chance','Greedy','Softmax','WSLS'});
legend({'Win','Loss'})
legend('boxoff')
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Times';
ax.LineWidth = 1;
ax.Box = 'off';
x_width=8 ;y_width=4;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
print('ModelBeh-Win','-dtiff','-r300');

% Trial to Trial Stay vs Switch - Probability Win-Stay?

%Load Behavioural Data
for behCounter4 = 1:length(behFiles)
    behData4 =  load(behFiles(behCounter4).name);
    behWin(behCounter4,:) = behData4(:,6)';
end

%Select Participants
Part = [5,12,13];
partBehWins = behWin(Part,:);
partBehArms = ArmSelectBeh(Part,:);
partChanceWins = WinPartChance(Part,:);
partChanceArms = ArmSelectedPartChance(Part,:);
partGreedyWins = WinPartGreedy(Part,:);
partGreedyArms = ArmSelectedPartGreedy(Part,:);
partSoftmaxWins = WinPartSoftmax(Part,:);
partSoftmaxArms = ArmSelectedPartSoftmax(Part,:);
partWSLSWins = WinPartWSLS(Part,:);
partWSLSArms = ArmSelectedPartWSLS(Part,:);


for counter = 1:3
    %Behavioural Data
    partbeh = partBehWins(counter,:);
    partbehArm = partBehArms(counter,:);
    [probWinBeh,probLossBeh] = winstayProb(partbehArm,partbeh);
    %Chance Model
    partChance = partChanceWins(counter,:);
    partChanceArm = partChanceArms(counter,:);
    [probWinChance,probLossChance] = winstayProb(partChanceArm,partChance);
    %Greedy Model
    partGreedy = partGreedyWins(counter,:);
    partGreedyArm = partGreedyArms(counter,:);
    [probWinGreedy,probLossGreedy] = winstayProb(partGreedyArm,partGreedy);
    %Softmax Model
    partSoftmax = partSoftmaxWins(counter,:);
    partSoftmaxArm = partSoftmaxArms(counter,:);
    [probWinSoftmax,probLossSoftmax] = winstayProb(partSoftmaxArm,partSoftmax);
    %WSLS Model
    partWSLS = partWSLSWins(counter,:);
    partWSLSArm = partWSLSArms(counter,:);
    [probWinWSLS,probLossWSLS] = winstayProb(partWSLSArm,partWSLS);
    
    %Load for plotting
    probWinbehSum(counter,:) = probWinBeh;
    probLossbehSum(counter,:) = probLossBeh;
    probWinChanceSum(counter,:) = probWinChance;
    probLossChanceSum(counter,:) = probLossChance;
    probWinGreedySum(counter,:) = probWinGreedy;
    probLossGreedySum(counter,:) = probLossGreedy;
    probWinSoftmaxSum(counter,:) = probWinSoftmax;
    probLossSoftmaxSum(counter,:) = probLossSoftmax;
    probWinWSLSSum(counter,:) = probWinWSLS;
    probLossWSLSSum(counter,:) = probLossWSLS;
end



%Create Trial Array
trials = 1:1:400;

%Plot WinStay vs LoseShift Prob
figure
for plotCounter = 1:3
    %Plot Actual Figures
    subplot(3,5,plotCounter);
    hold on
    plot(trials,probWinbehSum(plotCounter,:),'color',blue,'LineWidth',1.5)
    plot(trials,probLossbehSum(plotCounter,:),'color',red,'LineWidth',1.5)
    ylabel('Probability');
    xlabel('Trials');
    yticks([0,.25,.5,.75,1]);
    xticks([0,100,200,300,400]);
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Times';
    ax.LineWidth = 1;
    ax.Box = 'off';
    subplot(3,5,plotCounter+3);
    hold on
    plot(trials,probWinChanceSum(plotCounter,:),'color',blue,'LineWidth',1.5)
    plot(trials,probLossChanceSum(plotCounter,:),'color',red,'LineWidth',1.5)
    ylabel('Probability');
    xlabel('Trials');
    yticks([0,.25,.5,.75,1]);
    xticks([0,100,200,300,400]);
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Times';
    ax.LineWidth = 1;
    ax.Box = 'off';
    subplot(3,5,plotCounter+6);
    hold on
    plot(trials,probWinGreedySum(plotCounter,:),'color',blue,'LineWidth',1.5)
    plot(trials,probLossGreedySum(plotCounter,:),'color',red,'LineWidth',1.5)
    ylabel('Probability');
    xlabel('Trials');
    yticks([0,.25,.5,.75,1]);
    xticks([0,100,200,300,400]);
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Times';
    ax.LineWidth = 1;
    ax.Box = 'off';
    subplot(3,5,plotCounter+9);
    hold on
    plot(trials,probWinSoftmaxSum(plotCounter,:),'color',blue,'LineWidth',1.5)
    plot(trials,probLossSoftmaxSum(plotCounter,:),'color',red,'LineWidth',1.5)
    ylabel('Probability');
    xlabel('Trials');
    yticks([0,.25,.5,.75,1]);
    xticks([0,100,200,300,400]);
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Times';
    ax.LineWidth = 1;
    ax.Box = 'off';
    subplot(3,5,plotCounter+12);
    hold on
    plot(trials,probWinWSLSSum(plotCounter,:),'color',blue,'LineWidth',1.5)
    plot(trials,probLossWSLSSum(plotCounter,:),'color',red,'LineWidth',1.5)
    ylabel('Probability');
    xlabel('Trials');
    yticks([0,.25,.5,.75,1]);
    xticks([0,100,200,300,400]);
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Times';
    ax.LineWidth = 1;
    ax.Box = 'off';
end
legend({'Win Stay','Loss Shift'},'Position',[.88 .90 .1 0.1])
legend('boxoff')
x_width=12 ;y_width=6;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
print('Model-WinStayProb','-dtiff','-r300');

%% Fake Data - Parameter Recovery??

%% Explore-Exploit 
clc;clear;close all;

%Load Data
behFiles = dir('./Behavioural_Data/*.txt');

load('Chance.mat');
load('Greedy.mat');
load('Softmax.mat');
load('WSLS.mat');

initialValue = 0.5;

%Compare Reaction Times for Explore vs Exploit
%Loads up best fit parameters
for partCounter3 = 1:length(behFiles)
    %Load Data
    behData = load(behFiles(partCounter3).name);
    %Chance Model
    [~,trialTypeChance,~,~] = ChanceUpdate(chanceParam(partCounter3,:),behData,initialValue);
    trialTypePartChance(partCounter3,:) = trialTypeChance;
    %Greedy Model
    [~,trialTypeGreedy,~,~] = SoftmaxUpdate(greedyParam(partCounter3,:),behData,initialValue);
    trialTypePartGreedy(partCounter3,:) = trialTypeGreedy;
    %Softmax Model
    [~,trialTypeSoftmax,~,~] = SoftmaxUpdate(softmaxParam(partCounter3,:),behData,initialValue);
    trialTypePartSoftmax(partCounter3,:) = trialTypeSoftmax;
    %WSLS Model
    [~,trialTypeWSLS] = WinStayLoseShiftUpdate(WSLSParam(partCounter3,:),behData);
    trialTypePartWSLS(partCounter3,:) = trialTypeWSLS;
end

exploitChance = sum(sum(trialTypePartChance(:,:) == 1));
exploreChance = sum(sum(trialTypePartChance(:,:) == 2));
exploitGreedy = sum(sum(trialTypePartGreedy(:,:) == 1));
exploreGreedy = sum(sum(trialTypePartGreedy(:,:) == 2));
exploitSoftmax = sum(sum(trialTypePartSoftmax(:,:) == 1));
exploreSoftmax = sum(sum(trialTypePartSoftmax(:,:) == 2));
exploitWSLS = sum(sum(trialTypePartWSLS(:,:) == 1));
exploreWSLS = sum(sum(trialTypePartWSLS(:,:) == 2));

%Compare RTs for Win v Losses?
for rtCounter = 1:length(behFiles)
    behData = load(behFiles(rtCounter).name);   
    %Chance
    exploreTrialChance = find(trialTypePartChance(rtCounter,:) == 2);
    exploitTrialChance = find(trialTypePartChance(rtCounter,:) == 1);
    exploreChance(rtCounter,1) = mean(behData(exploreTrialChance,6))/(mean(behData(exploreTrialChance,6))+mean(behData(exploitTrialChance,6)));
    exploitChance(rtCounter,1) = mean(behData(exploitTrialChance,6))/(mean(behData(exploitTrialChance,6))+mean(behData(exploreTrialChance,6)));
    exploreRTChance(rtCounter,1) = mean(behData(exploreTrialChance,3));
    exploitRTChance(rtCounter,1) = mean(behData(exploitTrialChance,3));
    %Greedy
    exploreTrialGreedy = find(trialTypePartGreedy(rtCounter,:) == 2);
    exploitTrialGreedy = find(trialTypePartGreedy(rtCounter,:) == 1);
    exploreWinPerGreedy(rtCounter,1) = mean(behData(exploreTrialGreedy,6))/(mean(behData(exploreTrialGreedy,6))+mean(behData(exploitTrialGreedy,6)));
    exploitWinPerGreedy(rtCounter,1) = mean(behData(exploitTrialGreedy,6))/(mean(behData(exploitTrialGreedy,6))+mean(behData(exploreTrialGreedy,6)));
    exploreRTGreedy(rtCounter,1) = mean(behData(exploreTrialGreedy,3));
    exploitRTGreedy(rtCounter,1) = mean(behData(exploitTrialGreedy,3));
    %Softmax
    exploreTrialSoftmax = find(trialTypePartSoftmax(rtCounter,:) == 2);
    exploitTrialSoftmax = find(trialTypePartSoftmax(rtCounter,:) == 1);
    exploreWinPerSoftmax(rtCounter,1) = mean(behData(exploreTrialSoftmax,6))/(mean(behData(exploreTrialSoftmax,6))+mean(behData(exploitTrialSoftmax,6)));
    exploitWinPerSoftmax(rtCounter,1) = mean(behData(exploitTrialSoftmax,6))/(mean(behData(exploitTrialSoftmax,6))+mean(behData(exploreTrialSoftmax,6)));
    exploreRTSoftmax(rtCounter,1) = mean(behData(exploreTrialSoftmax,3));
    exploitRTSoftmax(rtCounter,1) = mean(behData(exploitTrialSoftmax,3));
    %WSLS
    exploreTrialWSLS = find(trialTypePartWSLS(rtCounter,:) == 2);
    exploitTrialWSLS = find(trialTypePartWSLS(rtCounter,:) == 1);
    exploreWinPerWSLS(rtCounter,1) = mean(behData(exploreTrialWSLS,6))/(mean(behData(exploreTrialWSLS,6))+mean(behData(exploitTrialWSLS,6)));
    exploitWinPerWSLS(rtCounter,1) = mean(behData(exploitTrialWSLS,6))/(mean(behData(exploitTrialWSLS,6))+mean(behData(exploreTrialWSLS,6)));
    exploreRTWSLS(rtCounter,1) = mean(behData(exploreTrialWSLS,3));
    exploitRTWSLS(rtCounter,1) = mean(behData(exploitTrialWSLS,3));
end


%Compute Means
exploitRTChanceMean = mean(exploitRTChance);
exploreRTChanceMean = mean(exploreRTChance);
exploitRTGreedyMean = mean(exploitRTGreedy);
exploreRTGreedyMean = mean(exploreRTGreedy);
exploitRTSoftmaxMean = mean(exploitRTSoftmax);
exploreRTSoftmaxMean = mean(exploreRTSoftmax);
exploitRTWSLSMean = mean(exploitRTWSLS);
exploreRTWSLSMean = mean(exploreRTWSLS);
EEVal = [exploitRTChanceMean,exploreRTChanceMean;exploitRTGreedyMean,exploreRTGreedyMean;...
    exploitRTSoftmaxMean,exploreRTSoftmaxMean;exploitRTWSLSMean,exploreRTWSLSMean];

%Plot
%Plots - Models
%Set up Data
%AIC
exploitRTChance(:,2) = .85;
exploitRTGreedy(:,2) = 1.85;
exploitRTSoftmax(:,2) = 2.85;
exploitRTWSLS(:,2) = 3.85;
%BIC
exploreRTChance(:,2) = 1.15;
exploreRTGreedy(:,2) = 2.15;
exploreRTSoftmax(:,2) = 3.15;
exploreRTWSLS(:,2) = 4.15;



%Colors
blue = [102/255,178/255 255/255];
red = [255/255,153/255 153/255]; 

%Confidence Intervals
chanceExploitCI = 1.96*(std(exploreRTChance(:,1))/sqrt(length(behFiles)));
chanceExploreCI = 1.96*(std(exploitRTChance(:,1))/sqrt(length(behFiles)));
greedyExploitCI = 1.96*(std(exploitRTGreedy(:,1))/sqrt(length(behFiles)));
greedyExploreCI = 1.96*(std(exploreRTGreedy(:,1))/sqrt(length(behFiles)));
softmaxExploitCI = 1.96*(std(exploitRTSoftmax(:,1))/sqrt(length(behFiles)));
softmaxExploreCI = 1.96*(std(exploreRTSoftmax(:,1))/sqrt(length(behFiles)));
wslsExploitCI = 1.96*(std(exploitRTWSLS(:,1))/sqrt(length(behFiles)));
wslsExploreCI = 1.96*(std(exploreRTWSLS(:,1))/sqrt(length(behFiles)));


xEECI = [.85,1.15;1.85,2.15;2.85,3.15;3.85,4.15];
yEECI = EEVal;
EECI = [chanceExploitCI,chanceExploreCI;greedyExploitCI,greedyExploreCI;softmaxExploitCI,softmaxExploreCI;...
    wslsExploitCI,wslsExploreCI];

figure
fitAvgs = bar(EEVal,'EdgeColor',[0 0 0],'FaceAlpha',0.3,'FaceColor','flat');
fitAvgs(1,1).CData = blue;
fitAvgs(1,2).CData = red;
hold on
scatter(exploitRTChance(:,2),exploitRTChance(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreRTChance(:,2),exploreRTChance(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(exploitRTGreedy(:,2),exploitRTGreedy(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreRTGreedy(:,2),exploreRTGreedy(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(exploitRTSoftmax(:,2),exploitRTSoftmax(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreRTSoftmax(:,2),exploreRTSoftmax(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(exploitRTWSLS(:,2),exploitRTWSLS(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreRTWSLS(:,2),exploreRTWSLS(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
errorbar(xEECI,yEECI,EECI,'.','MarkerSize',5,'LineWidth',2,'CapSize',15,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);
ylim([0,1]);
ylabel('Reaction Time (ms)');
yticks([0,0.25,0.5,0.75,1]);
yticklabels({'0','250','500','750','1000'});
xticks([1,2,3,4]);
xticklabels({'Chance','Greedy','Softmax','WSLS'});
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Times';
ax.LineWidth = 1;
ax.Box = 'off';
x_width=5 ;y_width=3;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
print('Explore-Exploit RT','-dtiff','-r300');


%% Plot Win and Losses for EE

%Compute Means
exploitWPChanceMean = mean(exploitChance);
exploreWPChanceMean = mean(exploreChance);
exploitWPGreedyMean = mean(exploitWinPerGreedy);
exploreWPGreedyMean = mean(exploreWinPerGreedy);
exploitWPSoftmaxMean = mean(exploitWinPerSoftmax);
exploreWPSoftmaxMean = mean(exploreWinPerSoftmax);
exploitWPWSLSMean = mean(exploitWinPerWSLS);
exploreWPWSLSMean = mean(exploreWinPerWSLS);
EEWPVal = [exploitWPChanceMean,exploreWPChanceMean;exploitWPGreedyMean,exploreWPGreedyMean;...
    exploitWPSoftmaxMean,exploreWPSoftmaxMean;exploitWPWSLSMean,exploreWPWSLSMean];

%Plot
%Plots - Models
%Set up Data
%AIC
exploitChance(:,2) = .85;
exploitWinPerGreedy(:,2) = 1.85;
exploitWinPerSoftmax(:,2) = 2.85;
exploitWinPerWSLS(:,2) = 3.85;
%BIC
exploreChance(:,2) = 1.15;
exploreWinPerGreedy(:,2) = 2.15;
exploreWinPerSoftmax(:,2) = 3.15;
exploreWinPerWSLS(:,2) = 4.15;



%Colors
blue = [102/255,178/255 255/255];
red = [255/255,153/255 153/255]; 

%Confidence Intervals - this needs to be FIXED!
chanceExploitWPCI = 1.96*(std(exploreChance(:,1))/sqrt(length(behFiles)));
chanceExploreWPCI = 1.96*(std(exploitChance(:,1))/sqrt(length(behFiles)));
greedyExploitWPCI = 1.96*(std(exploitWinPerGreedy(:,1))/sqrt(length(behFiles)));
greedyExploreWPCI = 1.96*(std(exploreWinPerGreedy(:,1))/sqrt(length(behFiles)));
softmaxExploitWPCI = 1.96*(std(exploitWinPerSoftmax(:,1))/sqrt(length(behFiles)));
softmaxExploreWPCI = 1.96*(std(exploreWinPerSoftmax(:,1))/sqrt(length(behFiles)));
wslsExploitWPCI = 1.96*(std(exploitWinPerWSLS(:,1))/sqrt(length(behFiles)));
wslsExploreWPCI = 1.96*(std(exploreWinPerWSLS(:,1))/sqrt(length(behFiles)));


xEEWPCI = [.85,1.15;1.85,2.15;2.85,3.15;3.85,4.15];
yEEWPCI = EEWPVal;
EEWPCI = [chanceExploitWPCI,chanceExploreWPCI;greedyExploitWPCI,greedyExploreWPCI;softmaxExploitWPCI,softmaxExploreWPCI;...
    wslsExploitWPCI,wslsExploreWPCI];

figure
fitAvgs = bar(EEWPVal,'EdgeColor',[0 0 0],'FaceAlpha',0.3,'FaceColor','flat');
fitAvgs(1,1).CData = blue;
fitAvgs(1,2).CData = red;
hold on
scatter(exploitChance(:,2),exploitChance(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreChance(:,2),exploreChance(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(exploitWinPerGreedy(:,2),exploitWinPerGreedy(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreWinPerGreedy(:,2),exploreWinPerGreedy(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(exploitWinPerSoftmax(:,2),exploitWinPerSoftmax(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreWinPerSoftmax(:,2),exploreWinPerSoftmax(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
scatter(exploitWinPerWSLS(:,2),exploitWinPerWSLS(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',blue);
scatter(exploreWinPerWSLS(:,2),exploreWinPerWSLS(:,1),'jitter', 'on', 'jitterAmount', 0.1,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',red);
errorbar(xEEWPCI,yEEWPCI,EEWPCI,'.','MarkerSize',5,'LineWidth',2,'CapSize',15,...
    'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'Color',[0 0 0]);
ylim([0,1]);
ylabel('Win Percentage');
yticks([0,0.25,0.5,0.75,1]);
yticklabels({'0','25','50','75','100'});
xticks([1,2,3,4]);
xticklabels({'Chance','Greedy','Softmax','WSLS'});
legend({'Exploit','Explore'});
legend('boxoff')
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Times';
ax.LineWidth = 1;
ax.Box = 'off';
x_width=5 ;y_width=3;
set(gcf, 'PaperPosition', [0 0 x_width y_width]);
print('Explore-Exploit WP','-dtiff','-r300');

%% Compare Explore vs Exploit Trials Overlap


chance1 = sum(sum((trialTypePartChance == trialTypePartGreedy)));
chance2 = sum(sum((trialTypePartChance == trialTypePartSoftmax)));
chance3 = sum(sum((trialTypePartChance == trialTypePartWSLS)));
Greedy1 = sum(sum((trialTypePartGreedy == trialTypePartSoftmax)));
Greedy2 = sum(sum((trialTypePartGreedy == trialTypePartWSLS)));
Softmax1 = sum(sum((trialTypePartSoftmax == trialTypePartWSLS)));

totalTrials = 13*400;

chanceGreedy = chance1/totalTrials;
chanceSoftmax = chance2/totalTrials;
chanceWSLS = chance3/totalTrials;
greedySoftmax = Greedy1/totalTrials;
greedyWSLS = Greedy2/totalTrials;
softmaxWSLS = Softmax1/totalTrials;

%% Compare Stress to Control
control_p = [2,4,5,7,9,10,11,15,20,21,22,23,24,25];
stress_p = [1,3,6,8,12,13,14,16,17,19,26];

%Softmax
disp(mean(softmaxParam(control_p,1)));
disp(mean(softmaxParam(control_p,2)));
disp(mean(softmaxParam(stress_p,1)));
disp(mean(softmaxParam(stress_p,2)));

%WSLS
disp(mean(WSLSParam(control_p,1)));
disp(mean(WSLSParam(stress_p,1)));
disp(mean(WSLSParam(control_p,2)));
disp(mean(WSLSParam(stress_p,2)));