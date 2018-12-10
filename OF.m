function [U,V]=OF(F1,F2, Sigma_S, Region)
%OF - Computing OF using Lucas-Kanade
%   F1,F2: two frames from a sequence.
%   Region is the local neighborhood window for computing the matrix A.
%   Sigma_S = spatial Gaussian smoothing parameter

j=Region(1);
i=Region(2);
w=Region(3);

im1_region = F1(j-w:j+w,i-w:i+w);
im2_region = F2(j-w:j+w,i-w:i+w); 

Ix_m = conv2(im1_region,[-1 1; -1 1], 'same'); % derivetive on x
Iy_m = conv2(im1_region, [-1 -1; 1 1], 'same'); % derivetive on y
It_m = conv2(im1_region, ones(2), 'same') + conv2(im2_region, -ones(2), 'same'); % derivetive on t

b = -It_m(:); % define b
A = [Ix_m(:) Iy_m(:)]; % define A

%calc pinv(A) with weights matrix A+ = (A'A)^-1*A'
C = imgaussfilt(A'*A,Sigma_S);
if rank(C)==2
    uv = C*A'*b; % get velocity here  
end

U=uv(1);
V=uv(2);
end

