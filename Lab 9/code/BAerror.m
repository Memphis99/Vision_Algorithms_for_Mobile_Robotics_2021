function error_function = BAerror(x, observations, K)

    n_frames=observations(1);
    m_landmarks=observations(2);
    
    twist_vectors=x(1:6*n_frames, 1);
    twist_vectors=reshape(twist_vectors', [6, n_frames]);
    
    landmarks=x(6*n_frames+1:6*n_frames+3*m_landmarks, 1);
    landmarks=reshape(landmarks', [3, m_landmarks]);
    
    
    purged_observations=observations(3:end, 1)';
    Y=[];
    f_x=[];
    for i=1:n_frames
        H=twist2HomogMatrix(twist_vectors(:, i));
        R=H(1:3, 1:3);
        t=H(1:3, 4);
        H=[inv(R), -inv(R)*t];
        
        k_obs_land=purged_observations(1);
        purged_observations=purged_observations(2:end);
        
        twoD_positions=purged_observations(1:2*k_obs_land);
        twoD_positions=reshape(twoD_positions, [2, k_obs_land]);
        twoD_positions=flip(twoD_positions);
        
        purged_observations=purged_observations(2*k_obs_land+1:end);
        
        indices=purged_observations(1:k_obs_land);
        
        Y=[Y; twoD_positions(:)];
        reprojections=reprojectPoints(landmarks(:, indices)', H, K)';
        
        purged_observations=purged_observations(k_obs_land+1:end);
        
        f_x=[f_x; reprojections(:)];
    end
    
    error_function=f_x - Y;
end


