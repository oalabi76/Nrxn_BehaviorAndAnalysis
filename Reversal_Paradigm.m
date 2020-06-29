function Reversal Paradigm
global BpodSystem

%% Global Setup
MaxTrials = 750;
StartTime = tic;
elapsedTime = 0;
moving_window = zeros(1,10);
block_type = ceil(rand(1)*2);
block_number = 1;
block_trial = 1;
block_fudge = randi([0,0],1,100);

%% Define parameters
S = BpodSystem.ProtocolSettings; 
if isempty(fieldnames(S)) 
    S.GUI.RewardAmountLarge = 12;  %ul
    S.GUI.RewardAmountSmall = 0;   %ul
    S.GUI.RewardRatio = 120;
    S.GUI.LeftDelay = 0;
    S.GUI.RightDelay = 0;
    S.GUI.Probability = .75;
    S.GUI.ITI = 1; %length of intertrial interval
    S.GUI.Choice = 5;
    S.GUI.RewardPeriod = 3; %length of reward period
    S.GUI.Omission = 2;
    S.GUI.MaximumReward = 2000;
    S.GUI.SessionTime = 3600;
end

BpodParameterGUI('init', S);

%% Define trials and initial block type
BpodSystem.Data.TrialTypes = {}; % The trial type of each trial completed will be added here.
BpodSystem.Data.BlockLength = [];
BpodSystem.Data.DeltaSlope = [];
BpodSystem.Data.Choice = [];
BpodSystem.Data.BlockType = [];
BpodSystem.Data.Reward = [];

if block_type == 1
    BpodSystem.Data.FirstBlock = 'right';
else
    BpodSystem.Data.FirstBlock = 'left';
