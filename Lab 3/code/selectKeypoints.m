function keypoints = selectKeypoints(scores, num, r)
% Selects the num best scores as keypoints and performs non-maximum 
% supression of a (2r + 1)*(2r + 1) box around the current maximum.

    keypoints=[];
    
    scoresp=padarray(scores, [r, r], 0, 'both');
    
    [rs, cs]=size(scoresp); %find size of scores matrix
    
    for i=1:num
        s=scoresp(:); %create column vector of elements of scores matrix
        [M, I]=max(s); %find max value and index of scores vector
        [row, col]=ind2sub([rs, cs], I); %find coord of max value
        scoresp(row-r:row+r, col-r:col+r)=0; %put 0 on neighbors
        K=[row; col];
        keypoints=[keypoints, K];
    end
end
