function Q=partialm(pt, P)
    Q=[];
    pt=pt.';
    for i=1:12
        q=[P(i, 1), P(i, 2), P(i, 3), 1, 0, 0, 0, 0, -pt(i, 1)*P(i, 1), -pt(i, 1)*P(i, 2), -pt(i, 1)*P(i, 3), -pt(i, 1);
           0, 0, 0, 0, P(i, 1), P(i, 2), P(i, 3), 1, -pt(i, 2)*P(i, 1), -pt(i, 2)*P(i, 2), -pt(i, 2)*P(i, 3), -pt(i, 2)];
        Q=[Q; q];
    end
end