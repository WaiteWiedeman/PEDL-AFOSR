%%
% PINN
% A physics-Informed Neural Network (PINN) is a type of neural network
% architecture desigend to incorporate physical principles or equations
% into the learning process. In combines deep learning techniques with
% domain-specific knowledge, making it particularly suitable for problems
% governed by physics.
% In addition to standard data-driven training, PINNs utilize terms in the
% loss function to enforce consistency with know physical law, equations,
% and constraints. 
% https://en.wikipedia.org/wiki/Physics-informed_neural_networks 

close all;
clear; 
clc;

%% settings
% tSpan = [0,10];
% ctrlOptions = control_options();
[tSpan,~,paramOptions,ctrlOptions] = options();

%% generate data
% Feature data: 4-D initial state x0 + time interval
% the label data is a predicted state x=[q1,q2,q1dot,q2dot]
xTrain = [];
yTrain = [];
ds = load('trainingData.mat');
for i = 1:length(ds.samples)
    data = load(ds.samples{i,1}).state;
    t = data(1,:);
    x = data(4:9,:); % q1,q2,q1_dot,q2_dot,q1_ddot,q2_ddot
    numTime = length(t);
    for j = 1:numTime-1
        % indices = find(t <= tInit);
        % initIdx = indices(end);
        % x0 = x(:,initIdx); % Initial state 
        % t0 = t(initIdx); % Start time
        xTrain = [xTrain,[x(1:6,j); t(j)]];
        yTrain = [yTrain,x(1:6,j+1)];
    end
    %disp(i)
end
disp([num2str(length(xTrain)),' samples are generated for training.'])
save('wrkspc_c')

%% make dnn and train 
numIn = 7; % initial state, forces, times
numOut = 6; % q1,q2,q1dot,q2dot,q1ddot,q2ddot
numLayers = 4;
numNeurons = 128;
layers = featureInputLayer(numIn);
for i = 1:numLayers-1
    layers = [
        layers
        fullyConnectedLayer(numNeurons)
        tanhLayer];
end
layers = [
    layers
    fullyConnectedLayer(numOut)];

% convert the layer array to a dlnetwork object
net = dlnetwork(layers);
disp(net); 
% plot(net)
net = dlupdate(@double,net); % for better accuracy

% convert training data to formated dlarray
% 'C', channel, 'B', batch
xTrain = dlarray(xTrain,'CB'); 
yTrain = dlarray(yTrain,'CB');

% training options
numEpochs = 3000;
solverState = lbfgsState; 
% create a function handle containing the loss for the L-BFGS update, and 
% use 'dlfeval' to evaluate the 'dlgradient' inside the modelLoss function 
% using automatic differentiation. 
accfun = dlaccelerate(@modelLoss);
lossFcn = @(net) dlfeval(accfun,net,xTrain,yTrain);

monitor = trainingProgressMonitor;
monitor.Metrics = "TrainingLoss";
monitor.Info = ["LearningRate","Epoch","Iteration"];
monitor.XLabel = "Epoch";

% Train the model using custom training loop
% Use the full data set at each iteration. Update the network learnable
% parameters and solver state using 'lbfgsupdate', at the end of each
% iteration, update the training progress monitor.
for i = 1:numEpochs
    [net,solverState] = lbfgsupdate(net,lossFcn,solverState);
    updateInfo(monitor,Epoch=i);
    recordMetrics(monitor,i,TrainingLoss = solverState.Loss);
end

fname = "pinn_modelc.mat";
save(fname,"net");

%% plot training loss and RMSE
figure('Position',[500,100,800,400]); 
tiledlayout("vertical","TileSpacing","tight")
info = monitor.MetricData.TrainingLoss;
x = info(:,1);
y = info(:,2);
% z = info.ValidationRMSE(x);
smoothed_y = smoothdata(y,'gaussian');
% smoothed_z = movmean(z, window_size);
plot(x,y,'b-',x,smoothed_y,'r-',"LineWidth",2);
xlabel("Iteration","FontName","Arial")
ylabel("TrainingLoss","FontName","Arial")
legend("Original","Smoothed","location","best")
set(gca, 'FontSize', 15);
saveas(gcf,'training_c.png')

%%
% PINN
% A physics-Informed Neural Network (PINN) is a type of neural network
% architecture desigend to incorporate physical principles or equations
% into the learning process. In combines deep learning techniques with
% domain-specific knowledge, making it particularly suitable for problems
% governed by physics.
% In addition to standard data-driven training, PINNs utilize terms in the
% loss function to enforce consistency with know physical law, equations,
% and constraints. 
% https://en.wikipedia.org/wiki/Physics-informed_neural_networks 

close all;
clear; 
clc;

%% settings
% tSpan = [0,10];
% ctrlOptions = control_options();
[tSpan,~,paramOptions,ctrlOptions] = options();

