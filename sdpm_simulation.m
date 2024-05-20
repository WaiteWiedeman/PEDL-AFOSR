function y = sdpm_simulation(tSpan, x0, ctrlOptions)
    % ODE solver
    % ode15s, ode23s, ode23t, ode23tb  ??
    % opts = odeset('RelTol',1e-5,'AbsTol',1e-7,'OutputFcn',@odeplot,'Stats','on','Events',@EventsFcn,'Jacobian',@(t,x) jac(t,x,ctrlOptions));
    opts = odeset('RelTol',1e-5,'AbsTol',1e-7,'OutputFcn',@odeplot,'Stats','on','Events',@EventsFcn); %
    sol = ode45(@(t,x) sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType),tSpan,x0,opts); % ,opts
    t = sol.x;
    x = sol.y;
    sz = size(t);
    disp(sz)
    for i = 1:2
        sol = ode45(@(t,x) sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType),[t(end) tSpan(2)],x(:,end),opts); % ,opts
        disp
        t = [t; sol.x];
        x = [x; sol.y];
    end
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
end

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
