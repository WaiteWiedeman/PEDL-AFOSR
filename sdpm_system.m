function dxdt = sdpm_system(t,x,fMax,fSpan,fType)
    % force input
    F = force_function(t,fMax,fSpan,fType);
    % solve ODEs with force input
    dxdt = compute_xdot(x,F);
end