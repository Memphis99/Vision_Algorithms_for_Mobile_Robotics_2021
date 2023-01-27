function error_function = alignmentError(x, pp_G_C, p_V_C)
    %Y=pp_G_C (3xN)
    %x=[twist, scale]'
    N=size(p_V_C, 2);
    
    twist=x(1:6, :);
    s_GV=x(7, :);
    
    H=twist2HomogMatrix(twist);
    R=H(1:3, 1:3);
    t=H(1:3, 4);
    S_GV=[s_GV*R, t;
          0, 0, 0, 1];
    
    f_x=S_GV*[p_V_C; ones(1, N)];
    f_x=f_x(1:3, :);
    
    error_function=f_x - pp_G_C;
end

