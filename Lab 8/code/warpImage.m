function I = warpImage(I_R, W)
    
    I=zeros(size(I_R));
    
    [rows, cols]=size(I_R);
    
    for i=1:rows
        for j=1:cols
        
            w_coord=W*[j; i; 1];
            
            u=w_coord(1);
            v=w_coord(2);
            u1 = floor(u); v1 = floor(v);
            a = u-u1; b = v-v1;
            if u1 > 0 && u1+1 <= cols && v1 > 0 && v1+1 <= rows
                I(i,j) = (1-b) * ((1-a)*I_R(v1,u1) + a*I_R(v1,u1+1)) + b * ((1-a)*I_R(v1+1,u1) + a*I_R(v1+1,u1+1));
            end
        end
    end
end
            
