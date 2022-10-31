clear all; close all;

addpath('/Users/thennon/work/auxil/mfiles/rbr-rsktools/')

datadir = '../data/raw/210675/2022_09/';

fnames = dir([datadir '*.rsk']);


rsk = RSKopen([datadir fnames(2).name]);

abc = RSKreaddata(rsk);

abc = RSKdespike(abc,'channel','Salinity');


%def = RSKreadprofiles(rsk);
ghi = RSKtimeseries2profiles(abc);


%%

F = figure(1);clf
set(F,'position',[50 50 1200 600])

subplot(141)
    plot(abc.data.values(:,2),abc.data.values(:,3),'.');axis ij
    title('temp')
subplot(142)
    plot(abc.data.values(:,7),abc.data.values(:,3),'.');axis ij
    title('salt')
subplot(143)
    plot(abc.data.values(:,4),abc.data.values(:,3),'.');axis ij
    title('chlor')
subplot(144)
    plot(diff(abc.data.values(:,3))./diff(abc.data.tstamp)/3600/24,abc.data.values(1:end-1,3),'.');axis ij
    title('speed')


    %%

F = figure(1);clf
set(F,'position',[50 50 1200 600])

for ii = 2:2:length(ghi.data)
    
ax1 = subplot(131);

plot(ghi.data(ii).values(:,6),ghi.data(ii).values(:,3),'.-'); hold on; axis ij
xlim([30 32.75])

    
ax2 = subplot(132) ;

plot(ghi.data(ii).values(:,2),ghi.data(ii).values(:,3),'.-'); hold on; axis ij

ax3 = subplot(133);

plot(diff(ghi.data(ii).values(:,3))./diff(ghi.data(ii).tstamp)/3600/24,ghi.data(ii).values(1:end-1,3),'.-');hold on
axis ij
hold on




end
plot([0 0],[0 200],'k--')

linkaxes([ax1 ax2 ax3],'y')

%%





