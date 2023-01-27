function M=estimatePoseDLT(p, P, K)
    pt=K^(-1)*p;
    Q=partialm(pt, P);
    [U, S, V] = svd(Q);
    M=V(:, 12);
    M=reshape(M, [4, 3]);
    M=M.';
    if M(3,4)<0
        M=-1*M;
end

    