end
%% Main trial loop
for currentTrial = 1:MaxTrials
    
    S = BpodParameterGUI('sync', S); 
    Rsmall = GetValveTimes(S.GUI.RewardAmountSmall, [1 3]); LVT_Small = Rsmall(1); RVT_Small = Rsmall(2); % Update reward amounts
    if S.GUI.RewardAmountSmall == 0
       LVT_Small = 0;
       RVT_Small = 0;
    end
    Rlarge = GetValveTimes(S.GUI.RewardAmountLarge, [1 3]); LVT_Large = Rlarge(1); RVT_Large = Rlarge(2);
    index = (rand(1) <= S.GUI.Probability);
    
    LeftAction = 'LeftReward'; RightAction = 'RightReward'; 
    ChoiceOutput = {'LED', 1, 'LED', 3};
    LeftReward = {'LED', 1, 'Valve', 1}; 
    RightReward = {'LED', 3, 'Valve', 3};
    %%Block Type 1 - Large Reward on the Right
    %%Block Type 2 - Large Reward on the Left
            if block_type == 1
                TrialType = 1;
                if index == 1
                LeftValveTime = LVT_Small;
                RightValveTime = RVT_Large;
                else
                LeftValveTime = 0;
                RightValveTime = 0;                
                end
            else
                TrialType = 0;
                if index == 1
                LeftValveTime = LVT_Large;                
                RightValveTime = RVT_Small;
                else
                LeftValveTime = 0;
                RightValveTime = 0;                
                end
            end
            
     sma = NewStateMatrix(); % Assemble state matrix
    
     sma = AddState(sma, 'Name', 'ITI', ...
        'Timer', S.GUI.ITI,...
        'StateChangeConditions', {'Tup', 'Check2'},...
        'OutputActions', {});
       
     sma = SetCondition(sma, 1, 'Port1', 0);
     sma = SetCondition(sma, 2, 'Port2', 0);
     sma = SetCondition(sma, 3, 'Port3', 0);
     
    sma = AddState(sma, 'Name', 'Check2', ...
        'Timer', 0,...
        'StateChangeConditions', {'Condition2', 'Initiation'},...
        'OutputActions', {});     
    
     sma = AddState(sma, 'Name', 'Initiation', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port2In', 'Initiation_Sustain'},...
        'OutputActions', {'LED', 2});
    
     sma = AddState(sma, 'Name', 'Initiation_Sustain', ...
        'Timer',  0,...
        'StateChangeConditions', {'Port2Out', 'Choice'},...
        'OutputActions', ChoiceOutput);
    
   sma = AddState(sma, 'Name', 'Choice', ...
        'Timer', S.GUI.Choice,...
        'StateChangeConditions', {'Port1In', 'LeftDelay', 'Port3In', 'RightDelay','Tup', 'Omission'},...
        'OutputActions', ChoiceOutput);
    
     sma = AddState(sma, 'Name', 'LeftDelay', ...
        'Timer', S.GUI.LeftDelay,...
        'StateChangeConditions', {'Tup', LeftAction},...
        'OutputActions', {'LED', 1}); 
    
    sma = AddState(sma, 'Name', 'RightDelay', ...
        'Timer', S.GUI.RightDelay,...
        'StateChangeConditions', {'Tup', RightAction},...
        'OutputActions', {'LED', 3}); 
    
     sma = AddState(sma, 'Name', 'LeftReward', ...
        'Timer', LeftValveTime,...
        'StateChangeConditions', {'Tup', 'ConsumptionLeft'},...
        'OutputActions', LeftReward); 
    
     sma = AddState(sma, 'Name', 'RightReward', ...
        'Timer', RightValveTime,...
        'StateChangeConditions', {'Tup', 'ConsumptionRight'},...
        'OutputActions', RightReward); 
    
     sma = AddState(sma, 'Name', 'Omission', ...
        'Timer', S.GUI.Omission,...
        'StateChangeConditions', {'Tup', 'ITI'},...
        'OutputActions', {}); 

     sma = AddState(sma, 'Name', 'ConsumptionLeft', ...
        'Timer', S.GUI.RewardPeriod,...
        'StateChangeConditions', {'Tup', 'ConfirmExitLeft'},...
        'OutputActions', {'LED', 1}); 
    
     sma = AddState(sma, 'Name', 'ConsumptionRight', ...
        'Timer', S.GUI.RewardPeriod,...
        'StateChangeConditions', {'Tup', 'ConfirmExitRight'},...
        'OutputActions', {'LED', 3}); 
    
     sma = AddState(sma, 'Name', 'ConfirmExitLeft', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1Out', 'exit', 'Port3Out', 'exit', 'Port2Out', 'exit', 'Condition1', 'ConfirmRightOut'},...
        'OutputActions', {}); 
    
     sma = AddState(sma, 'Name', 'ConfirmRightOut', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1Out', 'exit', 'Port3Out', 'exit', 'Port2Out', 'exit', 'Condition3', 'ConfirmCenterOut'},...
        'OutputActions', {}); 
    
     sma = AddState(sma, 'Name', 'ConfirmExitRight', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1Out', 'exit', 'Port3Out', 'exit', 'Port2Out', 'exit', 'Condition3', 'ConfirmLeftOut'},...
        'OutputActions', {}); 
    
     sma = AddState(sma, 'Name', 'ConfirmLeftOut', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1Out', 'exit', 'Port3Out', 'exit', 'Port2Out', 'exit', 'Condition1', 'ConfirmCenterOut'},...
        'OutputActions', {}); 
    
     sma = AddState(sma, 'Name', 'ConfirmCenterOut', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port1Out', 'exit', 'Port3Out', 'exit', 'Port2Out', 'exit', 'Condition2', 'exit'},...
        'OutputActions', {}); 
 
    SendStateMatrix(sma);
    RawEvents = RunStateMatrix;
    
    %%%   
    if ~isempty(fieldnames(RawEvents)) % If trial data was returned
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); % Computes trial events from raw data
        BpodSystem.Data.TrialSettings(currentTrial) = S; % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
        BpodSystem.Data.MinimumBlockLength(block_number)= 10 + block_fudge(block_number);
        BpodSystem.Data.LeftDelay(currentTrial) = S.GUI.LeftDelay;
        BpodSystem.Data.RightDelay(currentTrial) = S.GUI.RightDelay;
        if TrialType == 1
            BpodSystem.Data.TrialTypes{currentTrial} = 'right'; % Adds the trial type of the current trial to data
            BpodSystem.Data.BlockType(block_number) = 1;
        else
            BpodSystem.Data.TrialTypes{currentTrial} = 'left'; % Adds the trial type of the current trial to data
            BpodSystem.Data.BlockType(block_number) = -1;
        end
        BpodSystem.Data.RawEvents.Trial{currentTrial}.LatInit = BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Initiation(:,2) - BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Initiation(:,1);
        BpodSystem.Data.RawEvents.Trial{currentTrial}.LatChoi = BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Choice(:,2) - BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Choice(:,1);
        BpodSystem.Data.RawEvents.Trial{currentTrial}.InitSus = BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Initiation_Sustain(:,2) - BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Initiation_Sustain(:,1);
        %%%
        if ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Omission(1))
            BpodSystem.Data.RawEvents.Trial{currentTrial}.Omission = length(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.Omission(:,1));
        else
            BpodSystem.Data.RawEvents.Trial{currentTrial}.Omission = 0;
        end
        %%%
        %%%
        BpodSystem.Data.LatInit{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.LatInit(end);
        BpodSystem.Data.LatChoi{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.LatChoi(end);
        BpodSystem.Data.InitSus{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.InitSus(end); 
        BpodSystem.Data.Omission{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.Omission;
        %%%
        %%%
        BpodSystem.Data.RawEvents.Trial{currentTrial}.BlockType = BpodSystem.Data.TrialTypes(currentTrial);
        BpodSystem.Data.RawEvents.Trial{currentTrial}.BlockNumber = block_number;
        BpodSystem.Data.RawEvents.Trial{currentTrial}.BlockTrial = block_trial ;
        BpodSystem.Data.RawEvents.Trial{currentTrial}.RewardProbability = S.GUI.Probability;
        BpodSystem.Data.RawEvents.Trial{currentTrial}.RewardRatio = S.GUI.RewardRatio;
        %%%
        %%%
        BpodSystem.Data.BlockNumber{currentTrial} = block_number;
        BpodSystem.Data.BlockTrial{currentTrial} = block_trial ;
        BpodSystem.Data.RewardProbability{currentTrial} = S.GUI.Probability;
        BpodSystem.Data.RewardRatio{currentTrial} = S.GUI.RewardRatio;
        %%%
        %%%
        %%%
        if isfield(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events, 'Port1In')
            if length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1Out) >= length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1In)
                BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeLeft = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1Out(1,(length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1Out)-length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1In)) + 1:end) - BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1In);
                BpodSystem.Data.TimeLeft{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeLeft; 
            else
                BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeLeft = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1Out - BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port1In(1,1:end-1));
                BpodSystem.Data.TimeLeft{currentTrial} =  BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeLeft;
            end
        else
            BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeLeft = 0; 
            BpodSystem.Data.TimeLeft{currentTrial} = 0;
        end
        %%%
        if isfield(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events, 'Port3In')
            if length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3Out) >= length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3In)
                BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeRight = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3Out(1,(length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3Out)-length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3In)) + 1:end) - BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3In);
                BpodSystem.Data.TimeRight{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeRight;
            else
                BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeRight = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3Out - BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port3In(1,1:end-1));
                BpodSystem.Data.TimeRight{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeRight;
            end
        else
            BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeRight = 0;
            BpodSystem.Data.TimeRight{currentTrial} = 0;
        end
        %%%
        if isfield(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events, 'Port2In')
            if length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2Out) >= length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2In)
                BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeCenter = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2Out(1,(length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2Out)-length(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2In)) + 1:end) - BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2In);
                BpodSystem.Data.TimeCenter{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeCenter;
            else
                BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeCenter = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2Out - BpodSystem.Data.RawEvents.Trial{currentTrial}.Events.Port2In(1,1:end-1));
                BpodSystem.Data.TimeCenter{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeCenter;
            end
        else
            BpodSystem.Data.RawEvents.Trial{currentTrial}.TimeCenter = 0;
            BpodSystem.Data.TimeCenter{currentTrial} = 0;
        end
        %%%
        %%%
        %%%
        if ~isnan(BpodSystem.Data.RawEvents.Trial{currentTrial}.States.LeftReward(1))
            BpodSystem.Data.RawEvents.Trial{currentTrial}.Choice = -1; 
            BpodSystem.Data.Choice(currentTrial) = -1; 
        else
            BpodSystem.Data.RawEvents.Trial{currentTrial}.Choice = 1; 
            BpodSystem.Data.Choice(currentTrial) = 1;
        end
        %%%
        if rem(currentTrial,10) == 0
            window_index = 10;
        else
            window_index = rem(currentTrial,10);
        end
        %%%
        if (BpodSystem.Data.TrialTypes{currentTrial}(1) == 'r' && BpodSystem.Data.RawEvents.Trial{currentTrial}.Choice == 1) || (BpodSystem.Data.TrialTypes{currentTrial}(1) == 'l' && BpodSystem.Data.RawEvents.Trial{currentTrial}.Choice == -1)
            BpodSystem.Data.RawEvents.Trial{currentTrial}.maximum = 1;
            BpodSystem.Data.maximum{currentTrial} = 1;
            moving_window(window_index) = 1;
        else
            BpodSystem.Data.RawEvents.Trial{currentTrial}.maximum = 0;
            BpodSystem.Data.maximum{currentTrial} = 0;
            moving_window(window_index) = 0; 
        end
        %%%
        if (BpodSystem.Data.RawEvents.Trial{currentTrial}.maximum == 1 && index == 1)
            BpodSystem.Data.RawEvents.Trial{currentTrial}.Reward = 1;
            BpodSystem.Data.Reward(currentTrial) = 1;
            BpodSystem.Data.RewardVolume{currentTrial} = S.GUI.RewardAmountLarge; 
        elseif(BpodSystem.Data.RawEvents.Trial{currentTrial}.maximum == 0 && index == 1)
            BpodSystem.Data.RawEvents.Trial{currentTrial}.Reward = -1;
            BpodSystem.Data.Reward(currentTrial) = -1;
            BpodSystem.Data.RewardVolume{currentTrial} = S.GUI.RewardAmountSmall; 
        else
            BpodSystem.Data.RawEvents.Trial{currentTrial}.Reward = 0;
            BpodSystem.Data.Reward(currentTrial) = 0; 
            BpodSystem.Data.RewardVolume{currentTrial}  = 0; 
        end
        %%%
        %%%
        Maximum = [BpodSystem.Data.maximum{:}]; %convert maximization number to something useful
        Reward = [BpodSystem.Data.RewardVolume{:}];
        %%%
        if block_trial == 10
        BpodSystem.Data.SlopeFirst10(block_number) = (sum(BpodSystem.Data.Choice(end-9:end)))/10;
            if block_number > 1
                if BpodSystem.Data.BlockType(block_number) == 1
                    BpodSystem.Data.DeltaSlope(block_number) = BpodSystem.Data.SlopeFirst10(block_number) - BpodSystem.Data.SlopeLast10(block_number - 1);
                else
                    BpodSystem.Data.DeltaSlope(block_number) = -(BpodSystem.Data.SlopeFirst10(block_number) - BpodSystem.Data.SlopeLast10(block_number - 1));
                end
            end
        end
        %%%
        if block_trial >= 10 + block_fudge(block_number)
            if sum(moving_window) >=8
                BpodSystem.Data.BlockLength(block_number) = block_trial;
                BpodSystem.Data.Post10Trials(block_number) = block_trial - 10;
                BpodSystem.Data.SlopeLast10(block_number) = (sum(BpodSystem.Data.Choice(end-9:end)))/10;
                BpodSystem.Data.MaxPost10(block_number) = sum(Maximum(end-(block_trial-11):end))/(block_trial - 10);
                block_trial = 0;
                block_number = block_number + 1;
                if block_type == 1
                    block_type = 2;
                else
                    block_type = 1;
                end
            end  
        end
        block_trial = block_trial + 1;
        BpodSystem.Data.RawEvents.Trial{currentTrial}.TrialDuration = toc(StartTime)-elapsedTime;
        BpodSystem.Data.TrialDuration{currentTrial} = BpodSystem.Data.RawEvents.Trial{currentTrial}.TrialDuration;
        %%%
        BpodSystem.Data.percentLatInit{currentTrial} = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.LatInit)/BpodSystem.Data.TrialDuration{currentTrial};
        BpodSystem.Data.percentLatChoi{currentTrial} = sum(BpodSystem.Data.RawEvents.Trial{currentTrial}.LatChoi)/BpodSystem.Data.TrialDuration{currentTrial};
        BpodSystem.Data.percentLeft{currentTrial} = BpodSystem.Data.TimeLeft{currentTrial}/BpodSystem.Data.TrialDuration{currentTrial};
        BpodSystem.Data.percentRight{currentTrial} = BpodSystem.Data.TimeRight{currentTrial}/BpodSystem.Data.TrialDuration{currentTrial};
        BpodSystem.Data.percentCenter{currentTrial} = BpodSystem.Data.TimeCenter{currentTrial}/BpodSystem.Data.TrialDuration{currentTrial};
        %%%
        SaveBpodSessionData; % Saves the field BpodSystem.Data to the current data file
        %%%
    end
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    elapsedTime = toc(StartTime);
    if BpodSystem.Status.BeingUsed == 0 
        return
    elseif BpodSystem.Data.CumulativeReward(end) > S.GUI.MaximumReward
        break
    elseif elapsedTime > S.GUI.SessionTime
        break
    end
