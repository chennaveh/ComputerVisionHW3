


clear all;
clc;

F1 = zeros(100,100);
F1(30:60,30:60)=ones(31,31);


F2 = zeros(100,100);
F2(40:70,40:70)=ones(31,31);

figure;
imshowpair(F1,F2);

[U,V] = OF(F1,F2,3,8);
[X,Y]=meshgrid(1:size(F1,2),1:size(F1,1));
U_median=medfilt2(U,[5 5]);
V_median=medfilt2(V,[5 5]);
figure; imshow(F1,[]);
hold on;
quiver(X,Y,U_median,V_median,5);
%quiver(X(1:5:end,1:5:end),Y(1:5:end,1:5:end),U(1:5:end,1:5:end),V(1:5:end,1:5:end),5);
%Note: you can play with the last argument (here it is 5). You can also decide to display only pixels with OF higher than a given threshold.
hold off;

