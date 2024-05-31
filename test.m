clc; clear; close all;

% lossType = "PgNN";
lossType = "PiNN";
task = "predict_next";
% task = "predict_arbitrary";
seq_steps = 20;
t_force_stop = 1;
training_percent = 0.8;
max_epochs = 60;
tSpan = [0,25];
ds = load('trainingData.mat');
num_samples = size(ds.samples,1);
states = {};
times = [];
labels = [];
data = load(ds.samples{1,1}).state;
[n,state,time,label] = create_data_next(data,seq_steps,t_force_stop);
for j=1:n
    states{end+1} = state{j};
    times = [times,time(j)];
    labels = [labels,label(:,j)];
end