end
%%%
%%%
%%%
LatInit = [BpodSystem.Data.LatInit{:}];
LatChoi = [BpodSystem.Data.LatChoi{:}];
InitSus = [BpodSystem.Data.InitSus{:}];
Maximum = [BpodSystem.Data.maximum{:}];
%%%
%%%
%%%
if length(BpodSystem.Data.BlockLength)>= 1
    SumPost10 = sum(BpodSystem.Data.Post10Trials);
    BpodSystem.Data.WeightPost10 = BpodSystem.Data.Post10Trials/SumPost10;
    BpodSystem.Data.WeightMaxPost10 = BpodSystem.Data.MaxPost10.*BpodSystem.Data.WeightPost10;
else
    Maximum = [BpodSystem.Data.maximum{:}]; 
    BpodSystem.Data.WeightMaxPost10 = sum(Maximum(11:end))/(BpodSystem.Data.nTrials - 10);
end
RightPokes = ((BpodSystem.Data.nTrials - sum(BpodSystem.Data.Choice))/2) + sum(BpodSystem.Data.Choice);
LeftPokes = BpodSystem.Data.nTrials - RightPokes;
if RightPokes > LeftPokes
    Bias = (RightPokes - LeftPokes)/BpodSystem.Data.nTrials;
else
    Bias = (LeftPokes - RightPokes)/BpodSystem.Data.nTrials;
