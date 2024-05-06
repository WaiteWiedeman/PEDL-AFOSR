function plot_states(t,x,paramOptions,ctrlOptions,x_pred)
% Plot result
strK = sprintf('%.1f',paramOptions.K);
strC = sprintf('%.1f',paramOptions.C);
strL = sprintf('%.1f',paramOptions.L);
strM1 = sprintf('%.1f',paramOptions.M(1));
strM2 = sprintf('%.1f',paramOptions.M(2));
strF1 = sprintf('%.2f', ctrlOptions.fMax(1));
strF2 = sprintf('%.2f', ctrlOptions.fMax(2));

figure('Position',[100,100,800,400]);

% sgtitle(['K=',strK,' C=',strC,' L=',strL,' m1=',strM1,' m2=',strM2,' f1=',strF1,' f2=',strF2]);
sgtitle("Displacement");
numSteps = length(t);
numStates = length(x_pred);

subplot(2,1,1);
plot(t,x(:,1),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$q_1$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
hold on
if numStates == numSteps
    plot(t,x_pred(:,1),'Color','red','LineWidth',2,'LineStyle','--');
end
legend("Reference","Prediction");

subplot(2,1,2);
plot(t,x(:,2),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$q_2$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
xlabel("Time (s)");
hold on
if numStates == numSteps
    plot(t,x_pred(:,2),'Color','red','LineWidth',2,'LineStyle','--');
end

figure('Position',[100,100,800,400]);
sgtitle("Velocity");
subplot(2,1,1);
plot(t,x(:,3),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\dot{q}_1$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
hold on
if numStates == numSteps
    plot(t,x_pred(:,3),'Color','red','LineWidth',2,'LineStyle','--');
end
legend("Reference","Prediction");

subplot(2,1,2);
plot(t,x(:,4),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\dot{q}_2$",'Interpreter','latex');
% ylim([-5,5]);
xlabel("Time (s)");
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
hold on
if numStates == numSteps
    plot(t,x_pred(:,4),'Color','red','LineWidth',2,'LineStyle','--');
end

figure('Position',[100,100,800,400]);
sgtitle("Acceleration");

subplot(2,1,1);
plot(t,x(:,5),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\ddot{q}_1$",'Interpreter','latex');
% ylim([-5,5]);
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
hold on
if numStates == numSteps
    plot(t,x_pred(:,5),'Color','red','LineWidth',2,'LineStyle','--');
end
legend("Reference","Prediction");

subplot(2,1,2);
plot(t,x(:,6),'Color','blue','LineWidth',2);
xline(1,'k--', 'LineWidth',1);
ylabel("$\ddot{q}_2$",'Interpreter','latex');
% ylim([-5,5]);
xlabel("Time (s)");
set(get(gca,'ylabel'),'rotation',0);
set(gca,'fontsize',12);
hold on
if numStates == numSteps
    plot(t,x_pred(:,6),'Color','red','LineWidth',2,'LineStyle','--');
end

end