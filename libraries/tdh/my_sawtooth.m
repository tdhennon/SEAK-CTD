function [AMP PHA ASY OFF yearday amp phase offset] = my_sawtoothfit(t,y)

%t = datenum(2008,1,1):10:datenum(2012,1,1);
%y = 4*sawtooth(t/365.25*2*pi+pi,.8)+8+randn(size(t))*1;

id = find(isnan(y)==0);
t = t(id);
y = y(id);


[amp,phase,frac,offset,yy] = fit_harmonics(y,t,1,365.25,.0001);
    cosfit = amp*cos(2*pi*1*t/365.25+phase)+offset;

    asy = 0:.01:1;
    pha = -pi:.04:pi;
    
    for i = 1:length(asy)
        for j = 1:length(pha)
           
            tempsawfit = amp*sawtooth(t*2*pi/365.25+pha(j),asy(i))+offset;
            varfit(i,j) = 1-var(y-tempsawfit)/var(y);
            
        end
    end
    
    [ida idp] = find(max(max(varfit)) == varfit);
        ASY = asy(ida); ASY = ASY(1);
        PHA = pha(idp); PHA = PHA(1);     
    
    amp2 = linspace(.5*amp,4*amp,50); clear varfit;
    for i = 1:length(amp2)
        tempsawfit = amp2(i)*sawtooth(t*2*pi/365.25+PHA,ASY)+offset;
         varfit(i) = 1-var(y-tempsawfit)/var(y);
    end
    ida = find(max(varfit) == varfit);
        AMP = amp2(ida);
        OFF = offset;
     
    sawfit = AMP*sawtooth(t*2*pi/365.25+PHA,ASY)+OFF;

    [a id] = max(sawfit);
        tmax = t(id);
        t0 = datenum(2000,1,1);

    while t0 + 365.25 < tmax
        t0 = t0+365.25;
    end
        yearday = tmax-t0;
    
        
