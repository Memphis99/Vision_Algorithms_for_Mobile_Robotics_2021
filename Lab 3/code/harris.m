function scores = harris(img, patch_size, kappa)
    sobel=[-1 0 1;
           -2 0 2;
           -1 0 1];
       
    Ix=conv2(img, sobel, 'valid'); % (h-2)x(w-2) because sobel filter
    Iy=conv2(img, sobel.', 'valid'); % is 3x3, 1 col/row per edge per remain invalid
                                     % (h-3+1)x(w-3+1)
    
    Ix2=Ix.^2;
    Iy2=Iy.^2;
    IxIy=Ix.*Iy;
    M11=conv2(Ix2, ones(patch_size), 'valid'); % (h-p_s-1)x(w-p_s-1) because
    M22=conv2(Iy2, ones(patch_size), 'valid'); % it makes invalid other p_s-1 col/rows
    M12=conv2(IxIy, ones(patch_size), 'valid'); %(h-2 - (p_s-1))x(w-2 - (p_s-1))
    
    det=M11.*M22 - M12.^2;
    trace2=(M11+M22).^2;
    
    R=det-kappa*trace2;
    
    scores=padarray(R, [(1 + patch_size)/2, (1 + patch_size)/2], 0, 'both'); %put the invalid edges at 0, R is hxw
end
