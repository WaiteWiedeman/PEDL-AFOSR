function F = physics_law_a(X,Xd,Xdd)
    q1 = X(1,:);
    q2 = X(2,:);
    q1d = Xd(1,:);
    q2d = Xd(2,:);
    q1dd = Xdd(1,:);
    q2dd = Xdd(2,:);
    % system parameters
    [~,~,params,~] = options();
    % mass 
    M1 = params.M(1);
    M2 = params.M(2);
    L = params.L;
    C = params.C;
    K = params.K;
    G = params.G;

    % Lagrangian equation
    fc = friction(q1d,0);
    f1 = (M1+M2)*q1dd + M2*L*(cos(q2).*q2dd) + C*q1d + M2*L*(sin(q2).*q2d.^2) + K*q1 + fc;
    f2 = M2*L*(cos(q2).*q1dd) + M2*L*L*q2dd + M2*G*L*sin(q2);
    F = [f1;f2];
end