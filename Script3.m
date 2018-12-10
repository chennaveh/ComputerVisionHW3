%Script HW3

vid = VideoReader('SLIDE.avi');
mov=read(vid);

currAxes = axes;
for i=1:size(mov,4)
   im=rgb2gray(mov(:,:,:,i)); %covert to gray scale
   im=resize(im,0.3); %resize the image
   imshow(im,[]);
    hold on;
    
    %%% put here your optical flow results on im and its successive frame using quiver
    pause(0.1);
    hold off;
end
    