function disp_img = getDisparity(left_img, right_img, patch_radius, min_disp, max_disp)
% left_img and right_img are both H x W and you should return a H x W
% matrix containing the disparity d for each pixel of left_img. Set
% disp_img to 0 for pixels where the SSD and/or d is not defined, and for d
% estimates rejected in Part 2. patch_radius specifies the SSD patch and
% each valid d should satisfy min_disp <= d <= max_disp.

            
    dim=size(left_img); %get dimension of image
    
    disp_img=zeros(dim); %init the d matrix at 0
    
    for row=1+patch_radius:dim(1)-patch_radius %exclude rows on border
        for col=1+patch_radius+max_disp:dim(2)-patch_radius %exlude col onborder and smaller than max_disp
            
            left_patch=left_img(row-patch_radius:row+patch_radius, col-patch_radius:col+patch_radius); %select patch on left point
            left_patch=left_patch(:)'; %put patch on row
            
            right_patch=[]; %init the right patches matrix for every left point
            
            for d=min_disp:max_disp %analyze the different possible disparities
                p1=[row, col-d]; %right point is translated only on x coord of d
                
                rpatch=right_img(p1(1)-patch_radius:p1(1)+patch_radius, p1(2)-patch_radius:p1(2)+patch_radius);
                
                rpatch=rpatch(:)';
                
                right_patch=[right_patch; rpatch]; %add every patch to a matrix
                
            end
            
            right_patch=single(right_patch); %convert type for the pdist2
            left_patch=single(left_patch);
            
            
            %get SSD values and left patch indexes of the 3 smaller points, in crescent order 
            [SSD, index]=pdist2(right_patch, left_patch, 'squaredeuclidean', 'Smallest', 3);
                     
            
            %delete point that have d max or min, and have more than 2 values bigger than 1.5*minSSD
            if index(1)+4~=min_disp && index(1)+4~=max_disp && SSD(3)>1.5*SSD(1)
                
                %find the SSD values for the indexes around d*
                SSD=pdist2(right_patch(index(1)-1:index(1)+1, :), left_patch, 'squaredeuclidean');
                
                %compute the coefficents of the function that interpolate the 3 points
                coeff=polyfit([index(1)-1:index(1)+1], SSD, 2);
                
                first_der = polyder(coeff); %first derivative
                
                min_point = roots(first_der); % min point

                disp_img(row, col)=min_point + min_disp -1;
            end
        end
    end
end
                
    
    
    
