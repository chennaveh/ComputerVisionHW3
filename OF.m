function [U,V]=OF(F1,F2, Sigma_S, Region)
%OF - Computing OF using Lucas-Kanade
%   F1,F2: two frames from a sequence.
%   Region is the local neighborhood window for computing the matrix A.
%   Sigma_S = spatial Gaussian smoothing parameter

w=Region;
[H,W] = size(F1);
U = zeros(size(F1));
V = zeros(size(F1));

% calculate derivatives
mask_size = round(2 * Sigma_S) + 1;
G_dx = Deriv_Gauss_x(Sigma_S, mask_size);
G_dy = Deriv_Gauss_y(Sigma_S, mask_size);

Ix_m = conv2(F1,G_dx, 'same'); % derivetive on x - TODO we receive here really large values
Iy_m = conv2(F1,G_dy, 'same'); % derivetive on y
%It_m = conv2(F1, ones(2), 'same') + conv2(F2, -ones(2), 'same'); % derivetive on t
It_m = F2-F1; % derivetive on t


Ix_m=PadMatrix(Ix_m,Region);
Iy_m=PadMatrix(Iy_m,Region);
It_m=PadMatrix(It_m,Region);

for j=1:H
    for i=1:W
        b = -It_m(j:j+w,i:i+w); % define b
        Ix_m_temp = Ix_m(j:j+w,i:i+w);
        Iy_m_temp = Iy_m(j:j+w,i:i+w);
        A = [Ix_m_temp(:) Iy_m_temp(:)]; % define A
        
        %calc pinv(A) with weights matrix A+ = (A'A)^-1*A'
        %C = imgaussfilt(A'*A,Sigma_S);
        C = pinv(A'*A); %TODO - need to add W
        %if det(C)-trace(C)>th %in order to optimize the running
        if rank(C)==2
            uv = C*A'*b(:); % get velocity here
        end
        U(j,i)=uv(1);
        V(j,i)=uv(2);
    end
end
end



function [output] = PadMatrix(matrix2pad, window)
% generate new image with enhanced values
padded = zeros(size(matrix2pad,1)+ 2*window,size(matrix2pad,2)+ 2*window); % pad zero frame
padded(window:end-window-1, window:end-window-1) = matrix2pad;
output=padded;
end

function [output] = Deriv_Gauss_x(sigma, mask_size)
% generate one directional gaussian derivative
x = meshgrid(linspace(-((mask_size)/2 ), (mask_size)/2 , mask_size));
output = -x.*(exp(-(x.^2)/(2*sigma^2))).*(sigma^4);
% output = output./sum(output(:));
end

function [output] = Deriv_Gauss_y(sigma, mask_size)
% generate one derictional gaussian window using transpose
output = Deriv_Gauss_x(sigma, mask_size)';
end