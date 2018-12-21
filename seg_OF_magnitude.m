function [binMap] = seg_OF_magnitude(U,V,th)
% Input: U,V – the optical flow Th: is a threshold
% Output: a binary map.
% Output: segmented image – each segment in a different color.

binMap = sqrt(U.*U+V.*V)>th;
%binMap = bwlabel(binMap); 


end

