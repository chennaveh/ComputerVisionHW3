function [] = SaveVideo(sequence, name, framerate)

output_vid = VideoWriter([name '.avi']);
output_vid.FrameRate = framerate;
open(output_vid);
for i=1:size(sequence, 3)
    writeVideo(output_vid, sequence(:,:,i));
end
close(output_vid);
