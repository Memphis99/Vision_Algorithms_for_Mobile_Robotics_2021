function descriptors = describeKeypoints(img, keypoints, r)
    % Returns a (2r+1)^2xN matrix of image patch vectors based on image
    % img and a 2xN matrix containing the keypoint coordinates.
    % r is the patch "radius".

    %pad img with radius r zeros, to avoid problems with edge pixels
    imgp=padarray(img, [r, r], 0, 'both');
    
    descriptors=[];

    [rk, ck]=size(keypoints);

    for i=1:ck
        rowk=keypoints(1, i); %row of ith keypoint
        colk=keypoints(2, i); %column of ith keypoint
        D=imgp(rowk-r:rowk+r, colk-r:colk+r); %take pixel values of patch around ith keypoint
        d=D(:); %dispose D in column
        descriptors=[descriptors, d]; %add ith keypoint values to matrix
    end
end
    
    
