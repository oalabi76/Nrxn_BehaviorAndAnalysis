function [weight, rpe] = qlearning_model_neurexin(choice, reward, alpha, gamma)


choice = double(choice == 1);  %1 for option 1, 0 for option 2
ntrial = length(choice);
weight = zeros(ntrial,2);      %assume 0 for starting conditions (could fit)
rpe = zeros(size(choice)); 

for n = 1:ntrial-1
    %compute rpe
    rpe(n) = (reward(n)^gamma) - weight(n,2-choice(n)); %compute rpe
    
    weight(n+1, 2-choice(n)) = weight(n, 2-choice(n)) + alpha*rpe(n); %update chosen
    weight(n+1, 1+choice(n)) = weight(n, 1+choice(n));                %do not update unchosen
end