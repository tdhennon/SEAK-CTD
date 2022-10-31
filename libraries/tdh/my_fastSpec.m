function [fk S] = my_fastSpec(dx,x) 

%fk = frequency grid
% S = spectral amplitude

%dx = temporal spacing
% x = time series 

L = length(x);
k=(2*pi/L)*[0:L/2-1 -L/2:-1]; ks=fftshift(k);
fk = ks*(1/dx)/(2*pi);

s = dx*fft(detrend(x));
S = fftshift(s.*conj(s))/(dx*(L-1));

idp = find(fk > 0);
fk = fk(idp); % take only positive frequencies (this program is just for when 'x' is always real/non-imaginary)
S  = S(idp)*2; % Double it for symmetric spectra (always case when 'x' is not complex)

if length(fk)~= length(S)
    S = S(1:length(fk));
end

