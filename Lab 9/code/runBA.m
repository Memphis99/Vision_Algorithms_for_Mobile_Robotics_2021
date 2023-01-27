function hidden_state = runBA(hidden_state, observations, K)
% Update the hidden state, encoded as explained in the problem statement,
% with 20 bundle adjustment iterations.

    x0=hidden_state;
    
    error_function=@(x)BAerror(x, observations, K);
    %options = optimoptions(@lsqnonlin,'Display','iter', 'MaxIterations', 2);
    
    
    n_frames=observations(1)
    purged_observations=observations(3:end, 1)';
    
    
    size_error=(size(purged_observations, 2) - n_frames)/3;
    M=spalloc(2*size_error, size(x0, 1), n_frames*6*2*size_error + 3*2*size_error);
    
    s=0;
    ind_M=0;
    for i=1:n_frames
        
        k_obs_land=purged_observations(s+1);
        
        indices=purged_observations(s+2*k_obs_land+2:s+3*k_obs_land+1);
        indices=3*indices + 6*n_frames;
        M(ind_M+1:ind_M+2*k_obs_land, 6*i-5:6*i)=1;
        
        h=0;
        for k=ind_M+1:ind_M+2*k_obs_land
            h=h+0.5;
            M(k, indices(round(h))-2:indices(round(h)))=1;
        end
        
        s=s+3*k_obs_land+1;
        ind_M=ind_M+2*k_obs_land;
    end
    
    spy(M);
    
    options = optimoptions(@lsqnonlin,'Display','iter', 'JacobPattern', M);
    x = lsqnonlin(error_function, x0, [], [], options);
    
    hidden_state=x;
end
        
        
        
        
    
