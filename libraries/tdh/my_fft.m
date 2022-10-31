function [f Sy] = my_fft(t,y)
%
% [f Sy] = my_fft(t,y)
%
% time grid (must be uniform, even spacing), in DAYS
% displacement, etc.

L = length(t);
if rem(L,2) == 1
    t = t(1:L-1);
    y = y(1:L-1);
end
del = t(2)-t(1);

            k=(2*pi/L)*[0:L/2-1 -L/2:-1]; ks=fftshift(k);
            f = ks*(1/del)/(2*pi);

            Y = 1/(1/del)*fft(y);                        
            Sy = fftshift(Y.*conj(Y))/(1/(1/del)*L);