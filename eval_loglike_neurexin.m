function [loglike, probchoice] = eval_loglike_neurexin(choice, weight, beta, kappa, choice_index, constant_1, constant_2, constant_3, constant_4, env_1, env_2, env_3, env_4)

choice = double(choice == 1);


logodds = (beta * (weight(:,1) - weight(:,2))) + (kappa * choice_index) + (constant_1*env_1) + (constant_2*env_2) + (constant_3*env_3) + (constant_4*env_4); %%compute log odds of choice for each trial
probchoice = 1 ./ (1 + exp(-logodds));        %convert log odds to probability
probchoice(find(probchoice == 0)) = eps;      %to prevent fmin crashing from a log zero
probchoice(find(probchoice == 1)) = 1-eps;
loglike = - (transpose(choice(:)) * log(probchoice(:)) + transpose(1-choice(:)) * log(1-probchoice(:)));