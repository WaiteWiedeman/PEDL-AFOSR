function xdot = compute_xdot(x,F)
    q1 = x(1);
    q1dot = x(2);
    q2 = x(3);
    q2dot = x(4);
    [~,~,params,~] = options();
    % mass 
    m1 = params.M(1);
    m2 = params.M(2);
    l = params.L;
    c = params.C;
    k = params.K;
    g = params.G;

    % solve the Lagrange equation F = M*q_ddot + V*q_dot + G
    % compute q_ddot: M*q_ddot = F - V*q_dot - G, using linsolve
    A = [m1+m2 m2*l*cos(q2);m2*l*cos(q2) m2*l*l];
    B = [F(1)-c*q1dot+m2*l*sin(q2)*q2dot*q2dot-k*q1; F(2)-m2*g*l*sin(q2)];
    qddot = linsolve(A,B);

    xdot = zeros(4,1);
    xdot(1) = q1dot;
    xdot(2) = qddot(1);
    xdot(3) = q2dot;
    xdot(4) = qddot(2);
end