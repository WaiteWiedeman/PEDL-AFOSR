%%
close all;
clear; 
clc;

%% Simulate SDPM w/ Coulomb's friction consideration
% Mass-Spring-Damper-Pendulum Dynamics System Parameters
[tSpan,x0,paramOptions,ctrlOptions] = options();
flag = "sdpm"; 
% flag = "sdpmloop";
% flag = "jacobian";
% flag = "vdp";
% flag = "mck";
% flag = "mckloop";
tSpan = [0,10];
ctrlOptions.fMax = [10;0]; % max forces

% solve ode
% opts = odeset('RelTol',1e-5,'AbsTol',1e-7,'OutputFcn',@odeplot,'Stats','on','Events',@EventsFcn,'Jacobian',@(t,x) jac(t,x,ctrlOptions));
switch flag
    case "sdpm"
        % ode15s, ode23s, ode23t, ode23tb  ??
        opts = odeset('RelTol',1e-5,'AbsTol',1e-7,'OutputFcn',@odeplot,'Stats','on'); %
        [t,x] = ode45(@(t,x) sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType),tSpan,x0,opts); % ,opts
  
    case "sdpmloop"
        opts = odeset('OutputFcn',@odeplot,'Events',@EventsFcn); %'RelTol',1e-5,'AbsTol',1e-7,
        sol = ode45(@(t,x) sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType),tSpan,x0,opts); % ,opts
        t = sol.x';
        x = sol.y';
        % sz = size(t);
        % disp(sz)
        while t(end) < tSpan(2)
            sol = ode45(@(t,x) sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType),[t(end) tSpan(2)],x(end,:),opts); % ,opts
            t = [t; sol.x'];
            x = [x; sol.y'];
        end

    case "jacobian"
        % ode15s, ode23s, ode23t, ode23tb  ??
        opts = odeset('RelTol',1e-3,'AbsTol',1e-6,'OutputFcn',@odeplot,'Stats','on','Jacobian',@(t,x) jac(t,x,ctrlOptions)); %
        [t,x] = ode23s(@(t,x) sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType),tSpan,x0,opts); % ,opts

    case "vdp"
        % ode15s, ode23s, ode23t, ode23tb  ??
        opts = odeset('OutputFcn',@odeplot,'Stats','on'); %
        [t,x] = ode15s(@vdp1000,[0 3000],[2; 0],opts);    

    case "mck"
        % ode15s, ode23s, ode23t, ode23tb  ??
        opts = odeset('RelTol',1e-4,'AbsTol',1e-7,'OutputFcn',@odeplot,'Stats','on'); %
        [t,x] = ode23s(@mck_Coulomb,tSpan,[1;0],opts); % ,opts

    case "mckloop"
        opts = odeset('OutputFcn',@odeplot,'Events',@EventsFcn); %'RelTol',1e-5,'AbsTol',1e-7,
        sol = ode45(@mck_Coulomb,tSpan,[1;0],opts); % ,opts
        t = sol.x';
        x = sol.y';
        % sz = size(t);
        % disp(sz)
        while t(end) < tSpan(2)
            sol = ode45(@mck_Coulomb,[t(end) tSpan(2)],x(end,:),opts); % ,opts
            t = [t; sol.x'];
            x = [x; sol.y'];
        end

    otherwise
        disp('idk')
end

%% Plot
switch flag
    case "vdp"
        % vdp plot
        figure;
        plot(t,x(:,1),'-o');
        title('Solution of van der Pol Equation, \mu = 1000');
        xlabel('Time t');
        ylabel('Solution y_1');

    case {"mck","mckloop"}
        % mck plot
        figure;
        plot(t,x(:,1),'-o',t,x(:,2),'-o');
        title('Solution of mck system w/ Coulomb friction');
        xlabel('Time t');
        ylabel('Displacement');

    otherwise
        size = length(t);
        % control inputs
        y = zeros(size,9);
        for i = 1:size
            F = force_function(t(i),ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType);
            xdot = compute_xdot(x(i,:),F);
            y(i,1) = t(i); % t
            y(i,2) = F(1); % f1
            y(i,3) = F(2); % f2
            y(i,4) = x(i,1); % q1
            y(i,5) = x(i,3); % q2
            y(i,6) = x(i,2); % q1_dot
            y(i,7) = x(i,4); % q2_dot
            y(i,8) = xdot(2); % q1_ddot
            y(i,9) = xdot(4); % q2_ddot
        end
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
         
end

%% functions
function [position,isterminal,direction] = EventsFcn(t,y)
    position = y(2); % The value that we want to be zero
    isterminal = 1;  % Halt integration
    direction = 0;   % The zero can be approached from either direction
end

function dfdx = jac(t,x,ctrlOptions)
    dxdt = sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType);
    % get parameters
    [~,~,params,~] = options();
    % parameters 
    m1 = params.M(1);
    m2 = params.M(2);
    l = params.L;
    c = params.C;
    k = params.K;
    g = params.G;
    mu_k = params.mu_k;
    dfdx = [0 1 0 0;
        1/(m1+m2)*-k 1/(m1+m2)*(-dxdt(2)*dirac(x(2))*mu_k*(m1+m2)*g - c)...
        1/(m1+m2)*(m2*l*dxdt(4)*x(4)*sin(x(3)) + m2*l*x(4)^3*cos(x(3))) 1/(m1+m2)*(2*m2*l*x(4)*sin(x(3)));
        0 0 0 1;
        0 0 1/(m1+m2)*(m2*l*dxdt(2)*x(4)*sin(x(3)) - m2*l*x(4)*cos(x(3))) 0];
end

function dxdt = vdp1000(t,x)
    %VDP1000  Evaluate the van der Pol ODEs for mu = 1000.
    dxdt = zeros(2,1);
    dxdt(1) = x(2);
    dxdt(2) = 1000*(1-x(1)^2)*x(2)-x(1);
end

function dxdt = mck_Coulomb(t,x)
% get parameters
    [~,~,params,~] = options();
    % parameters 
    m = params.M(1);
    c = params.C;
    k = params.K;
    g = params.G;
    mu_k = 0.5;
    dxdt = zeros(2,1);
    dxdt(1) = x(2);
    dxdt(2) = -k/m*x(1) - c/m*x(2) - sign(x(2))*mu_k*m*g;
end
