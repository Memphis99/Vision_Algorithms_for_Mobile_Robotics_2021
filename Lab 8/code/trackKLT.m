function [W, p_hist] = trackKLT(I_R, I, x_T, r_T, num_iters)
% I_R: reference image, I: image to track point in, x_T: point to track,
% expressed as [x y]=[col row], r_T: radius of patch to track, num_iters:
% amount of iterations to run; W(2x3): final W estimate, p_hist 
% (6x(num_iters+1)): history of p estimates, including the initial
% (identity) estimate

    [rows, cols]=size(I);
    
    p_hist=[1; 0; 0; 1; 0; 0];
    
    patch_R=getWarpedPatch(I_R, reshape(p_hist, 2, 3), x_T, r_T);
    i_R=patch_R(:);
    
    for k=1:num_iters
        patch=getWarpedPatch(I, reshape(p_hist(:, end), [2, 3]), x_T, r_T);
        
%         figure(5);
%         subplot(3,1,1);
%         imagesc([patch, patch_R, patch_R - patch]);
%         axis equal;
%         title('IR, I, IR-I');
        
        patch_paddedx=padarray(patch, [0, 1], 'replicate');
        patch_paddedy=padarray(patch, [1, 0], 'replicate');
        
        Ix=conv2(patch_paddedx, [1, 0, -1], 'valid');
        Iy=conv2(patch_paddedy, [1, 0, -1].', 'valid');
        
        
%         subplot(3,1,2);
%         imagesc([Ix, Iy]);
%         axis equal;
%         title('X-Y gradient');
        
        ix=Ix(:);
        iy=Iy(:);
        
        gradients=[ix, iy];
        
        i_dp=zeros((2*r_T+1)^2, 6);
        a=0;

        for x=-r_T:+r_T
           for y=-r_T:+r_T 
               
               a=a+1;
               
               w_dp=[x, 0, y, 0, 1, 0;
                     0, x, 0, y, 0, 1];
              
               i_dp(a,:)=gradients(a, :)*w_dp;
              
           end
        end
        
%         discent=[];
%         for h=1:size(i_dp, 2)
%             pappa=reshape(i_dp(:, h), [2*r_T+1, 2*r_T+1]);
%             discent=[discent, pappa];
%         end
%         
%         
%         
%         subplot(3,1,3);
%         imagesc(discent);
%         axis equal;
%         title('Steepest discent');
        
        H=i_dp.'*i_dp;
        
        i_=patch(:);
        
        dp=H\(i_dp.'*(i_R-i_));
        
        p_hist=[p_hist, p_hist(:, end)+dp];
    end
    
    W=reshape(p_hist(:, end), [2, 3]);
end
        
        
