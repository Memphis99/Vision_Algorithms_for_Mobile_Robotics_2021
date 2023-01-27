function patch = getWarpedPatch(I, W, x_T, r_T)
% x_T is 1x2 and contains [x_T y_T] as defined in the statement. patch is
% (2*r_T+1)x(2*r_T+1) and arranged consistently with the input image I.

    patch=zeros(2*r_T+1, 2*r_T+1);
    [rows, cols]=size(I);
    
    for i=-r_T:r_T
        for j=-r_T:r_T
            w_coord=x_T'+W*[j; i; 1];
            
            u=w_coord(1);
            v=w_coord(2);
            u1 = floor(u); v1 = floor(v);
            a = u-u1; b = v-v1;
            if u1 > 0 && u1+1 <= cols && v1 > 0 && v1+1 <= rows
                patch(r_T+i+1, r_T+j+1) = (1-b) * ((1-a)*I(v1,u1) + a*I(v1,u1+1)) + b * ((1-a)*I(v1+1,u1) + a*I(v1+1,u1+1));
            end
        end
    end
end

    
