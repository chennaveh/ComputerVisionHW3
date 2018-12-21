%Script HW3
clear all;clc;
vid = VideoReader('DATA-Set-A-2018\SLIDE.avi');
mov=read(vid);

%Lucas-Kanade Params:
windowsSize=2;
FrameDistance = 2;

%running the OF with different params (windowSize, FrameDistance, Different
%pairs)
FrameIdx = 1;
for scale=0.3:0.5:0.9
    for w=windowsSize:windowsSize+4
        for j=FrameDistance:1:30
            for i=1:30:size(mov,4)-j
                im=rgb2gray(mov(:,:,:,i)); %covert to gray scale
                im=imresize(im,scale); %resize the image
                % Raw(:,:,FrameIdx)=im;
                
                im2=rgb2gray(mov(:,:,:,i+j)); %covert to gray scale
                im2=imresize(im2,scale); %resize the image
                
                %%% put here your optical flow results on im and its successive frame using quiver
                [U,V]= OF(im,im2, 8, w);
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
                D2d(:,:,1) = U_median;
                D2d(:,:,2) = V_median;
                newFrame = imwarp(im,D2d);
                
                figure;
                imshowpair(im,im2);
                title(['Frame #' num2str(i) ', differ from frame # ' num2str(i+j)]);
                figure
                imshowpair(im,newFrame); %TODO - arrange here
                title(['Frame #' num2str(i) ', and OF relate to frame # ' num2str(i+j) ', win size=' num2str(w)]);
                
                
                %% Part B
                
                th= 3.8375e-08;
                binMap = seg_OF_magnitude(U,V,th);
                figure;
                imshow(binMap,[]);
                title(['Seg_Mag:Frame #' num2str(i) ', and relate to frame # ' num2str(i+j) ', win size=' num2str(w)]);
                
                %Raw(:,:,FrameIdx)=double(binMap).*double(im);
                %FrameIdx=FrameIdx+1;
                
                th=90;
                binMap = seg_OF_orientation(U,V,th);
                figure;
                imshow(binMap,[]);
                title(['Seg_Orientation:Frame #' num2str(i) ', and relate to frame # ' num2str(i+j) ', win size=' num2str(w)]);
                
                
            end
        end
    end
end

% save results
%SaveVideo(uint8(Raw), 'OF_results', vid.FrameRate);


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

