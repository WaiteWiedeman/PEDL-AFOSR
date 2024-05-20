%%
close all;
clear; 
clc;

%% Generate Data for Training 
% Mass-Spring-Damper-Pendulum Dynamics System Parameters
[tSpan,x0,paramOptions,ctrlOptions] = options();
strType = {'constant','increase','decrease'};
tSpan = [0,5];

% simulate and save data
num_samples = 1;
samples = {};
for i = 1:num_samples
    ctrlOptions.fMax = rand(2,1).*[3;0]; % random max forces
    % ctrlOptions.fType = strType{randi(numel(strType))};
    % ctrlOptions.fSpan = [0,randi([1,5])];
    tic
    y = sdpm_simulation(tSpan,x0,ctrlOptions);
    toc
    state = y';
    fname=['data/input',num2str(i),'.mat'];
    save(fname, 'state');
    samples{end+1} = fname;
    % plot_states(y(:,1),y(:,4:9),paramOptions,ctrlOptions,[])
end
samples = reshape(samples,[],1); % make it row-based
save('trainingData.mat','samples');

%% plot data
t = y(:,1);
f1 = y(:,2); % 
f2 = y(:,3); 
q1 = y(:,4); % q1
q2 = y(:,5); % q2
q1_dot = y(:,6); % q1_dot
q2_dot = y(:,7); % q2_dot
q1_ddot = y(:,8); % q1_ddot
q2_ddot = y(:,9); % q2_ddot
figure;
plot(y(:,1),y(:,4:9))
