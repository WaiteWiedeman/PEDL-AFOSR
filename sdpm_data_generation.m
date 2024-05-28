%%
close all;
clear; 
clc;

%% Generate Data for Training 
% Mass-Spring-Damper-Pendulum Dynamics System Parameters
[tSpan,x0,paramOptions,ctrlOptions] = options();
strType = {'constant','increase','decrease'};
tSpan = [0,25];

% simulate and save data
num_samples = 500;
samples = {};
for i = 1:num_samples
    ctrlOptions.fMax = rand(2,1).*[10;0]; % random max forces
    % ctrlOptions.fType = strType{randi(numel(strType))};
    % ctrlOptions.fSpan = [0,randi([1,5])];
    %tic
    y = sdpm_simulation(tSpan,x0,ctrlOptions);
    %toc
    state = y';
    fname=['data/input',num2str(i),'.mat'];
    save(fname, 'state');
    samples{end+1} = fname;
    % plot_states(y(:,1),y(:,4:9),paramOptions,ctrlOptions,[])
end
samples = reshape(samples,[],1); % make it row-based
save('trainingData.mat','samples');

%% plot data
t = y(:,1); % time
x = y(:,4:9); % states
[~,~,params,~] = options();
m1 = params.M(1);
m2 = params.M(2);
g = params.G;
mu_k = params.mu_k;
v = y(:,6); % velo
F_f_exp = -tanh(v/2)*mu_k*(m1+m2)*g; % friction modeled with exponential function
F_f_sig = -sign(v)*mu_k*(m1+m2)*g; % friction modeled with signum function
F_f_sat = -min(1, max(-1, 100*v))*mu_k*(m1+m2)*g;% friction modeled with saturation function

% plot box-pendulum system with Coulomb friction

figure('Position',[100,100,800,400]);

sgtitle("Displacement");

subplot(2,1,1);
plot(t,x(:,1),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$q_1$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);

subplot(2,1,2);
plot(t,x(:,2),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$q_2$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
xlabel("Time (s)");

figure('Position',[100,100,800,400]);
sgtitle("Velocity");
subplot(2,1,1);
plot(t,x(:,3),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\dot{q}_1$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);

subplot(2,1,2);
plot(t,x(:,4),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\dot{q}_2$",'Interpreter','latex');
% ylim([-5,5]);
xlabel("Time (s)");
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);

figure('Position',[100,100,800,400]);
sgtitle("Acceleration");

subplot(2,1,1);
plot(t,x(:,5),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\ddot{q}_1$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);

subplot(2,1,2);
plot(t,x(:,6),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\ddot{q}_2$",'Interpreter','latex');
% ylim([-5,5]);
xlabel("Time (s)");
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);

figure('Position',[100,100,800,400]);
sgtitle("Friction Force");
%
% subplot(3,1,1);
plot(t,F_f_sat,'Color','blue','LineWidth',2);
%xline(1,'k--', 'LineWidth',1);
ylabel("$F_f$ [N]",'Interpreter','latex');
% ylim([-5,5]);
xlabel("Time (s)");
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
%
% subplot(3,1,2);
% plot(t,F_f_sig,'Color','green','LineWidth',2);
% %xline(1,'k--', 'LineWidth',1);
% ylabel('signum');
% % ylim([-5,5]);
% xlabel("Time (s)");
% set(get(gca,'ylabel'),'rotation',0);
% set(gca,'fontsize',12);
%
% subplot(3,1,3);
% plot(t,F_f_exp,'Color','magenta','LineWidth',2);
% %xline(1,'k--', 'LineWidth',1);
% ylabel('exponential');
% % ylim([-5,5]);
% xlabel("Time (s)");
% set(get(gca,'ylabel'),'rotation',0);
% set(gca,'fontsize',12);
