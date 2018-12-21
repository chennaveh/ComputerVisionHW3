%Script HW3
clear all;clc;
vid = VideoReader('DATA-Set-A-2018\SLIDE.avi');
mov=read(vid);

%Lucas-Kanade Params:
windowsSize=3;
FrameDistance = 2;

%currAxes = axes;
%running the OF with different params (windowSize, FrameDistance, Different
%pairs)
for scale=0.3:0.2:0.8
    for w=windowsSize:8
        for j=FrameDistance:10:30
            for i=1:20:size(mov,4)-j
                im=rgb2gray(mov(:,:,:,i)); %covert to gray scale
                im=imresize(im,scale); %resize the image
                
                im2=rgb2gray(mov(:,:,:,i+j)); %covert to gray scale
                im2=imresize(im2,scale); %resize the image
                
                %%% put here your optical flow results on im and its successive frame using quiver
                [U,V]= OF(im,im2, 3, w);

                %display results:
                [X,Y]=meshgrid(1:size(im,2),1:size(im,1));
                U_median=medfilt2(U,[5 5]);
                V_median=medfilt2(V,[5 5]);
                figure; imshow(im,[]);
                title(['Frame #' num2str(i) ', and OF relate to frame # ' num2str(i+j) ', win size=' num2str(w)]);
                hold on;
                quiver(X,Y,U_median,V_median,5);
                %quiver(X(1:5:end,1:5:end),Y(1:5:end,1:5:end),U(1:5:end,1:5:end),V(1:5:end,1:5:end),5);
                %Note: you can play with the last argument (here it is 5). You can also decide to display only pixels with OF higher than a given threshold.
                hold off;
                
                %Part A q.6 - Evaluation
                D2d = zeros(size(im,1),size(im,2),2);
                D2d(:,:,1) = U_median; %TODO - check the index here
                D2d(:,:,2) = V_median; %TODO - check the index here
                newFrame = imwarp(im,D2d);
                
                %SumDiffereance = sum(abs(im-newFrame),'all');
                figure;
                imshowpair(im,im2); 
                title(['Frame #' num2str(i) ', differ from frame # ' num2str(i+j)]);
                figure
                imshowpair(im,newFrame); %TODO - arrange here
                title(['Frame #' num2str(i) ', and OF relate to frame # ' num2str(i+j) ', win size=' num2str(w)]);
            
            
                %% Part B

                th=3;
                binMap = seg_OF_magnitude(U,V,th);
                imshow(binMap,[]);
                title(['Seg_Mag:Frame #' num2str(i) ', and relate to frame # ' num2str(i+j) ', win size=' num2str(w)]);
                
                th=8;
                binMap = seg_OF_orientation(U,V,th);
                imshow(binMap,[]);
                title(['Seg_Orientation:Frame #' num2str(i) ', and relate to frame # ' num2str(i+j) ', win size=' num2str(w)]);
                
                
            end
        end
    end
end




%%
%write avi file:

% for i=1:10, seq3(:,:,:,i)=imread(sprintf('people2_%d.jpg',i),'jpg'); end;
% vidObj = VideoWriter('people.avi');
% open(vidObj);
% for i=1:10, writeVideo(vidObj,seq3(:,:,:,i)); end
% close(vidObj);
%% PART C
clear all;clc;
input_vid = VideoReader('DATA-Set-A-2018\SLIDE.avi');
mov=read(input_vid);
seq = zeros(size(mov,1), size(mov,2), size(mov,4));
for i=1:size(mov, 4)
    seq(:,:,i) = rgb2gray(mov(:,:,:,i));
end
th = 15;
output_mask = change_detection(seq, th);

% save results
SaveVideo(uint8(output_mask .* seq), 'CD_results_hole_filling_median_filter', input_vid.FrameRate);



disp('Done');

