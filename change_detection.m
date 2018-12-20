function [output] = change_detection(seq, th)
% This func calculates the median and segments the pixels which differ more
% than th from the median. The func returns bin sequence.

% calc median
med_mask = median(seq, 3);

% apply to seq
output = zeros(size(seq));
for i=1:size(seq, 3)
    output(:,:,i) = abs(seq(:,:,i) - med_mask) > th;
    
% improvments

    
    % hole filling
    output(:,:,i) = imfill(output(:,:,i));
    
    % median filter
    output(:,:,i) = medfilt2(output(:,:,i), [5 5]);
    
end


end