end
%%%
%%%
%%%

BpodSystem.Data.DeltaSlope(1) = NaN;
BpodSystem.Data.Stay(1) = NaN;
BpodSystem.Data.RewMin1(1) = NaN;
for n = 2:BpodSystem.Data.nTrials
   if BpodSystem.Data.Choice(n) == BpodSystem.Data.Choice(n-1) 
        BpodSystem.Data.Stay(n) = 1;
   else
        BpodSystem.Data.Stay(n) = 0;
   end
   BpodSystem.Data.RewMin1(n) = BpodSystem.Data.Reward(n-1);
end

Choice_Stay = sum(BpodSystem.Data.Stay(2:end))/length(BpodSystem.Data.Stay(2:end));
Big_Win_Stay = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 1))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 1));
Small_Win_Stay = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == -1))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == -1));
Lose_Switch = 1-(sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0)));
Big_Lose_Stay = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & Maximum == 1))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & Maximum == 1));
Small_Lose_Stay = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & Maximum == 0))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & Maximum == 0));

Big_Win_Stay_First10 = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 1 & cell2mat(BpodSystem.Data.BlockTrial) <= 10))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 1 & cell2mat(BpodSystem.Data.BlockTrial) <= 10));
Small_Win_Stay_First10 = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == -1 & cell2mat(BpodSystem.Data.BlockTrial) <= 10))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == -1 & cell2mat(BpodSystem.Data.BlockTrial) <= 10));
Lose_Switch_First10 = 1-(sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & cell2mat(BpodSystem.Data.BlockTrial) <= 10))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & cell2mat(BpodSystem.Data.BlockTrial) <= 10)));

