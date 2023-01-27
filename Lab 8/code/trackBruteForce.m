function [dx, ssds] = trackBruteForce(I_R, I, x_T, r_T, r_D)
% I_R: reference image, I: image to track point in, x_T: point to track,
% expressed as [x y]=[col row], r_T: radius of patch to track, r_D: radius
% of patch to search dx within; dx: translation that best explains where
% x_T is in image I, ssds: SSDs for all values of dx within the patch
% defined by center x_T and radius r_D.
    
    patch_R=getWarpedPatch(I_R, [1, 0, 0; 0, 1, 0], x_T, r_T);
 
    ssds=[];
    
    for i=-r_D:r_D
        for j=-r_D:r_D
            W=getSimWarp(j, i, 0, 1);
            patch=getWarpedPatch(I, W, x_T, r_T);
            
            ssd=sum((patch-patch_R).^2, 'all');
            
            ssds=[ssds, ssd];
            
            if (i==-r_D && j==-r_D) || ssd<minssd
                minssd=ssd;
                dx=[j, i];
            end
        end
    end
    
    ssds=reshape(ssds, 2*r_D+1, 2*r_D+1);
end
            
    
                
    
    
