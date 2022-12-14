function [fk, Sxx] = my_fastSpec_alb(dx,x)

%%

    L = length(x);
    k = (2*pi/L)*[0:L/2-1 -L/2:-1]; ks=fftshift(k);
   fk = ks*(1/dx)/(2*pi);
   fk = fk(end/2+1:end);
   dfk = fk(2)-fk(1);   


    window = hanning(L);
    wc2=1/mean(window.^2);% window correction factor
 

     Ax = window.*(detrend(x))';
     Sx=fft(Ax);
     Sxx=abs(fft(Ax)).^2;
     Sxx =Sxx./L^2/dfk*wc2;
     Sxx = 2*Sxx(1:end/2);
     
     
     
     
     