Big_Win_Stay_Post10 = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 1 & cell2mat(BpodSystem.Data.BlockTrial) > 10))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 1 & cell2mat(BpodSystem.Data.BlockTrial) > 10));
Small_Win_Stay_Post10 = sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == -1 & cell2mat(BpodSystem.Data.BlockTrial) > 10))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == -1 & cell2mat(BpodSystem.Data.BlockTrial) > 10));
Lose_Switch_Post10 = 1-(sum(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & cell2mat(BpodSystem.Data.BlockTrial) > 10))/length(BpodSystem.Data.Stay(BpodSystem.Data.RewMin1 == 0 & cell2mat(BpodSystem.Data.BlockTrial) > 10)));
%%%
%%%
%%%
Choice_Stay_50 = NaN;
Choice_Stay_100 = NaN;
Choice_Stay_150 = NaN;
Choice_Stay_200 = NaN;

Lose_Switch_50 = NaN;
Lose_Switch_100 = NaN;
Lose_Switch_150 = NaN;
Lose_Switch_200 = NaN;

Big_Win_Stay_50 = NaN;
Small_Win_Stay_50 = NaN;
Big_Lose_Switch_50 = NaN;
Small_Lose_Switch_50 = NaN;

Big_Win_Stay_100 = NaN;
Small_Win_Stay_100 = NaN;
Big_Lose_Switch_100 = NaN;
Small_Lose_Switch_100 = NaN;

