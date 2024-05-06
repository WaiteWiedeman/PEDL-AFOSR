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
num_samples = 400;
samples = {};
for i = 1:num_samples
    ctrlOptions.fMax = rand(2,1).*[10;0]; % random max forces
    % ctrlOptions.fType = strType{randi(numel(strType))};
    % ctrlOptions.fSpan = [0,randi([1,5])];
    y = sdpm_simulation(tSpan,x0,ctrlOptions);
    state = y';
    fname=['data/input',num2str(i),'.mat'];
    save(fname, 'state');
    samples{end+1} = fname;
    % plot_states(y(:,1),y(:,4:9),paramOptions,ctrlOptions,[])
end
samples = reshape(samples,[],1); % make it row-based
save('trainingData.mat','samples');
