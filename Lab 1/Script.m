clear all
clc


A=imread('img_0001', 'jpg');
B=rgb2gray(A);

size=0.04;
[Px, Py]=meshgrid(0:8, 0:5);
Pwc=size*[Px(:) Py(:)];
Pwc=[Pwc zeros(9*6, 1)].';

poses = importdata('poses.txt');

w=poses(1, 1:3);

t=poses(1, 4:6);

W=w.';
T=t.';

a=norm(W);
K=W/a;
Kx=[0, -K(3), K(2);
    K(3), 0, -K(1);
    -K(2), K(1), 0];

R=eye(3) + sin(a)*Kx + (1-cos(a))*(Kx)^2;

Rt=[R, T];

k=importdata('K.txt');
d=importdata('D.txt');

Pw=Rt*[Pwc; ones(1, 9*6)];
P=k*Pw;
P=P./P(3, :);

figure()
imshow(A)
hold on
plot(P(1,:), P(2,:), 'r.')
hold off

offsetx=size*3;
offsety=size*1;
s=size*2;
[X, Y, Z] = meshgrid(0:1, 0:1, -1:0);
p_W_cube = [offsetx + X(:)*s, offsety + Y(:)*s, Z(:)*s]';
p_C_cube = Rt * [p_W_cube; ones(1,8)]
