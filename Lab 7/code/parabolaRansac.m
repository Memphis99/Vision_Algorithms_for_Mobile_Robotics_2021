function [best_guess_history, max_num_inliers_history] = parabolaRansac(data, max_noise)
% data is 2xN with the data points given column-wise, 
% best_guess_history is 3xnum_iterations with the polynome coefficients 
%   from polyfit of the BEST GUESS SO FAR at each iteration columnwise and
% max_num_inliers_history is 1xnum_iterations, with the inlier count of the
%   BEST GUESS SO FAR at each iteration.

    
    s=3;
    
    best_guess_history=zeros(3, 100);
    max_num_inliers_history=zeros(1, 100);

    for i=1:100
        points = datasample(data, s, 2, 'Replace', false);

        coeff = polyfit(points(1, :)', points(2, :)', 2);
        
        val = polyval(coeff, data(1, :)');
        
        diff=abs(val - data(2, :)');
        
        num_inliers = length(find(diff<=max_noise));
        
        if i==1
            best_guess_history(:, i)=coeff.';
            max_num_inliers_history(i)=num_inliers;
        
        elseif num_inliers > max_num_inliers_history(i-1)
            best_guess_history(:, i)=coeff.';
            max_num_inliers_history(i)=num_inliers;
        
        else
            best_guess_history(:, i)=best_guess_history(:, i-1);
            max_num_inliers_history(i)=max_num_inliers_history(i-1);
        end
    end 
end