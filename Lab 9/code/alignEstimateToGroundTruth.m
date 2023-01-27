function p_G_C = alignEstimateToGroundTruth(pp_G_C, p_V_C)
% Returns the points of the estimated trajectory p_V_C transformed into the
% ground truth frame G. The similarity transform Sim_G_V is to be chosen
% such that it results in the lowest error between the aligned trajectory
% points p_G_C and the points of the ground truth trajectory pp_G_C. All
% matrices are 3xN.
    
    N=size(p_V_C, 2);

    twist0=HomogMatrix2twist(eye(4));
    x0=[twist0; 1];
    
    error_function=@(x)alignmentError(x, pp_G_C, p_V_C);
    options = optimoptions(@lsqnonlin,'Display','iter');
    
    x = lsqnonlin(error_function, x0, [], [], options);
    
    
    twist=x(1:6, :);
    s_GV=x(7, :);
    
    H=twist2HomogMatrix(twist);
    R=H(1:3, 1:3);
    t=H(1:3, 4);
    S_GV=[s_GV*R, t;
          0, 0, 0, 1];
    
    p_G_C=S_GV*[p_V_C; ones(1, N)];
end
    

    
