function [delta_keypoint, keep] = trackKLTRobustly(I_prev, I, keypoint, ...
    r_T, num_iters, lambda)
% I_prev: reference image, I: image to track point in, keypoint: point to 
% track, expressed as [x y]=[col row], r_T: radius of patch to track, 
% num_iters: amount of iterations to run, lambda: bidirectional error
% threshold; delta_keypoint: delta by which the keypoint has moved between 
% images, (2x1), keep: true if the point tracking has passed the
% bidirectional error test.

    [W1, ~] = trackKLT(I_prev, I, keypoint, r_T, num_iters);
    new_kp=keypoint'+W1(:, 3);
    
    [W2, ~] = trackKLT(I, I_prev, new_kp', r_T, num_iters);
    rep_keypoint=new_kp+W2(:, 3);
    
    delta_keypoint=W1(:, 3);
    
    error=rep_keypoint-keypoint';
    
    keep=0;
    if norm(error)<lambda
        keep=1;
    end
end
    
