function [points, intensities] = disparityToPointCloud(disp_img, K, baseline, left_img)
% points should be 3xN and intensities 1xN, where N is the amount of pixels
% which have a valid disparity. I.e., only return points and intensities
% for pixels of left_img which have a valid disparity estimate! The i-th
% intensity should correspond to the i-th point.

    dim=size(left_img);
        
    points=[];
    intensities=[];

    for x=1:dim(2) %x=columns
        for y=1:dim(1) %y=rows
            p0=[x, y]; %points are [x, y, z], not [row, col]
            d=disp_img(p0(2), p0(1)); %but disp_img ask for [row, col], invert coord
            
            if d~=0
                p1=[p0(1)-d, p0(2)]; %the disparity is on the x coord
                
                p0_cap=K^-1*[p0(1), p0(2), 1].';
                p1_cap=K^-1*[p1(1), p1(2), 1].';
                
                A=[p0_cap(1), -p1_cap(1); p0_cap(2), -p1_cap(2); 1 -1];
                
                b=[baseline; 0; 0];
                
                lambda=(A.'*A)^-1*A.'*b;
                
                P=lambda(1)*K^-1*[p0(1); p0(2); 1];
                
                points=[points, P];
                
                intensities=[intensities, left_img(p0(2), p0(1))]; %left_img asks for [row, col]
                
            end
        end
    end
end
            
