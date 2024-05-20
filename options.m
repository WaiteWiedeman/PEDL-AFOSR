function [tSpan, x0, paramOptions, ctrlOptions] = options()
    tSpan = [0,10]; 
    x0 = [0;0;0;0];
    % system parameters
    paramOptions = struct();
    paramOptions.K = 3;
    paramOptions.C = 1;
    paramOptions.L = 0.5;
    paramOptions.G = 9.8;
    paramOptions.M = [1;0.5];
    paramOptions.mu_k = 0.05;
    % control input
    ctrlOptions = struct();
    ctrlOptions.fMax = [10;0];
    ctrlOptions.fSpan = [0,1];
    ctrlOptions.fType = "constant";
end
