LatInit = [global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit{:}];
LatChoi = [global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi{:}];
InitSus = [global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.InitSus{:}];
Maximum = [global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.maximum{:}];

%env refers to one of the four relative reward regimes

env_1 = zeros(length(LatInit),1);
env_2 = zeros(length(LatInit),1);
env_3 = zeros(length(LatInit),1);
env_4 = zeros(length(LatInit),1);

if mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardRatio(1))) == '6'
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio = 'Six';
    env_2 = ones(length(LatInit),1);
elseif mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardRatio(1))) == '120'
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio = 'Ten';
    env_1 = ones(length(LatInit),1);
elseif mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardRatio(1))) == '126'
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio = 'Two';
    env_3 = ones(length(LatInit),1);
elseif mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardRatio(1))) == '128'
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio = 'OnePointFive';
    env_4 = ones(length(LatInit),1);
elseif mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardRatio(1))) == '2'
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio = 'Two';
    env_3 = ones(length(LatInit),1);
elseif mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardRatio(1))) == '1.5'
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio = 'OnePointFive';
    env_4 = ones(length(LatInit),1);
else
    disp('We Gotta Problem Chief');
end

if str2num(mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardProbability(1)))) == 0.75
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb = 'Point75';
elseif str2num(mat2str(cell2mat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewardProbability(1)))) == 0.4
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb = 'Point4';
else
    disp('We Gotta Problem Chief');
end


RightPokes = ((global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials - sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Choice))/2) + sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Choice);
LeftPokes = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials - RightPokes;
if RightPokes > LeftPokes
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Bias = (RightPokes - LeftPokes)/global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials;
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Bias = (LeftPokes - RightPokes)/global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials;
end

%Calculation of Relevant Win Stay Values and Relative Action Values
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(1) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1(1) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin2(1:2) = NaN;

for n = 2:global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials
    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Choice(n) == global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Choice(n-1)
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(n) = 1;
    else
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(n) = 0;
    end
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1(n) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-1);
    if n > 2
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin2(n) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-2);
    end
