function YF = physics_law(Y)
    [~,~,params,~] = options();
    % mass 
    m1 = params.M(1);
    m2 = params.M(2);
    l = params.L;
    c = params.C;
    k = params.K;
    g = params.G;
    mu_k = params.mu_k;

    q1 = Y(1,:);
    q2 = Y(2,:);
    q1d = Y(3,:);
    q2d = Y(4,:);
    q1dd = Y(5,:);
    q2dd = Y(6,:);

    %Coulomb friction
    F_f = friction(q1d,0); %X(5,:)
    
    % solve the Lagrange equation F = M*q_ddot + V*q_dot + G 
    f1 = (m1+m2)*q1dd + m2*l*cos(q2).*q2dd + c*q1d - m2*l*sin(q2).*q2d.^2 + k*q1 + F_f;
    f2 = m2*l*cos(q2).*q1dd + m2*l*l*q2dd + m2*g*l*sin(q2);
    YF = [f1;f2];
end