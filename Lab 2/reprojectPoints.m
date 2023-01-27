function [p_reprojected]=reprojectPoints(P, M, K)
    Pt=[P, ones(12,1)].';
    for i=1:12
        p_reprojected(i, :)=[K*M*Pt(:,i)].';
    
        p_reprojected(i, :)=p_reprojected(i, :)/p_reprojected(i, 3);
    end
    p_reprojected=p_reprojected.';
end