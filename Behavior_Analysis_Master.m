close all
clear all
addpath(genpath(''))%folder with necessary scripts
cd('');%ordered data from individual sessions
global_data = struct;
warning('off','all');

genotype_directories = dir();
genotype_directories = genotype_directories(~strncmpi('.', {genotype_directories.name}, 1));

for i = 1:length(genotype_directories)
    
    %Analyze data by genotype, open each genotype folder individually and
    %then iterate over reversal training data and relative reward reversal
    %data
    
    cd(strcat('',genotype_directories(i).name));% folder with mice for individual genotype
    mouse_directories = dir();
    mouse_directories = mouse_directories(~strncmpi('.', {mouse_directories.name}, 1));
    
    for f = 1:length(mouse_directories) %for each animal that is part of an individual genotype
        
%         %Training
%         cd(strcat('')); %training data subfolder
%         
%         FileList = dir();
%         FileList = FileList(~strncmpi('.', {FileList.name}, 1));
%         
%         for k = 1:length(FileList)
%             global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).Training(k)= load(FileList(k).name);
%         end
        
        %Reversal
        cd(strcat('')); %reversal data subfolder
        
        FileList = dir();
        FileList = FileList(~strncmpi('.', {FileList.name}, 1));
        
        for j = 1:length(FileList) %analyze the data from each session and save to struct
            global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).RelativeReward(j) = load(FileList(j).name);
            Relative_Reward_Analysis;
        end
        
        if length(FileList) > 0
            for q = 1:2
                Q_Learning_Neurexin;
                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).alpha(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.alpha; 
                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).beta(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.beta; 
                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).kappa(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.kappa; 

                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).gamma(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.gamma; 
                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).constant_1(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.constant_1; 
                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).constant_2(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.constant_2; 
                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).constant_3(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.constant_3; 
                global_data.(genotype_directories(i).name).QModel.(RewProb{q}).constant_4(1,f) = global_data.(genotype_directories(i).name).(strrep(mouse_directories(f).name,'.','_')).ReinforcementM.(RewProb{q}).QModel.constant_4; 
            end
        end
    end

end