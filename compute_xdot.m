function dxdt = compute_xdot(x,F)
    % x(1) - position of mass 1
    % x(2) - velocity of mass 1
    % x(3) - angle of mass 2
    % x(4) - angular velocity of mass 2
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
    % differential equations
    dxdt = zeros(4,1); % velocity of mass 1
    dxdt(1) = x(2);
    dxdt(2) = (1/(m1+m2))*(F(1) - min(1, max(-1, x(2)))*mu_k*(m1+m2)*g - ... %sign(x(2))  min(1, max(-1, x(2))) tanh(x(2)/2) 
        m2*l*dxdt(4)*cos(x(3)) + m2*l*x(4)^2*sin(x(3)) - k*x(1) - c*x(2)); % acceleration of mass 1
    dxdt(3) = x(4); % angular velocity of mass 2
    dxdt(4) = (1/m2/l/l)*(F(2) - m2*l*dxdt(2)*cos(x(3)) - m2*l*sin(x(3))); % angular acceleration of mass 2
end