function result = fit_qlearning_neurexin(inx, choice, reward, choice_index, env_1, env_2, env_3, env_4)

Aeq=[];
beq=[];
Aineq=[];
bineq=[];

lb = [0 0 0 -100 -100  -100 -100];     %lower limits for variable
ub = [1 100 2 100 100 100 100];  %upper limits for variables

options = optimset('Display','off','MaxIter',5000000,'TolFun',1e-15,'TolX',1e-15,...
    'DiffMaxChange',1e-2,'DiffMinChange',1e-6,'MaxFunEvals',5000000,'LargeScale','off'); 
function_dummy = @(b)model(b, choice, reward, choice_index, choice_index_2, env_1, env_2, env_3, env_4);
problem = createOptimProblem('fmincon','objective',function_dummy,'x0', inx,'lb',lb,'ub',ub,'Aeq',Aeq,'beq',beq,'Aineq',Aineq,'bineq',bineq,'options',options);
ms = MultiStart;
k = 75;

warning off;

result.choice = choice;
result.reward = reward;
result.inx = inx;
result.lb = lb;
result.ub = ub;
result.options = options;

try
[b, loglike, exitflag, output, solutions] = run(ms,problem,k); %runs MultiStart on k start points to find a solution or multiple local solutions to problem.

result.alpha = b(1);
result.beta = b(2);
result.gamma = b(3);
result.kappa = b(4);

result.constant_1 = b(5);
result.constant_2 = b(6);
result.constant_3 = b(7);
result.constant_4 = b(8);

result.modelLL = -loglike;
result.nullmodelLL = log(0.5)*size(choice,1);        

result.exitflag = exitflag;
result.output = output;
result.solutions = solutions;
[loglike, probchoice, weight, rpe, alpha_rpe] = model(b, choice, reward, choice_index, choice_index_2, env_1, env_2, env_3, env_4); %best fitting model
result.probchoice = probchoice; %prob of choosing option 1 on each trial
result.weight = weight;         %model fits Q-values for each trial
result.rpe = rpe;
result.alpha_rpe = alpha_rpe;

catch
    lasterr
    result.modelLL = 0;
    result.exitflag = 0;
end


function [loglike, probchoice, weight, rpe, alpha_rpe] = model(x, choice, reward, choice_index, env_1, env_2, env_3, env_4)
%function to evaluate the loglikelihood of the model for parameters given the data

alpha = x(1);
beta = x(2);
gamma = x(3);
kappa = x(4);

constant_1 = x(5);
constant_2 = x(6);
constant_3 = x(7);
constant_4 = x(8);


[weight, rpe] = qlearning_model_neurexin(choice, reward, alpha, gamma); %compute the weights
max_weight = 12^gamma;
weight = weight/max_weight;
rpe = rpe/max_weight;
alpha_rpe = alpha*rpe;

[loglike, probchoice] = eval_loglike_neurexin(choice, weight, beta, kappa, choice_index, constant_1, constant_2, constant_3, constant_4, env_1, env_2, env_3, env_4); %compute the likelihood