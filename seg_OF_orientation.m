function [binMap] = seg_OF_orientation(U,V,th)
%Input: U,V -- optical flow
%Th: is a threshold
%Output: a binary map.

binMap = atan(U ./ V);
binMap = bwlabel(binMap); 



%find?? in order to indicate each area with different color
%???Note that any segmentation should be a connected component.???

end