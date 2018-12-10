%Script HW3
clear all;clc;
vid = VideoReader('DATA-Set-A-2018\SLIDE.avi');
mov=read(vid);

%Lucas-Kanade Params:
windowsSize=2;
FrameDistance = 2;

currAxes = axes;
for i=1:20:size(mov,4)-FrameDistance
    im=rgb2gray(mov(:,:,:,i)); %covert to gray scale
    im=imresize(im,0.3); %resize the image
    imshow(im,[]);
    hold on;
    [H,W] = size(im);
    im2=rgb2gray(mov(:,:,:,i+FrameDistance)); %covert to gray scale
    im2=imresize(im2,0.3); %resize the image
    
    U = zeros(H,W);
    V = zeros(H,W);
    %%% put here your optical flow results on im and its successive frame using quiver
    for s=windowsSize+1:H-windowsSize
        for t=windowsSize+1:W-windowsSize
            [U(s,t),V(s,t)]= OF(im,im2, 3, [s,t,windowsSize]);
        end
    end

    %display results:
    [X,Y]=meshgrid(1:size(im,2),1:size(im,1));
    U_median=medfilt2(U,[5 5]);
    V_median=medfilt2(V,[5 5]);
    figure; imshow(im,[]);
    hold on;
    quiver(X,Y,U,V,5);
    %quiver(X(1:5:end,1:5:end),Y(1:5:end,1:5:end),U(1:5:end,1:5:end),V(1:5:end,1:5:end),5);
    %Note: you can play with the last argument (here it is 5). You can also decide to display only pixels with OF higher than a given threshold.
    pause(0.1);
    hold off;
    
    %Part A q.6 - Evaluation
    D2d = zeros(size(im,1),size(im,2),2);
    D2d(:,:,1) = U; %TODO - check the index here
    D2d(:,:,2) = V; %TODO - check the index here
    newFrame = imwarp(im,D2d);
    
    SumDiffereance = sum(abs(im-newFrame),'all');
    imshowpair(im,im2); %TODO - arrange here
    imshowpair(im,newFrame);
end

%%
%write avi file:

% for i=1:10, seq3(:,:,:,i)=imread(sprintf('people2_%d.jpg',i),'jpg'); end;
% vidObj = VideoWriter('people.avi');
% open(vidObj);
% for i=1:10, writeVideo(vidObj,seq3(:,:,:,i)); end
% close(vidObj);
    