end

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Choice_Stay = sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(2:end))/length(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(2:end));
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Big_Win_Stay = sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == 1))/length(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == 1));
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Small_Win_Stay = sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == -1))/length(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == -1));
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Lose_Stay = sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == 0))/length(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Stay(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == 0));

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 25
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit25 = mean(LatInit(1:25), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit25 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 50
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit50 = mean(LatInit(26:50), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit50 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 75
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit75 = mean(LatInit(51:75), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit75 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 100
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit100 = mean(LatInit(76:100), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit100 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 125
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit125 = mean(LatInit(101:125), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit125 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 150
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit150 = mean(LatInit(126:150), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit150 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 175
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit175 = mean(LatInit(151:175), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit175 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 200
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit200 = mean(LatInit(176:200), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatInit200 = 0;
end

%%%

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 25
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi25 = mean(LatChoi(1:25), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi25 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 50
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi50 = mean(LatChoi(26:50), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi50 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 75
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi75 = mean(LatChoi(51:75), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi75 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 100
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi100 = mean(LatChoi(76:100), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi100 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 125
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi125 = mean(LatChoi(101:125), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi125 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 150
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi150 = mean(LatChoi(126:150), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi150 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 175
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi175 = mean(LatChoi(151:175), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi175 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 200
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi200 = mean(LatChoi(176:200), 'omitnan');
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LatChoi200 = 0;
end

%%%

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 25
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max25 = mean(Maximum(1:25));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max25 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 50
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max50 = mean(Maximum(26:50));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max50 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 75
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max75 = mean(Maximum(51:75));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max75 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 100
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max100 = mean(Maximum(76:100));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max100 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 125
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max125 = mean(Maximum(101:125));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max125 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 150
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max150 = mean(Maximum(126:150));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max150 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 175
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max175 = mean(Maximum(151:175));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max175 = 0;
end

if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials >= 200
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max200 = mean(Maximum(176:200));
else
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Max200 = 0;
end

%only use the simplified version
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeLatencyToInitiate = (mean(LatInit(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == 1), 'omitnan')-mean(LatInit(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == -1), 'omitnan'))/(mean(LatInit(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == -1), 'omitnan'));
global_data.(genotype_directories(i).name).RelativeLatencyToInitiate.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).mouse{f} = (mean(LatInit(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == 1), 'omitnan')-mean(LatInit(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == -1), 'omitnan'))/(mean(LatInit(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RewMin1 == -1), 'omitnan'));
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeActionValue = log(((global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Big_Win_Stay/(1-global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Big_Win_Stay))/((global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Small_Win_Stay/(1-global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Small_Win_Stay)))));
global_data.(genotype_directories(i).name).RelativeActionValue.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).mouse{f} = log(((global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Big_Win_Stay/(1-global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Big_Win_Stay))/((global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Small_Win_Stay/(1-global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Small_Win_Stay)))));

%Logistic Regression and Reinforcement Learning Model
for n = 1:global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials
    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Choice(n) == 1
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n) = 1;
    else
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n) = 0;
    end
end
%%%

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(1) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(1) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(1) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(1:2) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(1:2) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(1:2) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(1:3) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(1:3) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(1:3) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(1:4) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(1:4) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(1:4) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(1:5) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(1:5) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(1:5) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(1:6) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(1:6) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(1:6) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(1:7) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(1:7) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(1:7) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(1:8) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(1:8) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(1:8) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(1:9) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(1:9) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(1:9) = NaN;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(1:10) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(1:10) = NaN;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(1:10) = NaN;

for n = 2:global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.nTrials
    
    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-1) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-1) == 1
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(n) = 1;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(n) = 0;
    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-1) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-1) == -1
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(n) = 1;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(n) = 0;
    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-1) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-1) == 1
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(n) = -1;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(n) = 0;
    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-1) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-1) == -1
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(n) = -1;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(n) = 0;
    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-1) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-1) == 0
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(n) = 1;
    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-1) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-1) == 0
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(n) = -1;
    else
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1(n) = 0;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1(n) = 0;
    end
    
    if n > 2
        if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-2) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-2) == 1
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(n) = 1;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(n) = 0;
        elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-2) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-2) == -1
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(n) = 1;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(n) = 0;
        elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-2) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-2) == 1
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(n) = -1;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(n) = 0;
        elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-2) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-2) == -1
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(n) = -1;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(n) = 0;
        elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-2) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-2) == 0
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(n) = 1;
        elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-2) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-2) == 0
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(n) = -1;
        else
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2(n) = 0;
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2(n) = 0;
        end
        if n > 3
            if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-3) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-3) == 1
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(n) = 1;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(n) = 0;
            elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-3) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-3) == -1
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(n) = 1;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(n) = 0;
            elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-3) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-3) == 1
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(n) = -1;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(n) = 0;
            elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-3) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-3) == -1
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(n) = -1;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(n) = 0;
            elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-3) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-3) == 0
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(n) = 1;
            elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-3) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-3) == 0
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(n) = -1;
            else
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3(n) = 0;
                global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3(n) = 0;
            end
            if n > 4
                if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-4) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-4) == 1
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(n) = 1;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(n) = 0;
                elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-4) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-4) == -1
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(n) = 1;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(n) = 0;
                elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-4) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-4) == 1
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(n) = -1;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(n) = 0;
                elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-4) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-4) == -1
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(n) = -1;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(n) = 0;
                elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-4) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-4) == 0
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(n) = 1;
                elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-4) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-4) == 0
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(n) = -1;
                else
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4(n) = 0;
                    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4(n) = 0;
                end
                if n > 5
                    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-5) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-5) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-5) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-5) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-5) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-5) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-5) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-5) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-5) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-5) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(n) = 1;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-5) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-5) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(n) = -1;
                    else
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5(n) = 0;
                    end
                end
                if n > 6
                    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-6) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-6) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-6) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-6) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-6) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-6) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-6) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-6) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-6) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-6) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(n) = 1;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-6) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-6) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(n) = -1;
                    else
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin6(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin6(n) = 0;
                    end
                end
                if n > 7
                    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-7) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-7) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-7) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-7) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-7) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-7) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-7) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-7) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-7) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-7) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(n) = 1;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-7) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-7) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(n) = -1;
                    else
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin7(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin7(n) = 0;
                    end
                end
                if n > 8
                    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-8) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-8) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-8) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-8) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-8) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-8) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-8) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-8) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-8) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-8) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(n) = 1;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-8) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-8) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(n) = -1;
                    else
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin8(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin8(n) = 0;
                    end
                end
                if n > 9
                    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-9) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-9) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-9) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-9) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-9) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-9) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-9) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-9) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-9) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-9) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(n) = 1;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-9) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-9) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(n) = -1;
                    else
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin9(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin9(n) = 0;
                    end
                end
                if n > 10
                    if global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-10) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-10) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-10) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-10) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(n) = 1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-10) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-10) == 1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-10) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-10) == -1
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(n) = -1;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(n) = 0;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-10) == 1 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-10) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(n) = 1;
                    elseif global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice(n-10) == 0 && global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward(n-10) == 0
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(n) = -1;
                    else
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin10(n) = 0;
                        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin10(n) = 0;
                    end
                end
            end
        end
    end