Big_Win_Stay_150 = NaN;
Small_Win_Stay_150 = NaN;
Big_Lose_Switch_150 = NaN;
Small_Lose_Switch_150 = NaN;

Big_Win_Stay_200 = NaN;
Small_Win_Stay_200 = NaN;
Big_Lose_Switch_200 = NaN;
Small_Lose_Switch_200 = NaN;


if BpodSystem.Data.nTrials > 50
    Stay50 = BpodSystem.Data.Stay(1:50);
    RewMin50 = BpodSystem.Data.RewMin1(1:50);
    Maximum50 = Maximum(1:50);
    
    Choice_Stay_50 = sum(Stay50(2:end))/length(Stay50(2:end));
    
    if ~isempty(Stay50(RewMin50 == 0))
        Lose_Switch_50 = 1-(sum(Stay50(RewMin50 == 0))/length(Stay50(RewMin50 == 0)));
    else
        Lose_Switch_50 = NaN;
    end
    
    if ~isempty(Stay50(RewMin50 == 1))
        Big_Win_Stay_50 = sum(Stay50(RewMin50 == 1))/length(Stay50(RewMin50 == 1));
    else
        Big_Win_Stay_50 = NaN;
    end
    if ~isempty(Stay50(RewMin50 == -1))
        Small_Win_Stay_50 = sum(Stay50(RewMin50 == -1))/length(Stay50(RewMin50 == -1));
    else
        Small_Win_Stay_50 = NaN;
    end
    if ~isempty(Stay50(RewMin50 == 0 & Maximum50 == 1))
        Big_Lose_Switch_50 = 1-(sum(Stay50(RewMin50 == 0 & Maximum50 == 1))/length(Stay50(RewMin50 == 0 & Maximum50 == 1)));
    else
        Big_Lose_Switch_50 = NaN;
    end
    if ~isempty(Stay50(RewMin50 == 0 & Maximum50 == 0))
        Small_Lose_Switch_50 = 1-(sum(Stay50(RewMin50 == 0 & Maximum50 == 0))/length(Stay50(RewMin50 == 0 & Maximum50 == 0)));
    else
        Small_Lose_Switch_50 = NaN;
    end    
