function y = sdpm_simulation(tSpan, x0, ctrlOptions)
    % ODE solver
    %opts = odeset('RelTol',1e-8,'AbsTol',1e-10); %,'OutputFcn',@odeplot,'Stats','on'
    [t,x] = ode45(@(t,x) sdpm_system(t,x,ctrlOptions.fMax,ctrlOptions.fSpan,ctrlOptions.fType),tSpan,x0); % ,opts
    
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
