function [specnsm,spec_raw,fm,km,datap,datam]=normalized_2D_spectrum(phi,zaxis,timeaxis)

% specnsm = normalized spectrum (so all k bands have equal variance?)
% fm = freq grid
% km = wavenumber grid
% datap = 

%[Z,T]=size(phi);
dt=nanmean(diff(timeaxis));
dz = nanmean(diff(zaxis));
data=fillmissing(phi,'linear');
data=detrend(detrend(data.').');
[m,n]=size(data);
win=hamming(m) * hamming(n).';

% fn=1/2/dt;
% kn=1/2/dz;
%fundamental frequency and wavenumber
df=1./n./dt;
dk=1./m./dz;

f=[-fliplr(1:(n/2)) 0 (1:(n/2))].*df;
k=[-fliplr(1:(m/2)) 0 (1:(m/2-1))].'.*dk;

% Make a matrix of group velocity values
%We'll want to sum cgE over the -k, -omega part of the spectrum to get downward energy flux
[fm,km]=meshgrid(f,k);
st1=fftshift(fft2(data))/m/n;
st=fftshift(fft2(data.*win))/m/n;
%normalization: with matlab's fft2, if st=fft2(data), then sum(sum(st.*conj(st)))/m/n is the same as
%sum(sum(data.*conj(data))).
%Hence we normalize the transform such that Parseval's theorem is upheld.
%So the spectrum is then given by
spec=st.*conj(st)./df./dk; %UNITS: (m/s)^2/cpd/cpm
spec1=st1.*conj(st1)./df./dk; %UNITS: (m/s)^2/cpd/cpm

%And has the property that sum(sum(spec)*df*dk is the variance.
% integrals
speck=sum(spec,2)*df; %wavenumber spectrum.  UNITS: (m/s)^2/cpm
specn=spec./repmat(speck,1,n); % %normalized "Pinkel" spectrum for vel

speck1=sum(spec1,2)*df; %wavenumber spectrum.  UNITS: (m/s)^2/cpm
specn1=spec1./repmat(speck1,1,n); % %normalized "Pinkel" spectrum for vel

% smooth a little bit the normalized spectra
specnsm=smoothdata(specn,'movmean',3);
specnsm=smoothdata(specnsm.','movmean',3).';

if 1
   varOrig = var(data(:));
   xx = data.*win;
   varWind = var(xx(:));
   ratio = varOrig/varWind;
   spec_raw = spec*ratio;
else
    spec_raw= spec; 
end


indkp=k>0.005;
indkm=k<-0.005;
%indf=(f>-0.8 & f<-0.2);
indf=(f<-0.2);
%indfm=f<0;
stp=st1*0;
stm=st1*0;
stp(indkp,indf)=spec1(indkp,indf);
stm(indkm,indf)=spec1(indkm,indf);
datap=ifft2(ifftshift(stp));
datam=ifft2(ifftshift(stm));


end