end
%%%
if BpodSystem.Data.nTrials > 100
    Stay100 = BpodSystem.Data.Stay(51:100);
    RewMin100 = BpodSystem.Data.RewMin1(51:100);
    Maximum100 = Maximum(51:100);
    
    Choice_Stay_100 = sum(Stay100)/length(Stay100);
    
    if ~isempty(Stay100(RewMin100 == 0))
        Lose_Switch_100 = 1-(sum(Stay100(RewMin100 == 0))/length(Stay100(RewMin100 == 0)));
    else
        Lose_Switch_100 = NaN;
    end
    
    if ~isempty(Stay100(RewMin100 == 1))
        Big_Win_Stay_100 = sum(Stay100(RewMin100 == 1))/length(Stay100(RewMin100 == 1));
    else
        Big_Win_Stay_100 = NaN;
    end
    if ~isempty(Stay100(RewMin100 == -1))
        Small_Win_Stay_100 = sum(Stay100(RewMin100 == -1))/length(Stay100(RewMin100 == -1));
    else
        Small_Win_Stay_100 = NaN;
    end
    if ~isempty(Stay100(RewMin100 == 0 & Maximum100 == 1))
        Big_Lose_Switch_100 = 1-(sum(Stay100(RewMin100 == 0 & Maximum100 == 1))/length(Stay100(RewMin100 == 0 & Maximum100 == 1)));
    else
        Big_Lose_Switch_100 = NaN;
    end
    if ~isempty(Stay100(RewMin100 == 0 & Maximum100 == 0))
        Small_Lose_Switch_100 = 1-(sum(Stay100(RewMin100 == 0 & Maximum100 == 0))/length(Stay100(RewMin100 == 0 & Maximum100 == 0)));
    else
        Small_Lose_Switch_100 = NaN;
    end    
end
%%%
if BpodSystem.Data.nTrials > 150
    Stay150 = BpodSystem.Data.Stay(101:150);
    RewMin150 = BpodSystem.Data.RewMin1(101:150);
    Maximum150 = Maximum(101:150);
    
    Choice_Stay_150 = sum(Stay150)/length(Stay150);
    
    if ~isempty(Stay150(RewMin150 == 0))
        Lose_Switch_150 = 1-(sum(Stay150(RewMin150 == 0))/length(Stay150(RewMin150 == 0)));
    else
        Lose_Switch_150 = NaN;
    end
    
    if ~isempty(Stay150(RewMin150 == 1))
        Big_Win_Stay_150 = sum(Stay150(RewMin150 == 1))/length(Stay150(RewMin150 == 1));
    else
        Big_Win_Stay_150 = NaN;
    end
    if ~isempty(Stay150(RewMin150 == -1))
        Small_Win_Stay_150 = sum(Stay150(RewMin150 == -1))/length(Stay150(RewMin150 == -1));
    else
        Small_Win_Stay_150 = NaN;
    end
    if ~isempty(Stay150(RewMin150 == 0 & Maximum150 == 1))
        Big_Lose_Switch_150 = 1-(sum(Stay150(RewMin150 == 0 & Maximum150 == 1))/length(Stay150(RewMin150 == 0 & Maximum150 == 1)));
    else
        Big_Lose_Switch_150 = NaN;
    end
    if ~isempty(Stay150(RewMin150 == 0 & Maximum150 == 0))
        Small_Lose_Switch_150 = 1-(sum(Stay150(RewMin150 == 0 & Maximum150 == 0))/length(Stay150(RewMin150 == 0 & Maximum150 == 0)));
    else
        Small_Lose_Switch_150 = NaN;
    end    
end
%%%
if BpodSystem.Data.nTrials >= 200
    Stay200 = BpodSystem.Data.Stay(151:200);
    RewMin200 = BpodSystem.Data.RewMin1(151:200);
    Maximum200 = Maximum(151:200);
    
    Choice_Stay_200 = sum(Stay200)/length(Stay200);
    
    if ~isempty(Stay200(RewMin200 == 0))
        Lose_Switch_200 = 1-(sum(Stay200(RewMin200 == 0))/length(Stay200(RewMin200 == 0)));
    else
        Lose_Switch_200 = NaN;
    end
    
    if ~isempty(Stay200(RewMin200 == 1))
        Big_Win_Stay_200 = sum(Stay200(RewMin200 == 1))/length(Stay200(RewMin200 == 1));
    else
        Big_Win_Stay_200 = NaN;
    end
    if ~isempty(Stay200(RewMin200 == -1))
        Small_Win_Stay_200 = sum(Stay200(RewMin200 == -1))/length(Stay200(RewMin200 == -1));
    else
        Small_Win_Stay_200 = NaN;
    end
    if ~isempty(Stay200(RewMin200 == 0 & Maximum200 == 1))
        Big_Lose_Switch_200 = 1-(sum(Stay200(RewMin200 == 0 & Maximum200 == 1))/length(Stay200(RewMin200 == 0 & Maximum200 == 1)));
    else
        Big_Lose_Switch_200 = NaN;
    end
    if ~isempty(Stay200(RewMin200 == 0 & Maximum200 == 0))
        Small_Lose_Switch_200 = 1-(sum(Stay200(RewMin200 == 0 & Maximum200 == 0))/length(Stay200(RewMin200 == 0 & Maximum200 == 0)));
    else
        Small_Lose_Switch_200 = NaN;
    end    