end


%% Set Up For Reinforcement Model
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).large_reward{f} = zeros(length(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward),1);
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).small_reward{f} = zeros(length(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward),1);
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).unrewarded{f} = zeros(length(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward),1);

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).choice{f} = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice';
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).large_reward{f}(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward == 1) = 1;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).small_reward{f}(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward == -1) = 1;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).unrewarded{f}(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Reward == 0) = 1;

choice = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).choice{f};
large_reward_index = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).large_reward{f};
small_reward_index = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).small_reward{f};
unrewarded_index = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).unrewarded{f};

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).choice{j} = choice;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).large_reward_index{j} = large_reward_index;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).small_reward_index{j} = small_reward_index;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).env_1{j} = env_1;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).env_2{j} = env_2;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).env_3{j} = env_3;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).env_4{j} = env_4;

choice_index(1,1) = NaN;
choice_index_2(1:2,1) = NaN;
choice_min_1(1) = NaN;
choice_min_2(1:2) = NaN;
choice_min_3(1:3) = NaN;
choice_min_4(1:4) = NaN;
choice_min_5(1:5) = NaN;
choice_min_6(1:6) = NaN;
choice_min_7(1:7) = NaN;
choice_min_8(1:8) = NaN;
choice_min_9(1:9) = NaN;
choice_min_10(1:10) = NaN;

for n = 2:length(choice)
    if choice(n-1) == 1
        choice_index(n,1) = choice(n-1);
        choice_min_1(n) = choice(n-1);
    else
        choice_index(n,1) = -1;
        choice_min_1(n) = -1;
    end
    if n > 2
        if choice(n-2) == 1
            choice_index_2(n,1) = choice(n-2);
            choice_min_2(n) = choice(n-2);
        else
            choice_index_2(n,1) = -1;
            choice_min_2(n) = -1;
        end
    end
    if n > 3
        if choice(n-3) == 1
            choice_min_3(n) = choice(n-3);
        else
            choice_min_3(n) = -1;
        end
    end
    if n > 4
        if choice(n-4) == 1
            choice_min_4(n) = choice(n-4);
        else
            choice_min_4(n) = -1;
        end
    end
    if n > 5
        if choice(n-5) == 1
            choice_min_5(n) = choice(n-5);
        else
            choice_min_5(n) = -1;
        end
    end
    if n > 6
        if choice(n-6) == 1
            choice_min_6(n) = choice(n-6);
        else
            choice_min_6(n) = -1;
        end
    end
    if n > 7
        if choice(n-7) == 1
            choice_min_7(n) = choice(n-7);
        else
            choice_min_7(n) = -1;
        end
    end
    if n > 8
        if choice(n-8) == 1
            choice_min_8(n) = choice(n-8);
        else
            choice_min_8(n) = -1;
        end
    end
    if n > 9
        if choice(n-9) == 1
            choice_min_9(n) = choice(n-9);
        else
            choice_min_9(n) = -1;
        end
    end
    if n > 10
        if choice(n-10) == 1
            choice_min_10(n) = choice(n-10);
        else
            choice_min_10(n) = -1;
        end
    end
