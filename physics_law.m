function f = physics_law(x)
    q1 = x(1);
    q2 = x(2);
    q1dot = x(3);
    q2dot = x(4);
    q1ddot = x(5);
    q2ddot = x(6);
    [~,~,params,~] = options();
    % mass 
    m1 = params.M(1);
    m2 = params.M(2);
    l = params.L;
    c = params.C;
    k = params.K;
    g = params.G;
    A = [m1+m2 m2*l*cos(q2);m2*l*cos(q2) m2*l*l];
    B = [c*q1dot+m2*l*sin(q2)*q2dot*q2dot-k*q1; m2*g*l*sin(q2)];
    % solve the Lagrange equation F = M*q_ddot + V*q_dot + G 
    f = A*[q1ddot;q2ddot] + B;
end