%%
close all;
clear;
clc;

%% set task type
% lossType = 'PgNN';
lossType = 'PiNN';
task = "predict_next";
% task = "predict_arbitrary";
seq_steps = 20;
t_force_stop = 1;
tSpan = [0,10];

num_samples = 500;
fname = lossType+"_model_"+num2str(num_samples)+"_"+num2str(tSpan(2))+"s"+".mat"; %+"_"+num2str(tSpan(2))+"s"
model = load(fname).net;
% plot(model)
% Mass-Spring-Damper-Pendulum Dynamics System Parameters
[tSpan,x0,paramOptions,ctrlOptions] = options();
strType = {'constant','increase','decrease'};

%% Test
max_forces = [1,2,3,4,5,6,7,8,9,10];
%max_forces = [5];
tTest = linspace(1,50,100);
num_test = length(max_forces);
err_list = zeros(num_test,length(tTest));
for i = 1:num_test
    ctrlOptions.fMax = [max_forces(i);0];
    % ctrlOptions.fMax = rand(2,1).*[10;0]; % random max forces
    %ctrlOptions.fType = strType{randi(numel(strType))};
    % ctrlOptions.fSpan = [0,randi([2,5])];
    y = sdpm_simulation(tSpan,x0,ctrlOptions);
    t = y(:,1);
    u = y(:,2:3);
    x = y(:,4:9);
    switch task
        case "predict_next"
            x_pred = predict_next_step(model,t,x,u,seq_steps,t_force_stop);
        otherwise
            x_pred = predict_arbitary_step(model,t,x,u,seq_steps,t_force_stop);
    end
    plot_states(t,x,paramOptions,ctrlOptions,x_pred)
    err_list(i,:) = rmse(t,x,x_pred,tTest);
end
save(['training/',lossType,'_',num2str(num_samples),'.mat'], 'err_list');

function err = rmse(t,x,xPred,tTest)
    numTest = length(tTest);
    errs = zeros(1,numTest);
    for i = 1:numTest
        indices = find(t < tTest(i));
        errs(i) = x(indices(end)+1)-xPred(indices(end)+1);
    end
    err = sqrt(errs.^2);
end


function x_pred = predict_next_step(model,t,x,u,seq_steps,tForceStop)
    size = length(t);
    x_pred = zeros(size,6);
    indices = find(t <= tForceStop);
    x_pred(1:indices(end),:) = x(1:indices(end),:);
    for i = indices(end):size-1
        startIdx = i-seq_steps+1;
        endIdx = i;
        nextIdx = i+1;
        state = {[t(startIdx:endIdx),x_pred(startIdx:endIdx,:),u(startIdx:endIdx,:)]'};
        dsState = arrayDatastore(state,'OutputType',"same",'ReadSize',128);
        dTime = t(i+1)-t(i);
        dsTime = arrayDatastore(dTime,'ReadSize',128);
        dsTest = combine(dsState, dsTime);
        x_pred(nextIdx,:) = predict(model,dsTest);
    end
end

function x_pred = predict_arbitary_step(model,t,x,u,num_steps,tForceStop)
    size = length(t);
    x_pred = zeros(size,6);
    indices = find(t <= tForceStop);
    x_pred(indices,:) = x(indices,:);
    randomIndices = sort(randperm(numel(indices),num_steps));
    state = {[t(randomIndices),x_pred(randomIndices,:),u(randomIndices,:)]'};
    dsState = arrayDatastore(state,'OutputType',"same",'ReadSize',128);
    for i = indices(end)+1:size    
        dsTime = arrayDatastore(t(i),'ReadSize',128);
        dsTest = combine(dsState, dsTime);
        x_pred(i,:) = predict(model,dsTest);
    end
end
