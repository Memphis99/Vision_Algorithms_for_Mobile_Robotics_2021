function scores = shi_tomasi(img, patch_size)
    sobel=[-1 0 1;
           -2 0 2;
           -1 0 1];
    
       
    %Image derivatives in x and y dir. through convolution with sobel
    Ix=conv2(img, sobel, 'valid'); % (h-2)x(w-2) because sobel filter
    Iy=conv2(img, sobel.', 'valid'); % is 3x3, 2 edges remain invalid
                                     % (h-3+1)x(w-3+1)
                                     
                                     
    %Create partial matrices to find then the M parameters
    Ix2=Ix.^2;
    Iy2=Iy.^2;
    IxIy=Ix.*Iy;
    
    %M11 is a matrix with the first parameter value of M for every pixel,
    %M22 and M12 the same
    M11=conv2(Ix2, eye(patch_size), 'valid'); % (h-p_s-1)x(w-p_s-1) because
    M22=conv2(Iy2, eye(patch_size), 'valid'); % it makes invalid other p_s-1 edges
    M12=conv2(IxIy, eye(patch_size), 'valid'); %(h-2 - (p_s-1))x(w-2 - (p_s-1))
    
    %Create the scores matrix for the non edge pixels
    %R=min(eig1, eig2), formula at https://math.stackexchange.com/questions/8672/eigenvalues-and-eigenvectors-of-2-times-2-matrix
    R=0.5*(M11 + M22 - (M11.^2 + 4*M12.^2 - 2*M11.*M22 + M22.^2).^0.5);
    
    %Create the final score matrix, every pixel has a value
    scores=padarray(R, [(1 + patch_size)/2, (1 + patch_size)/2], 0, 'both'); %put the invalid edges at 0, R is hxw
end
    
    
    
    