%% generate data (WIP)
% Feature data: 4-D initial state x0 + time interval
% the label data is a predicted state x=[q1,q2,q1dot,q2dot]
xTrain = [];
yTrain = [];
ds = load('trainingData.mat');
for i = 1:length(ds.samples)
    data = load(ds.samples{i,1}).state;
    t = data(1,:);
    u = data(2:3,:);
    x = data(4:9,:); % q1,q2,q1_dot,q2_dot
    numTime = length(t);
    %for tInit = 0:9
    % indices = find(t <= tInit);
    initIdx = 1; % indices(end);
    x0 = x(5:6,initIdx); % Initial state
    u0 = u(:,initIdx); % Initial force
    t0 = t(initIdx); % Start time
    for j = initIdx+1:numTime
        xTrain = [xTrain,[x0; u0; t(j)-t0]]; %u(:,j);
        yTrain = [yTrain,x(:,j)];
    end
    %end
    %disp(i)
end
disp([num2str(length(xTrain)),' samples are generated for training.'])
save('wrkspc_b')

%% make dnn and train 
numIn = 5; % initial state, forces, times
numOut = 6; % q1,q2,q1dot,q2dot,q1ddot,q2ddot
numLayers = 4;
numNeurons = 128;
layers = featureInputLayer(numIn);
for i = 1:numLayers-1
    layers = [
        layers
        fullyConnectedLayer(numNeurons)
        tanhLayer];
end
layers = [
    layers
    fullyConnectedLayer(numOut)];

% convert the layer array to a dlnetwork object
net = dlnetwork(layers);
disp(net); 
% plot(net)
net = dlupdate(@double,net); % for better accuracy

% convert training data to formated dlarray
% 'C', channel, 'B', batch
xTrain = dlarray(xTrain,'CB'); 
yTrain = dlarray(yTrain,'CB');

% training options
numEpochs = 3000;
solverState = lbfgsState; 
% create a function handle containing the loss for the L-BFGS update, and 
% use 'dlfeval' to evaluate the 'dlgradient' inside the modelLoss function 
% using automatic differentiation. 
accfun = dlaccelerate(@modelLoss);
lossFcn = @(net) dlfeval(accfun,net,xTrain,yTrain);

monitor = trainingProgressMonitor;
monitor.Metrics = "TrainingLoss";
monitor.Info = ["LearningRate","Epoch","Iteration"];
monitor.XLabel = "Epoch";

% Train the model using custom training loop
% Use the full data set at each iteration. Update the network learnable
% parameters and solver state using 'lbfgsupdate', at the end of each
% iteration, update the training progress monitor.
for i = 1:numEpochs
    [net,solverState] = lbfgsupdate(net,lossFcn,solverState);
    updateInfo(monitor,Epoch=i);
    recordMetrics(monitor,i,TrainingLoss = solverState.Loss);
end

fname = "pinn_modelb.mat";
save(fname,"net");

%% plot training loss and RMSE
figure('Position',[500,100,800,400]); 
tiledlayout("vertical","TileSpacing","tight")
info = monitor.MetricData.TrainingLoss;
x = info(:,1);
y = info(:,2);
% z = info.ValidationRMSE(x);
smoothed_y = smoothdata(y,'gaussian');
% smoothed_z = movmean(z, window_size);
plot(x,y,'b-',x,smoothed_y,'r-',"LineWidth",2);
xlabel("Iteration","FontName","Arial")
ylabel("TrainingLoss","FontName","Arial")
legend("Original","Smoothed","location","best")
set(gca, 'FontSize', 15);
saveas(gcf,'training_b.png')

%% loss function
function [loss, gradients] = modelLoss_a(net,X,T)
    % make prediction
    Y = forward(net,X);
    dataLoss = l2loss(Y,T);
    
    % compute gradients using automatic differentiation
    q1 = Y(1,:);
    q2 = Y(2,:);
    q1d = Y(3,:);
    q2d = Y(4,:);
    q1dX = dlgradient(sum(q1d,'all'), X);
    q1dd = q1dX(5,:);
    q2dX = dlgradient(sum(q2d,'all'), X);
    q2dd = q2dX(5,:);
    q1X = dlgradient(sum(q1,'all'), X);
    q1d = q1X(5,:);
    q2X = dlgradient(sum(q2,'all'), X);
    q2d = q2X(5,:);
    f = physics_law_a([q1;q2],[q1d;q2d],[q1dd;q2dd]);
    zeroTarget = zeros(size(f),"like",f);
    %fT = physics_law(T,X);
    physicLoss = l2loss(f,zeroTarget);
    
    % total loss
    loss = dataLoss + physicLoss;
    gradients = dlgradient(loss, net.Learnables);
end

function [loss, gradients] = modelLoss(net,X,T)
    % make prediction
    Y = forward(net,X);
    dataLoss = l2loss(Y,T);
    
    f = physics_law(Y,X);
    fT = physics_law(T,X);
    physicLoss = l2loss(f,fT);
    
    % total loss
    loss = dataLoss + physicLoss;
    gradients = dlgradient(loss, net.Learnables);
end
