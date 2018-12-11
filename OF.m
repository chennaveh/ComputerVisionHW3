function [U,V]=OF(F1,F2, Sigma_S, Region)
%OF - Computing OF using Lucas-Kanade
%   F1,F2: two frames from a sequence.
%   Region is the local neighborhood window for computing the matrix A.
%   Sigma_S = spatial Gaussian smoothing parameter

w=Region;
[H,W] = size(F1);
U = zeros(size(F1));
V = zeros(size(F1));

Ix_m = conv2(F1,[-1 1; -1 1], 'same'); % derivetive on x
Iy_m = conv2(F1, [-1 -1; 1 1], 'same'); % derivetive on y
It_m = conv2(F1, ones(2), 'same') + conv2(F2, -ones(2), 'same'); % derivetive on t

for j=w+1:H-w
    for i=w+1:W-w
        b = -It_m(j-w:j+w,i-w:i+w); % define b
        
        Ix_m_temp = Ix_m(j-w:j+w,i-w:i+w);
        Iy_m_temp = Iy_m(j-w:j+w,i-w:i+w);
        A = [Ix_m_temp(:) Iy_m_temp(:)]; % define A
        
        %calc pinv(A) with weights matrix A+ = (A'A)^-1*A'
        C = imgaussfilt(A'*A,Sigma_S);
        if rank(C)==2
            uv = C*A'*b(:); % get velocity here
        end
        U(j,i)=uv(1);
        V(j,i)=uv(2);
    end
end
end

