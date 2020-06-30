UniqueRewProb(1) = 0.75;
UniqueRewProb(2) = 0.4;
UniqueRewRatio(1) = 10;
UniqueRewRatio(2) = 6;
UniqueRewRatio(3) = 2;
UniqueRewRatio(4) = 1.5;
RewRatio{1} = 'Ten';
RewRatio{2} = 'Ten_SE';
RewRatio{3} = 'Six';
RewRatio{4} = 'Six_SE';
RewRatio{5} = 'Two';
RewRatio{6} = 'Two_SE';
RewRatio{7} = 'OnePointFive';
RewRatio{8} = 'OnePointFive_SE';
RewProb{1} = 'Point75';
RewProb{2} = 'Point4';

%put all the trials for an individual probability together
choice = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).choice{:,:});
choice_index = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).choice_index{:,:});
choice_index_2 = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).choice_index_2{:,:});
large_reward_index = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).large_reward_index{:,:});
small_reward_index = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).small_reward_index{:,:});
reward = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).reward_index{:,:});
env_1 = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).env_1{:,:});
env_2 = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).env_2{:,:});
env_3 = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).env_3{:,:});
env_4 = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).env_4{:,:});
%latchoi = vertcat(global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).latchoi{:,:});

inx = [0 0 0 0 0 0 0 0];
global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel = fit_qlearning_neurexin(inx, choice, reward, choice_index, env_1, env_2, env_3, env_4);

choice_index = [];
choice_index_2 = [];