end

choice_index(isnan(choice_index),  1) = 0;
choice_index_2(isnan(choice_index_2),  1) = 0;

%% Logistic Regression
Y =  global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogChoice';
X = [global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin1; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin2; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin3; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin4; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogBigRewMin5;
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin1; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin2; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin3; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin4; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogSmallRewMin5;
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin1; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin2; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin3; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin4; global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.LogUnRewMin5;
    choice_min_1; choice_min_2; choice_min_3; choice_min_4; choice_min_5]'; %choice_min_6; choice_min_7; choice_min_8; choice_min_9; choice_min_10

num_folds = 6;
num_shuffles = 20;

for d = 1:num_shuffles
    indices = crossvalind('Kfold',Y,num_folds);
    for m = 1:num_folds
        test = (indices == m);
        train = ~test;
        [b_log,dev,global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.my_first_time] = glmfit(X(train,:),Y(train),'binomial','logit'); % Logistic regression
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.shuffle(d).fold{m} = b_log;
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_test.shuffle(d).fold_estimate{m} = glmval(b_log,X(test,:),'logit')';
        global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_test.shuffle(d).fold_orig{m} = Y(test);
        %need to finish per test classification of how well model does
    end
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.shuffle(d).total = horzcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.shuffle(d).fold{:,:});
    global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.shuffle_mean(:,d) = mean(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.shuffle(d).total,2);
end

%only use simplified version
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean = mean(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.shuffle_mean,2);
global_data.(genotype_directories(i).name).Logistic.Coef_Mean.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).mouse(:,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.probability_estimate = glmval(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean,X,'logit');
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.value_estimate = log((global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.probability_estimate)/(1-global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.probability_estimate));


%%

reward = zeros(length(large_reward_index),1);
reward(large_reward_index == 1) = 12;

if strcmp(cellstr(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio), 'Ten')
    reward(small_reward_index == 1) = 0;
elseif strcmp(cellstr(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio), 'Six') == 10
    reward(small_reward_index == 1) = 2;
elseif strcmp(cellstr(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio), 'Two') == 10
    reward(small_reward_index == 1) = 6;
else
    reward(small_reward_index == 1) = 8;
end

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).choice_index{f} = choice_index;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).choice_index_2{f} = choice_index_2;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).reward_index{f} = reward;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).latchoi{f} = LatChoi;

global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).choice_index{j} = choice_index;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).choice_index_2{j} = choice_index_2;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).reward_index{j} = reward;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).latchoi{j} = LatChoi';

choice_index = [];
choice_index_2 = [];
choice_min_1 = [];
choice_min_2 = [];
choice_min_3 = [];
choice_min_4 = [];
choice_min_5 = [];
choice_min_6 = [];
choice_min_7 = [];
choice_min_8 = [];
choice_min_9 = [];
choice_min_10 = [];
env_1 = [];
env_2 = [];
env_3 = [];
env_4 = [];


global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Bias =  abs(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean(1));
global_data.(genotype_directories(i).name).Bias.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).mouse{f} = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.Bias;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.CumulativeDiscountedActionValue =  sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean(2:4))- sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean(7:9));
global_data.(genotype_directories(i).name).CumulativeDiscountedActionValue.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).mouse{f} = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.CumulativeDiscountedActionValue;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.CumulativeDiscountedNoReward =  sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean(12:14));
global_data.(genotype_directories(i).name).CumulativeDiscountedNoReward.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).mouse{f} = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.CumulativeDiscountedNoReward;
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.CumulativeDiscountedChoice =  sum(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.logistic.fit_coef.overall_mean(17:19));
global_data.(genotype_directories(i).name).CumulativeDiscountedChoice.(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardProb).(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.RelativeRewardRatio).mouse{f} = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j).SessionData.CumulativeDiscountedChoice;