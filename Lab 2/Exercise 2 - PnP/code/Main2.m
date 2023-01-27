clear all
clc
K=load('data/K.txt');
pWc=0.01*load('data/p_W_corners.txt');
dc=load('data/detected_corners.txt');
quat=[];
ti=[];
%{
i=1;

pi=extraction(i, dc);

M=estimatePoseDLT(pi, pWc, K);

R=M(1:3, 1:3);
t=M(1:3, 4);

[U, Sig, Vt]=svd(R);
Rt=U*Vt';

alpha=norm(Rt)/norm(R);

Mt=[Rt, alpha*t];

[p_r] = reprojectPoints(pWc, Mt, K);


A=imread('data/images_undistorted/img_0001', 'jpg');

figure(1)
imshow(A)
hold on
plot(p_r(1,:), p_r(2,:), 'o')
plot(pi(1,:), pi(2,:), '+')
legend('Original points','Reprojected points')
hold off

Rti=Mt(1:3,1:3);
tti=Mt(1:3, 4);
Rti=Rti';
quat=rotMatrix2Quat(Rti);
ti=-0.01*Rti*tti;
%}

for i=1:210

    pi=extraction(i, dc);

    M=estimatePoseDLT(pi, pWc, K);

    R=M(1:3, 1:3);
    t=M(1:3, 4);

    [U, Sig, Vt]=svd(R);
    Rt=U*Vt';

    alpha=norm(Rt)/norm(R);

    Mt=[Rt, alpha*t];

    [p_r] = reprojectPoints(pWc, Mt, K);


    A=imread('data/images_undistorted/img_0001', 'jpg');
    
    %{
    figure(1)
    imshow(A)
    hold on
    plot(p_r(1,:), p_r(2,:), 'o')
    plot(pi(1,:), pi(2,:), '+')
    legend('Original points','Reprojected points')
    hold off
    %}
    
    Rti=Mt(1:3,1:3);
    tti=Mt(1:3, 4);
    Rti=Rti';
    quat=[quat, rotMatrix2Quat(Rti)];
    ti=[ti, 0.01*Rti*tti];
end

plotTrajectory3D(30, ti, quat, pWc.')


