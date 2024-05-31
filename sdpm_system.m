function dxdt = sdpm_system(t,x,fMax,fSpan,fType)
    % force input
    F = force_function(t,fMax,fSpan,fType);
    %friction
    F_f = friction(x(2),F(1));
    % solve ODEs with force input
    dxdt = compute_xdot(x,F,F_f);
end
