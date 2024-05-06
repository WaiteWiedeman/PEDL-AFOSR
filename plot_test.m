%%
close all;
clear;
clc;

%%
m100 = load("training/PiNN_100.mat");
m200 = load("training/PiNN_200.mat");
m300 = load("training/PiNN_300.mat");
m400 = load("training/PiNN_400.mat");
m500 = load("training/PiNN_500.mat");
m600 = load("training/PiNN_600.mat");
m700 = load("training/PiNN_700.mat");

sample_number = [100,200,300,400,500,600,700];
train_rmse = [0.10,0.12,0.13,0.14,0.11,0.13,0.14];
validation_rmse = [0.13,0.12,0.13,0.12,0.13,0.13,0.13];
test_rmse = [mean(m100.err_list,'all'), ...
    mean(m200.err_list,'all'), ...
    mean(m300.err_list,'all'), ...
    mean(m400.err_list,'all'), ...
    mean(m500.err_list,'all'), ...
    mean(m600.err_list,'all'), ...
    mean(m700.err_list,'all')];

figure('Position',[100,100,800,400]);
plot(sample_number,train_rmse,'Color','black','LineWidth',2,'LineStyle','-');
hold on
plot(sample_number,validation_rmse,'Color','blue','LineWidth',2,'LineStyle','-');
hold on
plot(sample_number, test_rmse,'Color','red','LineWidth',2,LineStyle='-');
hold on
scatter(sample_number,train_rmse,'filled','black');
hold on
scatter(sample_number,validation_rmse,'filled','blue');
hold on
scatter(sample_number,test_rmse,'filled','red');

title("Model Performance vs. Sample Size")
ylabel("RMSE");
xlabel("Number of Training Samples");
legend('Train','Validation','Test');
xticks([100,200,300,400,500,600,700]);

%%
figure('Position',[100,100,800,400]);
err1 = mean(m100.err_list,1);
err2 = mean(m200.err_list,1);
err3 = mean(m300.err_list,1);
err4 = mean(m400.err_list,1);
err5 = mean(m500.err_list,1);
err6 = mean(m600.err_list,1);
err7 = mean(m700.err_list,1);
t = linspace(1,10,50);
% plot(t,err1,'Color','black','LineWidth',2);
% hold on
% plot(t,err2,'Color','blue','LineWidth',2);
% hold on
% plot(t,err3,'Color','red','LineWidth',2);
% hold on
plot(t,err4,'Color','blue','LineWidth',2);
% hold on
% plot(t,err5,'Color','yellow','LineWidth',2);
% hold on
% plot(t,err6,'Color','cyan','LineWidth',2);
% hold on
% plot(t,err7,'Color','magenta','LineWidth',2);

title("Prediction Errors");
ylabel("RMSE");
xlabel("Time (s)");
xticks([1,2,3,4,5,6,7,8,9,10]);