function [binMap] = seg_OF_orientation(U,V,th)
%Input: U,V -- optical flow
%Th: is a threshold
%Output: a binary map.

binMap = atan(V ./ U);
Idx = kmeans(binMap(:),360/th);
binMap = reshape(Idx,size(U));

end