end
%%%
%%%
%%%
if BpodSystem.Data.nTrials >= 25
    LatInit25 = mean(LatInit(1:25), 'omitnan');
else
    LatInit25 = 0;
end

if BpodSystem.Data.nTrials >= 50
    LatInit50 = mean(LatInit(26:50), 'omitnan');
else
    LatInit50 = 0;
end

if BpodSystem.Data.nTrials >= 75
    LatInit75 = mean(LatInit(51:75), 'omitnan');
else
    LatInit75 = 0;
end

if BpodSystem.Data.nTrials >= 100
    LatInit100 = mean(LatInit(76:100), 'omitnan');
else
    LatInit100 = 0;
end

if BpodSystem.Data.nTrials >= 125
    LatInit125 = mean(LatInit(101:125), 'omitnan');
else
    LatInit125 = 0;
end

if BpodSystem.Data.nTrials >= 150
    LatInit150 = mean(LatInit(126:150), 'omitnan');
else
    LatInit150 = 0;
end

if BpodSystem.Data.nTrials >= 175
    LatInit175 = mean(LatInit(151:175), 'omitnan');
else
    LatInit175 = 0;
end

if BpodSystem.Data.nTrials >= 200
    LatInit200 = mean(LatInit(176:200), 'omitnan');
else
    LatInit200 = 0;
end
%%%
%%%
%%%
if BpodSystem.Data.nTrials >= 25
    LatChoi25 = mean(LatChoi(1:25), 'omitnan');
else
    LatChoi25 = 0;
end

if BpodSystem.Data.nTrials >= 50
    LatChoi50 = mean(LatChoi(26:50), 'omitnan');
else
    LatChoi50 = 0;
end

if BpodSystem.Data.nTrials >= 75
    LatChoi75 = mean(LatChoi(51:75), 'omitnan');
else
    LatChoi75 = 0;
end

if BpodSystem.Data.nTrials >= 100
    LatChoi100 = mean(LatChoi(76:100), 'omitnan');
else
    LatChoi100 = 0;
end

if BpodSystem.Data.nTrials >= 125
    LatChoi125 = mean(LatChoi(101:125), 'omitnan');
else
    LatChoi125 = 0;
end

if BpodSystem.Data.nTrials >= 150
    LatChoi150 = mean(LatChoi(126:150), 'omitnan');
else
    LatChoi150 = 0;
end

if BpodSystem.Data.nTrials >= 175
    LatChoi175 = mean(LatChoi(151:175), 'omitnan');
else
    LatChoi175 = 0;
end

if BpodSystem.Data.nTrials >= 200
    LatChoi200 = mean(LatChoi(176:200), 'omitnan');
else
    LatChoi200 = 0;
end
%%%
%%% 
%%%
if BpodSystem.Data.nTrials >= 25
    Max25 = mean(Maximum(1:25));
else
    Max25 = 0;
end

if BpodSystem.Data.nTrials >= 50
    Max50 = mean(Maximum(26:50));
else
    Max50 = 0;
end

if BpodSystem.Data.nTrials >= 75
    Max75 = mean(Maximum(51:75));
else
    Max75 = 0;
end

if BpodSystem.Data.nTrials >= 100
    Max100 = mean(Maximum(76:100));
else
    Max100 = 0;
end

if BpodSystem.Data.nTrials >= 125
    Max125 = mean(Maximum(101:125));
else
    Max125 = 0;
end

if BpodSystem.Data.nTrials >= 150
    Max150 = mean(Maximum(126:150));
else
    Max150 = 0;
end

if BpodSystem.Data.nTrials >= 175
    Max175 = mean(Maximum(151:175));
else
    Max175 = 0;
end

if BpodSystem.Data.nTrials >= 200
    Max200 = mean(Maximum(176:200));
else
    Max200 = 0;
end