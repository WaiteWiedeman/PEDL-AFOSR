function F_f = friction(v,F_app)
    % system parameters
    [~,~,params,~] = options();
    % parameters 
    M1 = params.M(1);
    M2 = params.M(2);
    G = params.G;
    mu_k = params.mu_k;
    mu_s = params.mu_s;
    N = (M1+M2)*G;
    if abs(v) < 1e-3
        F_f = min(F_app,mu_s*N); % static friciton
    else
        F_f = mu_k*N*tanh(100*v); % kinetic friction tanh(100*v) min(1, max(-1, 50*v)) sign(v)
    end
end