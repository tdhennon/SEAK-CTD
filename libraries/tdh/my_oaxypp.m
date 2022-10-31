function [zi,zer,zm]=oaxyqpp(x,y,z,xi,yi,xcor,ycor,err,npts)
%
% function [zi,zer,zm]=oaxyqpp(x,y,q,z,xi,yi,qi,xcor,ycor,qcor,err,npts)
%
% Makes an objective map point by point first demeaning 
% data by removing a covariance weighted mean
%
% This one assumes a gaussian covariance function
%
% z is the variable to be mapped. x and y are the 
% locations of the data and q is a third correlation 
% variable (meant to be the planetary potentail 
% vorticity q=f/H where f is the Coriolis parameter 
% and H is the total water depth.  
% xcor and ycor are the x and y correlation lengths.
% qcor is the potential vorticity correlation length.
% err is the error energy. 
% npts is the number of points to use nearest each
% grid point.  
% the output zi is at locations xi and yi with 
% qi being the planetary potential vorticity at 
% those gridpoints.  
% zer is the associated map error, and zm is the 
% weighted planar fit
%
% loops through the grid point by point, picking 
% out the npts data points closest to each grid point 
% for the inversion
%
% G. C. Johnson 12/1/93
%

% square the correlation lengths

xcor2=xcor*xcor;
ycor2=ycor*ycor;
%qcor2=qcor*qcor;

% make sure x, y, and z are vectors.

x=x(:);
y=y(:);
z=z(:);

% get various dimensions

m=size(xi);
n=length(z);
o=min([npts,n]);

% set up mapping grids

zi=NaN*xi;
zer=NaN*xi;
zm=NaN*xi;

% make grids into vectors for mapping puposes

xi=xi(:);
yi=yi(:);
%qi=qi(:);

% loop through the mapping grid 
% point by grid point to conserve memory

for i=1:length(xi)

xxi=xi(i);
yyi=yi(i);
%qqi=qi(i);

% Find the o (npts or less) data points closest to each grid point and 
% calculate their cross covariances with this grid point
arg=-(xxi*ones(1,n)-x').^2/xcor2-...
     (yyi*ones(1,1)-y').^2/ycor2;%-(qqi*ones(1,1)-q').^2/qcor2;
[ss,tt]=sort(-arg);
jj=tt(1:o);

c=exp(arg(jj));

xx=x(jj);
yy=y(jj);
%qq=q(jj);
zz=z(jj);

% Calculate the covariance matrix for 
% these o closest data points adding 
% in the error
arg=-(xx*ones(1,o)-ones(o,1)*xx').^2/xcor2-...
     (yy*ones(1,o)-ones(o,1)*yy').^2/ycor2;%-(qq*ones(1,o)-ones(o,1)*qq').^2/qcor2;
 
E=exp(arg)+err*eye(o);

% Take the weighted mean out
mean_coefs=sum(c(:).*zz(:))/sum(c);
zz=zz-mean_coefs;

% Calculate the objective map and add the weighted mean 
% back in.
zi(i)=(c*(E\zz))+mean_coefs;

% Calculate the error map.
zer(i)=1-sum(c'.*(E\c'));

% Calculate the weigthed mean map
zm(i)=mean_coefs;

% end mapping loop
end


